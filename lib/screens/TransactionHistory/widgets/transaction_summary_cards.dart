import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_theme.dart';

class TransactionSummaryCards extends StatelessWidget {
  final double totalDeposits;
  final double totalWithdrawals;

  const TransactionSummaryCards({
    Key? key,
    required this.totalDeposits,
    required this.totalWithdrawals,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subTextColor = isDark ? AppColors.darkSubText : AppColors.lightSubText;

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Boxicons.bx_up_arrow_alt, color: AppColors.success),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Deposits', style: AppTextTheme.light.bodyMedium?.copyWith(color: subTextColor, fontSize: 12)),
                      const SizedBox(height: 2),
                      Text('\$${totalDeposits.toStringAsFixed(2)}', style: AppTextTheme.light.titleLarge?.copyWith(color: textColor, fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.accentViolet.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Boxicons.bx_down_arrow_alt, color: AppColors.accentViolet),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Withdrawals', style: AppTextTheme.light.bodyMedium?.copyWith(color: subTextColor, fontSize: 12)),
                      const SizedBox(height: 2),
                      Text('\$${totalWithdrawals.toStringAsFixed(2)}', style: AppTextTheme.light.titleLarge?.copyWith(color: textColor, fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}