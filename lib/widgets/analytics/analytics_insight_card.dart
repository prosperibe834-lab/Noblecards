import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

class AnalyticsInsightSection extends StatelessWidget {
  const AnalyticsInsightSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final insights = [
      {
        'title': 'Trading Momentum',
        'body':
            'You traded 18% more than last month. Keep up the high activity!',
        'icon': Boxicons.bx_rocket,
        'color': AppColors.primary,
      },
      {
        'title': 'Top Profit Driver',
        'body':
            'Apple Gift Cards generated your highest profit margin (+14.2%).',
        'icon': Boxicons.bx_trophy,
        'color': AppColors.success,
      },
      {
        'title': 'Peak Hours',
        'body': 'You trade mostly between 6:00 PM and 9:00 PM (WAT).',
        'icon': Boxicons.bx_time_five,
        'color': AppColors.info,
      },
    ];

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: insights.map((insight) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.s),
          padding: const EdgeInsets.all(AppSpacing.m),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: (insight['color'] as Color).withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (insight['color'] as Color).withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  insight['icon'] as IconData,
                  color: insight['color'] as Color,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      insight['title'].toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      insight['body'].toString(),
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
