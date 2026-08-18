import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../models/password_strength.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final PasswordStrengthLevel strength;

  const PasswordStrengthIndicator({super.key, required this.strength});

  Color _getStrengthColor() {
    switch (strength) {
      case PasswordStrengthLevel.empty:
        return Colors.transparent;
      case PasswordStrengthLevel.weak:
        return AppColors.error;
      case PasswordStrengthLevel.medium:
        return AppColors.warning;
      case PasswordStrengthLevel.strong:
      case PasswordStrengthLevel.veryStrong:
        return AppColors.success;
    }
  }

  String _getStrengthText() {
    switch (strength) {
      case PasswordStrengthLevel.empty:
        return 'None';
      case PasswordStrengthLevel.weak:
        return 'Weak';
      case PasswordStrengthLevel.medium:
        return 'Medium';
      case PasswordStrengthLevel.strong:
        return 'Strong';
      case PasswordStrengthLevel.veryStrong:
        return 'Very Strong';
    }
  }

  int _getActiveSegments() {
    switch (strength) {
      case PasswordStrengthLevel.empty: return 0;
      case PasswordStrengthLevel.weak: return 1;
      case PasswordStrengthLevel.medium: return 2;
      case PasswordStrengthLevel.strong: return 3;
      case PasswordStrengthLevel.veryStrong: return 4;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color baseColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final Color activeColor = _getStrengthColor();
    final int activeCount = _getActiveSegments();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Password strength: ',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.darkText : AppColors.lightText,
                fontWeight: FontWeight.w600,
              ),
            ),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: strength == PasswordStrengthLevel.empty 
                    ? (isDark ? AppColors.darkSubText : AppColors.lightSubText)
                    : activeColor,
                fontWeight: FontWeight.w600,
              ),
              child: Text(_getStrengthText()),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: List.generate(4, (index) {
            final bool isActive = index < activeCount;
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 4,
                margin: EdgeInsets.only(right: index == 3 ? 0 : 8),
                decoration: BoxDecoration(
                  color: isActive ? activeColor : baseColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}