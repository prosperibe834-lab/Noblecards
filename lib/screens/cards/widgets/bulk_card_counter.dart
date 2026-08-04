import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'package:noble_cards/theme/app_colors.dart';
import 'package:noble_cards/theme/app_radius.dart';
import 'package:noble_cards/theme/app_spacing.dart';
import 'package:noble_cards/theme/app_animation.dart';

class BulkCardCounter extends StatelessWidget {
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const BulkCardCounter({super.key, required this.quantity, required this.onAdd, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cards to Sell', style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: AppSpacing.xs),
            const Text('Add cards to sell in one batch', style: TextStyle(color: AppColors.lightSubText, fontSize: 12)),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightInput,
            borderRadius: BorderRadius.circular(AppRadius.full),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary.withValues(alpha: 0.1)),
                  child: Icon(Boxicons.bx_minus, size: 16, color: AppColors.primary),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AnimatedSwitcher(
                duration: AppAnimation.fast,
                child: Text(
                  '$quantity',
                  key: ValueKey(quantity),
                  style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              GestureDetector(
                onTap: onAdd,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
                  child: const Icon(Boxicons.bx_plus, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
