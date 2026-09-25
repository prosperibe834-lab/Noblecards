import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';

class TransactionHistoryError extends StatelessWidget {
  final VoidCallback onRetry;

  const TransactionHistoryError({Key? key, required this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Boxicons.bx_error_circle, size: 64, color: AppColors.error),
          const SizedBox(height: AppSpacing.md),
          const Text('Something went wrong', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: onRetry,
            child: const Text('Try Again', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}