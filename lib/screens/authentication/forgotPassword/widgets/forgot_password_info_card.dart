import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';

class ForgotPasswordInfoCard extends StatelessWidget {
  const ForgotPasswordInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color cardBg = isDark
        ? AppColors.primary.withOpacity(0.08)
        : AppColors.primary.withOpacity(0.04);

    final Color cardBorder = isDark
        ? AppColors.primary.withOpacity(0.25)
        : AppColors.primary.withOpacity(0.18);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder, width: 1.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Shield Security Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Boxicons.bx_shield_quarter,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),

          // Security Description Text
          Expanded(
            child: Text(
              "We'll send a secure password reset link to your email address.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13.5,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkSubText : AppColors.lightText,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}