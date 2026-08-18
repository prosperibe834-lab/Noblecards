import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';
import '../models/password_strength.dart';

class PasswordTipsCard extends StatelessWidget {
  final PasswordValidationState validationState;

  const PasswordTipsCard({super.key, required this.validationState});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Accurately matching the reference image's card colors
    final Color cardColor = isDark 
        ? AppColors.primary.withOpacity(0.08) 
        : const Color(0xFFF0FDF4); // Matches the soft green in the light mode reference
    final Color borderColor = isDark 
        ? AppColors.primary.withOpacity(0.2) 
        : AppColors.successLight.withOpacity(0.3);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Boxicons.bx_check_shield,
                color: isDark ? AppColors.primary : AppColors.success,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Password Tips',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTipRow(context, 'Use at least 8 characters', validationState.hasMinLength),
          const SizedBox(height: 12),
          _buildTipRow(context, 'Include uppercase and lowercase letters', validationState.hasUpperAndLower),
          const SizedBox(height: 12),
          _buildTipRow(context, 'Include numbers and special characters', validationState.hasDigitAndSpecial),
          const SizedBox(height: 12),
          _buildTipRow(context, 'Avoid using personal information', validationState.avoidsPersonalInfo),
        ],
      ),
    );
  }

  Widget _buildTipRow(BuildContext context, String text, bool isMet) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color iconColor = isMet 
        ? AppColors.success 
        : (isDark ? AppColors.darkSubText : AppColors.lightSubText);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            isMet ? Boxicons.bxs_check_circle : Boxicons.bx_check_circle,
            key: ValueKey<bool>(isMet),
            color: iconColor,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.darkSubText : AppColors.lightText,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}