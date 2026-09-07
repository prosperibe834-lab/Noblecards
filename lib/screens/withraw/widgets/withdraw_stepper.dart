import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';

class WithdrawStepper extends StatelessWidget {
  final int currentStep;

  const WithdrawStepper({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subTextColor = isDark ? AppColors.darkSubText : AppColors.lightSubText;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStep(0, "Details", Boxicons.bx_list_ul, isDark, textColor, subTextColor),
          _buildDivider(0),
          _buildStep(1, "Review", Boxicons.bx_file, isDark, textColor, subTextColor),
          _buildDivider(1),
          _buildStep(2, "PIN", Boxicons.bx_lock_alt, isDark, textColor, subTextColor),
          _buildDivider(2),
          _buildStep(3, "Processing", Boxicons.bx_loader_circle, isDark, textColor, subTextColor),
        ],
      ),
    );
  }

  Widget _buildStep(int stepIndex, String title, IconData icon, bool isDark, Color textColor, Color subTextColor) {
    bool isCompleted = currentStep > stepIndex;
    bool isActive = currentStep == stepIndex;

    Color circleColor;
    Color iconColor;

    if (isCompleted) {
      circleColor = AppColors.primary;
      iconColor = AppColors.white;
    } else if (isActive) {
      circleColor = AppColors.primary;
      iconColor = AppColors.white;
    } else {
      circleColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
      iconColor = subTextColor;
    }

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (isCompleted || isActive) ? circleColor : Colors.transparent,
            border: Border.all(
              color: circleColor,
              width: 2,
            ),
          ),
          child: Center(
            child: Icon(
              isCompleted ? Boxicons.bx_check : icon,
              size: 18,
              color: iconColor,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontFamily: "Inter",
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive ? textColor : subTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(int stepIndex) {
    bool isCompleted = currentStep > stepIndex;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0, left: 8, right: 8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 2,
          color: isCompleted ? AppColors.primary : (AppColors.lightSubText.withOpacity(0.3)),
        ),
      ),
    );
  }
}