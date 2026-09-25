import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';

class TransactionHistoryEmptyState extends StatelessWidget {
  final VoidCallback onReset;

  const TransactionHistoryEmptyState({Key? key, required this.onReset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Boxicons.bx_receipt, size: 64, color: AppColors.primary.withOpacity(0.5)),
          const SizedBox(height: AppSpacing.md),
          Text('No transactions yet', style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Your deposits and withdrawals will appear here.',
            style: TextStyle(color: isDark ? AppColors.darkSubText : AppColors.lightSubText),
          ),
          const SizedBox(height: AppSpacing.lg),
          TextButton(
            onPressed: onReset,
            child: const Text('Refresh', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}