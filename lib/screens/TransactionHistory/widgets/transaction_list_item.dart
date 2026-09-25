import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'package:intl/intl.dart';
import '../models/transaction_history_model.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_theme.dart';

class TransactionListItem extends StatelessWidget {
  final TransactionHistoryModel transaction;
  final VoidCallback onTap;

  const TransactionListItem({
    Key? key,
    required this.transaction,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subTextColor = isDark ? AppColors.darkSubText : AppColors.lightSubText;

    final isDeposit = transaction.type == TransactionType.deposit;
    final amountColor = isDeposit ? AppColors.success : textColor;
    final iconColor = isDeposit ? AppColors.success : AppColors.accentViolet;
    final iconBgColor = iconColor.withOpacity(0.15);
    final icon = isDeposit ? Boxicons.bx_download : Boxicons.bx_upload;
    
    final formattedDate = DateFormat('MMM dd, yyyy • hh:mm a').format(transaction.date);
    final amountPrefix = isDeposit ? '+' : '-';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
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
                color: iconBgColor,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isDeposit ? 'Deposit' : 'Withdrawal',
                    style: AppTextTheme.light.bodyLarge?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    transaction.method,
                    style: AppTextTheme.light.bodyMedium?.copyWith(
                      color: subTextColor,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formattedDate,
                    style: AppTextTheme.light.bodyMedium?.copyWith(
                      color: subTextColor,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$amountPrefix\$${transaction.amount.toStringAsFixed(2)}',
                  style: AppTextTheme.light.bodyLarge?.copyWith(
                    color: amountColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                _buildStatusBadge(transaction.status),
              ],
            ),
            const SizedBox(width: AppSpacing.sm),
            Icon(Boxicons.bx_chevron_right, color: subTextColor, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(TransactionStatus status) {
    Color color;
    String text;

    switch (status) {
      case TransactionStatus.completed:
        color = AppColors.success;
        text = 'Completed';
        break;
      case TransactionStatus.pending:
      case TransactionStatus.processing:
        color = AppColors.warning;
        text = 'Pending';
        break;
      case TransactionStatus.failed:
      case TransactionStatus.cancelled:
        color = AppColors.error;
        text = 'Failed';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}