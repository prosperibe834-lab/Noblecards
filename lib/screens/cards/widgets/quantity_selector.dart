import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boxicons/boxicons.dart';
import 'package:noble_cards/theme/app_colors.dart';
import 'package:noble_cards/theme/app_radius.dart';
import 'package:noble_cards/theme/app_spacing.dart';
import '../providers/buy_provider.dart';

class QuantitySelector extends StatelessWidget {
  const QuantitySelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BuyProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subTextColor = isDark ? AppColors.darkSubText : AppColors.lightSubText;
    final btnBg = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quantity', style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w600)),
            Text('Number of cards', style: TextStyle(color: subTextColor, fontSize: 12)),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkInput : AppColors.lightInput,
            borderRadius: BorderRadius.circular(AppRadius.full),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: provider.decrementQuantity,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: btnBg),
                  child: Icon(Boxicons.bx_minus, size: 16, color: textColor),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  '${provider.quantity}',
                  key: ValueKey(provider.quantity),
                  style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              GestureDetector(
                onTap: provider.incrementQuantity,
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
