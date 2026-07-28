import 'package:flutter/material.dart';
import 'dart:math';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

class AnalyticsDonutChartCard extends StatelessWidget {
  const AnalyticsDonutChartCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final categories = [
      {'name': 'Gaming', 'percentage': 35, 'color': AppColors.primary},
      {'name': 'Shopping', 'percentage': 25, 'color': AppColors.secondary},
      {'name': 'Streaming', 'percentage': 15, 'color': AppColors.info},
      {'name': 'Entertainment', 'percentage': 15, 'color': AppColors.accentViolet},
      {'name': 'Others', 'percentage': 10, 'color': Colors.orangeAccent},
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: CustomPaint(
              painter: DonutChartPainter(),
            ),
          ),
          const SizedBox(width: AppSpacing.l),
          Expanded(
            child: Column(
              children: categories.map((c) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: c['color'] as Color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            c['name'].toString(),
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Text(
                        '${c['percentage']}%',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}

class DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 18.0;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    double startAngle = -pi / 2;

    final slices = [
      {'pct': 0.35, 'color': AppColors.primary},
      {'pct': 0.25, 'color': AppColors.secondary},
      {'pct': 0.15, 'color': AppColors.info},
      {'pct': 0.15, 'color': AppColors.accentViolet},
      {'pct': 0.10, 'color': Colors.orangeAccent},
    ];

    for (var slice in slices) {
      final sweepAngle = (slice['pct'] as double) * 2 * pi;
      paint.color = slice['color'] as Color;
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}