import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:noble_cards/theme/app_colors.dart';
import 'package:noble_cards/theme/app_radius.dart';
import 'package:noble_cards/theme/app_spacing.dart';
import '../providers/buy_provider.dart';
import 'amount_chip.dart';

class AmountInputCard extends StatelessWidget {
  const AmountInputCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BuyProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final inputColor = isDark ? AppColors.darkInput : AppColors.lightInput;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final denominationValues = provider.availableDenominations.isEmpty
        ? [10.0, 25.0, 50.0, 100.0, 200.0]
        : provider.availableDenominations.map((value) => double.tryParse(value) ?? 0.0).where((value) => value > 0).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('How much do you want to buy?', 
          style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: inputColor,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Text(provider.currencySymbol, style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: TextFormField(
                  initialValue: provider.amount.toInt().toString(),
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (val) {
                    if (val.isNotEmpty) provider.setAmount(double.parse(val));
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Row(
                  children: [
                    Text(provider.currencyCode, style: TextStyle(color: textColor, fontWeight: FontWeight.w600)),
                    const Icon(Icons.keyboard_arrow_down, size: 16),
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: denominationValues.map((amount) {
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: AmountChip(
                  amount: amount,
                  isSelected: provider.amount == amount,
                  onTap: () => provider.setAmount(amount),
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}
