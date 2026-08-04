import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:noble_cards/theme/app_colors.dart';
import 'package:noble_cards/theme/app_radius.dart';
import 'package:noble_cards/theme/app_spacing.dart';
import '../providers/buy_provider.dart';

class AmountInput extends StatelessWidget {
  const AmountInput({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BuyProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkInput : AppColors.lightInput;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Amount', style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Text(provider.currencySymbol, style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: TextFormField(
                  initialValue: provider.amount.toStringAsFixed(0),
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      provider.setAmount(double.tryParse(value) ?? provider.amount);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
