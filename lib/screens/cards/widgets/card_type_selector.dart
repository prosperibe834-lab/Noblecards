import 'package:flutter/material.dart';
import 'package:noble_cards/theme/app_colors.dart';
import 'package:noble_cards/theme/app_radius.dart';
import 'package:noble_cards/theme/app_spacing.dart';
import 'package:noble_cards/theme/app_animation.dart';

class CardTypeSelector extends StatelessWidget {
  final bool isPhysical;
  final ValueChanged<bool> onChanged;

  const CardTypeSelector({super.key, required this.isPhysical, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).brightness == Brightness.dark ? AppColors.darkText : AppColors.lightText;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          _buildOption(context, false, 'Digital Code', textColor),
          _buildOption(context, true, 'Physical Card', textColor),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, bool value, String label, Color textColor) {
    final isSelected = value == isPhysical;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(value),
        child: AnimatedContainer(
          duration: AppAnimation.fast,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark])
                : null,
            color: isSelected ? null : Theme.of(context).brightness == Brightness.dark ? AppColors.darkCard : AppColors.lightInput,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : textColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
