import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../theme/app_theme.dart';
import '../theme/app_radius.dart';

import '../theme/app_colors.dart';

import '../theme/app_spacing.dart';

class WalletTransactionTile extends StatelessWidget {
  final String title;
  final String date;
  final double amount;
  final bool isDeposit;
  final String status;
  final VoidCallback onTap;

  const WalletTransactionTile({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
    required this.isDeposit,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: (isDeposit ? AppColors.success : AppColors.error).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isDeposit ? Boxicons.bx_down_arrow_alt : Boxicons.bx_up_arrow_alt,
            color: isDeposit ? AppColors.success : AppColors.error,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
        subtitle: Text(
          date,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${isDeposit ? '+' : '-'}\$${amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDeposit ? AppColors.success : (isDark ? AppColors.darkText : AppColors.lightText),
              ),
            ),
            Text(
              status,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.success,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
