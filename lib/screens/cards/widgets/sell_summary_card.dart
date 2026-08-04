import 'package:flutter/material.dart';
import 'package:noble_cards/theme/app_colors.dart';
import 'package:noble_cards/theme/app_radius.dart';
import 'package:noble_cards/theme/app_spacing.dart';
import 'package:noble_cards/theme/app_animation.dart';

class SellSummaryCard extends StatelessWidget {
  final int cardCount;
  final double totalAmount;

  const SellSummaryCard({super.key, required this.cardCount, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkCard : AppColors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final labelColor = isDark ? AppColors.darkSubText : AppColors.lightSubText;
    final valueColor = isDark ? AppColors.darkText : AppColors.lightText;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: valueColor)),
          const SizedBox(height: AppSpacing.md),
          _buildRow('Total Cards', '$cardCount cards', labelColor: labelColor, valueColor: valueColor),
          const SizedBox(height: AppSpacing.sm),
          _buildRow('Total Amount', '\$${totalAmount.toStringAsFixed(2)}', labelColor: labelColor, valueColor: valueColor),
          const SizedBox(height: AppSpacing.sm),
          _buildRow('Sell Rate', '93.20%', labelColor: labelColor, valueColor: valueColor),
          const SizedBox(height: AppSpacing.sm),
          _buildRow('Estimated You Receive', '\$${(totalAmount * 0.932).toStringAsFixed(2)}', labelColor: labelColor, valueColor: valueColor),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Processing Time', style: TextStyle(color: labelColor, fontSize: 12)),
              Text('~5 minutes', style: TextStyle(fontWeight: FontWeight.w600, color: valueColor)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text('Last updated a few seconds ago', style: TextStyle(color: labelColor, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {required Color labelColor, required Color valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: labelColor, fontSize: 12)),
        Text(value, style: TextStyle(fontWeight: FontWeight.w700, color: valueColor)),
      ],
    );
  }
}
