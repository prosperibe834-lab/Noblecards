import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';

class WithdrawNotificationCard extends StatelessWidget {
  final String message;

  const WithdrawNotificationCard({
    Key? key,
    this.message = 'You will be notified once the funds have been successfully credited.',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.s),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(Boxicons.bx_shield_quarter, color: AppColors.primary, size: 24),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}