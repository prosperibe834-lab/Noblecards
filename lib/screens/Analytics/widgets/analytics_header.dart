import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_text_theme.dart';

class AnalyticsHeader extends StatelessWidget {
  final VoidCallback onCalendarTap;

  const AnalyticsHeader({
    Key? key,
    required this.onCalendarTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subTextColor = isDark ? AppColors.darkSubText : AppColors.lightSubText;
    final btnBg = isDark ? AppColors.darkCard : AppColors.lightCard;

    return Container(
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            InkWell(
              onTap: () => Navigator.maybePop(context),
              borderRadius: BorderRadius.circular(AppRadius.full),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: btnBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(Boxicons.bx_chevron_left, color: textColor, size: 24),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Analytics',
                    style: AppTextTheme.light.titleLarge?.copyWith(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Track your activity and performance',
                    style: AppTextTheme.light.bodyMedium?.copyWith(
                      color: subTextColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: onCalendarTap,
              borderRadius: BorderRadius.circular(AppRadius.full),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: btnBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(Boxicons.bx_calendar, color: textColor, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}