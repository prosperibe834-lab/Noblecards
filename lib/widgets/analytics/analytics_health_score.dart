import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

class AnalyticsHealthScoreCard extends StatelessWidget {
  final int score;
  final String status;
  final List<String> insights;

  const AnalyticsHealthScoreCard({
    Key? key,
    required this.score,
    required this.status,
    required this.insights,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          // Circular Score Gauge
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 8,
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.success,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$score',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Text(
                      '/100',
                      style: TextStyle(fontSize: 9, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.l),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Financial Health: ',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      status,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: insights.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Row(
                        children: [
                          const Icon(
                            Boxicons.bx_check,
                            color: AppColors.success,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
