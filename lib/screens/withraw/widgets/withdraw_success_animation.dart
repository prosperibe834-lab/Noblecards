import 'dart:math';
import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';

class WithdrawSuccessAnimation extends StatefulWidget {
  const WithdrawSuccessAnimation({Key? key}) : super(key: key);

  @override
  State<WithdrawSuccessAnimation> createState() => _WithdrawSuccessAnimationState();
}

class _WithdrawSuccessAnimationState extends State<WithdrawSuccessAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.8, curve: Curves.easeInOut)),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 180,
      width: 180,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Confetti Particles
              CustomPaint(
                size: const Size(180, 180),
                painter: _ConfettiPainter(_controller.value),
              ),
              // Outer Glow Ring
              Transform.scale(
                scale: 1.0 + (_glowAnimation.value * 0.2),
                child: Opacity(
                  opacity: (1.0 - _glowAnimation.value) * 0.5,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(isDark ? 0.3 : 0.15),
                    ),
                  ),
                ),
              ),
              // Inner Success Circle
              Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: const Icon(
                    Boxicons.bx_check,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final double progress;
  _ConfettiPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0 || progress == 1) return;

    final center = Offset(size.width / 2, size.height / 2);
    final random = Random(42); // Fixed seed for consistent beautiful layout
    final colors = [
      AppColors.primary,
      AppColors.accent,
      AppColors.accentViolet,
      AppColors.info,
    ];

    for (int i = 0; i < 12; i++) {
      final angle = (i * (360 / 12)) * (pi / 180) + random.nextDouble();
      // Distance moves outward based on progress
      final distance = 60.0 + (progress * 40.0) + random.nextDouble() * 20.0;
      
      final x = center.dx + cos(angle) * distance;
      final y = center.dy + sin(angle) * distance;

      final paint = Paint()
        ..color = colors[i % colors.length].withOpacity(1.0 - progress)
        ..style = PaintingStyle.fill
        ..strokeCap = StrokeCap.round;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(progress * pi * 2 + random.nextDouble());
      
      if (i % 2 == 0) {
        canvas.drawRect(const Rect.fromLTWH(-4, -4, 8, 8), paint);
      } else {
        canvas.drawCircle(Offset.zero, 4, paint);
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => oldDelegate.progress != progress;
}