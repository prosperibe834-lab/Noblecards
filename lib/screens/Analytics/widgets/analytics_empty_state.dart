import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';

class AnalyticsEmptyState extends StatelessWidget {
  final VoidCallback onReset;

  const AnalyticsEmptyState({Key? key, required this.onReset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            Icon(Boxicons.bx_bar_chart_alt_2, size: 56, color: AppColors.primary.withOpacity(0.5)),
            const SizedBox(height: AppSpacing.sm),
            Text('No Activity Found', style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('There is no analytics data available for this range.', style: TextStyle(color: isDark ? AppColors.darkSubText : AppColors.lightSubText, fontSize: 12), textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.md),
            TextButton(onPressed: onReset, child: const Text('Reset Range', style: TextStyle(color: AppColors.primary))),
          ],
        ),
      ),
    );
  }
}