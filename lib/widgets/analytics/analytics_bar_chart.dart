import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

class AnalyticsBarChartCard extends StatelessWidget {
  const AnalyticsBarChartCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final data = [
      {'day': 'W1', 'in': 0.7, 'out': 0.3},
      {'day': 'W2', 'in': 0.9, 'out': 0.5},
      {'day': 'W3', 'in': 0.5, 'out': 0.4},
      {'day': 'W4', 'in': 0.8, 'out': 0.2},
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _cashFlowBadge('Money In', '\$42,100', AppColors.success),
              _cashFlowBadge('Money Out', '\$18,400', AppColors.error),
              _cashFlowBadge('Net Cash Flow', '+\$23,700', AppColors.primary),
            ],
          ),
          const SizedBox(height: AppSpacing.l),
          SizedBox(
            height: 140,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.map((item) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _bar(item['in'] as double, AppColors.success),
                        const SizedBox(width: 4),
                        _bar(item['out'] as double, AppColors.error),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['day'].toString(),
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _cashFlowBadge(String label, String val, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(
          val,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _bar(double heightPercent, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      width: 14,
      height: 100 * heightPercent,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}