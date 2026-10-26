import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:noble_cards/theme/app_colors.dart';
import 'package:noble_cards/theme/app_radius.dart';
import 'package:noble_cards/theme/app_spacing.dart';
import '../providers/buy_provider.dart';

class AmountInput extends StatefulWidget {
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final String? currencySymbol;
  final String? minAmount;
  final String? maxAmount;

  const AmountInput({
    super.key,
    this.initialValue,
    this.onChanged,
    this.currencySymbol,
    this.minAmount,
    this.maxAmount,
  });

  @override
  State<AmountInput> createState() => _AmountInputState();
}

class _AmountInputState extends State<AmountInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void didUpdateWidget(covariant AmountInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != null && widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<int> _buildQuickChips(double min, double max) {
    const standard = [25, 50, 100, 200, 500];
    return standard.where((a) => a >= min && a <= max).toList();
  }

  @override
  Widget build(BuildContext context) {
    BuyProvider? buyProvider;
    try {
      buyProvider = context.watch<BuyProvider>();
    } catch (_) {}

    final symbol = widget.currencySymbol ?? buyProvider?.currencySymbol ?? r'$';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkInput : AppColors.lightInput;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subTextColor = isDark ? AppColors.darkSubText : AppColors.lightSubText;

    final minNum = double.tryParse(widget.minAmount ?? '') ?? 10.0;
    final maxNum = double.tryParse(widget.maxAmount ?? '') ?? 1000.0;
    final chips = _buildQuickChips(minNum, maxNum);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Card Amount',
              style: TextStyle(
                color: textColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (widget.minAmount != null || widget.maxAmount != null)
              Text(
                'Min: $symbol${widget.minAmount ?? '10'} • Max: $symbol${widget.maxAmount ?? '500'}',
                style: TextStyle(
                  color: subTextColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Text(
                  symbol,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: TextFormField(
                  controller: _controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: '0.00',
                    hintStyle: TextStyle(
                      color: isDark ? AppColors.darkSubText.withValues(alpha: 0.5) : AppColors.lightSubText.withValues(alpha: 0.5),
                    ),
                  ),
                  onChanged: (value) {
                    widget.onChanged?.call(value);
                    if (value.isNotEmpty && buyProvider != null) {
                      buyProvider.setAmount(
                        double.tryParse(value) ?? buyProvider.amount,
                      );
                    }
                  },
                ),
              ),
              if (_controller.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _controller.clear();
                    widget.onChanged?.call('');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 14,
                      color: subTextColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (chips.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: chips.map((val) {
                final isSelected = _controller.text == val.toString();
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _controller.text = val.toString();
                      widget.onChanged?.call(val.toString());
                      if (buyProvider != null) {
                        buyProvider.setAmount(val.toDouble());
                      }
                    },
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : isDark
                                ? AppColors.darkCard
                                : AppColors.lightBorder.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : borderColor,
                        ),
                      ),
                      child: Text(
                        '$symbol$val',
                        style: TextStyle(
                          color: isSelected ? Colors.white : textColor,
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }
}
