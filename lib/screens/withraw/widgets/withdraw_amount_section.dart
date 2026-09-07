import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../providers/withdraw_provider.dart';

class WithdrawAmountSection extends StatefulWidget {
  final WithdrawProvider provider;

  const WithdrawAmountSection({super.key, required this.provider});

  @override
  State<WithdrawAmountSection> createState() => _WithdrawAmountSectionState();
}

class _WithdrawAmountSectionState extends State<WithdrawAmountSection> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.provider.amountText);
    widget.provider.addListener(_onProviderChanged);
  }

  void _onProviderChanged() {
    if (_controller.text != widget.provider.amountText) {
      _controller.text = widget.provider.amountText;
    }
  }

  @override
  void dispose() {
    widget.provider.removeListener(_onProviderChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final cardColor = isDark ? AppColors.darkInput : AppColors.lightInput;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '1. How much do you want to withdraw?',
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              const SizedBox(width: AppSpacing.md),
              Text(
                '\$',
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: TextField(
                  controller: _controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                  onChanged: widget.provider.setAmount,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              Container(width: 1, height: 30, color: borderColor),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors
                            .secondary, // Simplified US flag representation
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'US',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'USD',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Icon(
                      Boxicons.bx_chevron_down,
                      color: isDark
                          ? AppColors.darkSubText
                          : AppColors.lightSubText,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildQuickChip('50', context),
            _buildQuickChip('100', context),
            _buildQuickChip('250', context),
            _buildQuickChip('500', context),
            _buildQuickChip('Max', context, isMax: true),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickChip(
    String value,
    BuildContext context, {
    bool isMax = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Check if this chip is currently the precise selected value
    final isSelected = isMax
        ? widget.provider.amountText ==
              widget.provider.availableBalance.toStringAsFixed(2)
        : widget.provider.amountText == value ||
              widget.provider.amountText == '$value.00';

    final bgColor = isSelected
        ? AppColors.primary
        : (isDark ? AppColors.darkInput : AppColors.lightInput);

    final textColor = isSelected
        ? Colors.white
        : (isMax
              ? AppColors.primary
              : (isDark ? AppColors.darkText : AppColors.lightText));

    final borderColor = isSelected
        ? AppColors.primary
        : (isMax
              ? AppColors.primary
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder));

    return GestureDetector(
      onTap: () {
        if (isMax) {
          widget.provider.setMaxAmount();
        } else {
          widget.provider.setAmount(value);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          isMax ? 'Max' : '\$$value',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 13,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }
}
