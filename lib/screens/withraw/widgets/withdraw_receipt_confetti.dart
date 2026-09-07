import 'dart:math';
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class WithdrawReceiptConfetti extends StatelessWidget {
  const WithdrawReceiptConfetti({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 120),
      painter: _ConfettiPainter(),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(42); // Fixed seed for consistent beautiful layout
    final colors = [AppColors.primary, AppColors.accent, AppColors.info];

    for (int i = 0; i < 15; i++) {
      final paint = Paint()
        ..color = colors[i % colors.length].withOpacity(0.6)
        ..style = PaintingStyle.fill;

      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final sizeOffset = random.nextDouble() * 4 + 3;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(random.nextDouble() * pi);

      if (i % 2 == 0) {
        canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: sizeOffset, height: sizeOffset), paint);
      } else {
        canvas.drawCircle(Offset.zero, sizeOffset / 1.5, paint);
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}