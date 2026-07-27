import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_app_bar.dart';

import '../theme/app_colors.dart';

import '../theme/app_spacing.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: const CustomAppBar(title: 'Analytics'),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      color: AppColors.primary,
                      value: 60,
                      title: '60%',
                    ),
                    PieChartSectionData(
                      color: AppColors.secondary,
                      value: 40,
                      title: '40%',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
