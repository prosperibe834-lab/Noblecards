import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:noble_cards/theme/app_colors.dart';
import 'package:noble_cards/theme/app_radius.dart';
import 'package:noble_cards/theme/app_spacing.dart';
import '../providers/buy_provider.dart';
import 'amount_chip.dart';

class AmountInputCard extends StatefulWidget {
  const AmountInputCard({Key? key}) : super(key: key);

  @override
  State<AmountInputCard> createState() => _AmountInputCardState();
}

class _AmountInputCardState extends State<AmountInputCard> {
  late TextEditingController _controller;
  String? _lastRegionId;
  double _lastAmount = -1;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _syncControllerWithProvider(BuyProvider provider) {
    final currentRegionId = provider.selectedRegion?.id;
    final currentAmount = provider.amount;

    if (_lastRegionId != currentRegionId || _lastAmount != currentAmount) {
      _lastRegionId = currentRegionId;
      _lastAmount = currentAmount;

      final text = currentAmount <= 0
          ? ''
          : currentAmount == currentAmount.truncateToDouble()
              ? currentAmount.toInt().toString()
              : currentAmount.toString();

      if (_controller.text != text) {
        _controller.value = TextEditingValue(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        );
      }
    }
  }

  List<double> _getDenominations(BuyProvider provider) {
    // 1. If provider has explicit availableDenominations, parse them
    final parsed = provider.availableDenominations
        .map((v) => double.tryParse(v) ?? 0.0)
        .where((v) => v > 0)
        .toList();

    if (parsed.isNotEmpty) return parsed;

    // 2. Generate standard denominations based on currency
    final currency = provider.currencyCode.toUpperCase();
    final region = provider.selectedRegion;
    final min = double.tryParse(region?.minimumAmount ?? '') ?? 0.0;
    final max = double.tryParse(region?.maximumAmount ?? '') ?? 100000.0;

    List<double> standard;
    if (currency == 'JPY') {
      standard = [500, 1000, 3000, 5000, 10000];
    } else if (currency == 'EUR') {
      standard = [15, 20, 50, 100];
    } else if (currency == 'GBP') {
      standard = [10, 20, 50, 100];
    } else if (currency == 'NGN') {
      standard = [5000, 10000, 20000, 50000];
    } else if (currency == 'GHS') {
      standard = [50, 100, 200, 500];
    } else {
      // USD, CAD, AUD, etc.
      standard = [10, 25, 50, 100, 200];
    }

    final filtered = standard.where((d) => (min <= 0 || d >= min) && (max <= 0 || d <= max)).toList();
    if (filtered.isNotEmpty) return filtered;

    if (min > 0) return [min];
    return [10, 25, 50];
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BuyProvider>();
    _syncControllerWithProvider(provider);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final inputColor = isDark ? AppColors.darkInput : AppColors.lightInput;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final denominations = _getDenominations(provider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How much do you want to buy?',
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: inputColor,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Text(
                provider.currencySymbol,
                style: TextStyle(
                  color: textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: TextField(
                  controller: _controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(
                    color: textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: '0',
                  ),
                  onChanged: (val) {
                    final parsed = double.tryParse(val.trim());
                    if (parsed != null && parsed >= 0) {
                      _lastAmount = parsed;
                      provider.setAmount(parsed);
                    } else if (val.isEmpty) {
                      _lastAmount = 0;
                      provider.setAmount(0);
                    }
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Row(
                  children: [
                    Text(
                      provider.currencyCode,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_down, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        // Denomination quick-select buttons (Matching Screenshot 4)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: denominations.map((amount) {
              final isSelected = provider.amount == amount;
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: AmountChip(
                  amount: amount,
                  currencySymbol: provider.currencySymbol,
                  isSelected: isSelected,
                  onTap: () {
                    _lastAmount = amount;
                    provider.setAmount(amount);
                    final text = amount == amount.truncateToDouble()
                        ? amount.toInt().toString()
                        : amount.toString();
                    _controller.value = TextEditingValue(
                      text: text,
                      selection: TextSelection.collapsed(offset: text.length),
                    );
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
