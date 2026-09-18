import 'package:flutter/material.dart';
import 'package:noble_cards/theme/app_colors.dart';
import 'package:noble_cards/theme/app_radius.dart';
import 'package:noble_cards/theme/app_spacing.dart';

class CardCodeInput extends StatelessWidget {
  final String? initialValue;
  final ValueChanged<String>? onChanged;

  const CardCodeInput({super.key, this.initialValue, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkInput : AppColors.lightInput;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Card Code',
          style: TextStyle(
            color: textColor,
            fontSize: 14,
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
            color: bgColor,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: borderColor),
          ),
          child: TextFormField(
            initialValue: initialValue,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter card code',
              hintStyle: TextStyle(
                color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
              ),
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
