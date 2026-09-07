import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_styles.dart';

class PinRequirements extends StatelessWidget {
  const PinRequirements({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? AppColors.darkSubText : AppColors.lightSubText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Boxicons.bx_lock_alt, color: AppColors.success, size: 18),
            const SizedBox(width: AppSpacing.xs),
            Text(
              'PIN Requirements',
              style: AppTextStyles.bodyText2.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s),
        _RequirementRow(text: 'Must be exactly 4 digits', textColor: textColor),
        _RequirementRow(text: 'Use numbers 0-9', textColor: textColor),
        _RequirementRow(text: 'Easy to remember, hard to guess', textColor: textColor),
        _RequirementRow(text: 'Keep your PIN private', textColor: textColor),
      ],
    );
  }
}

class _RequirementRow extends StatelessWidget {
  final String text;
  final Color textColor;

  const _RequirementRow({required this.text, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          const Icon(Boxicons.bx_check_circle, color: AppColors.success, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Text(
            text,
            style: AppTextStyles.bodyText2.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}