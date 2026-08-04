import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';

class NotificationInfoCard extends StatelessWidget {
  const NotificationInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.success.withOpacity(0.1) : AppColors.success.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Boxicons.bx_check_shield, color: AppColors.success, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'You will receive a notification\nas soon as verification is complete.',
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
          ),
          Icon(Boxicons.bx_bell, color: AppColors.success.withOpacity(0.6), size: 24),
        ],
      ),
    );
  }
}