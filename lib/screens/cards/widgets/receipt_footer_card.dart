import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';

class ReceiptFooterCard extends StatelessWidget {
  const ReceiptFooterCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.success.withOpacity(0.08) : AppColors.success.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.success.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Boxicons.bx_check_shield, color: AppColors.success, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Thank you for using NobleCards.\nWe\'ll notify you as soon as your cards are verified.',
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}