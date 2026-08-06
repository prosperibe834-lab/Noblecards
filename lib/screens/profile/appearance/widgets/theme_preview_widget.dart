import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';
import '../models/appearance_option.dart';

class ThemePreviewWidget extends StatelessWidget {
  final ThemeOption themeType;

  const ThemePreviewWidget({super.key, required this.themeType});

  @override
  Widget build(BuildContext context) {
    if (themeType == ThemeOption.system) {
      return SizedBox(
        width: 72,
        height: 100,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              _buildMiniApp(Brightness.light),
              ClipPath(
                clipper: _DiagonalClipper(),
                child: _buildMiniApp(Brightness.dark),
              ),
              // Split Line
              CustomPaint(
                size: const Size(72, 100),
                painter: _SplitLinePainter(),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: 72,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: _buildMiniApp(
          themeType == ThemeOption.dark ? Brightness.dark : Brightness.light,
        ),
      ),
    );
  }

  Widget _buildMiniApp(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F1722) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white54 : Colors.black54;
    final cardColor = isDark ? const Color(0xFF1A222D) : Colors.grey.shade50;

    return Container(
      color: bgColor,
      padding: const EdgeInsets.all(6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mini AppBar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Boxicons.bx_chevron_left, size: 10, color: textColor),
              Icon(Boxicons.bx_user_circle, size: 10, color: textColor),
            ],
          ),
          const SizedBox(height: 8),
          
          // Mini Balance
          Text(
            'Wallet Balance',
            style: TextStyle(fontSize: 5, color: subTextColor),
          ),
          const SizedBox(height: 2),
          Text(
            '\$2,450.80',
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 10),
          
          // Mini Quick Actions
          Text(
            'Quick Actions',
            style: TextStyle(fontSize: 5, color: subTextColor),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMiniActionCard(AppColors.success, Boxicons.bx_credit_card, 'Buy Card', cardColor, textColor),
              _buildMiniActionCard(Colors.orange, Boxicons.bx_refresh, 'Sell Card', cardColor, textColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniActionCard(Color iconColor, IconData icon, String text, Color bgColor, Color textColor) {
    return Container(
      width: 28,
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.black.withOpacity(0.02)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(icon, size: 6, color: Colors.white),
          ),
          const SizedBox(height: 3),
          Text(
            text,
            style: TextStyle(fontSize: 4, fontWeight: FontWeight.bold, color: textColor),
          ),
        ],
      ),
    );
  }
}

class _DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height * 0.4);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _SplitLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.4);
    path.lineTo(size.width, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}