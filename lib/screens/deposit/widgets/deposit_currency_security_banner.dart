// Location: lib/deposit/widgets/deposit_currency_security_banner.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/theme_provider.dart';

class DepositCurrencySecurityBanner extends StatelessWidget {
  const DepositCurrencySecurityBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryDark.withOpacity(0.2) : AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.primaryDark.withOpacity(0.5) : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              boxShadow: isDark ? [
                BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 2))
              ] : null,
            ),
            child: const Icon(Icons.shield_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Secure & Reliable',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: isDark ? AppColors.successLight : AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Your transactions are protected with advanced security measures.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: isDark ? AppColors.successLight.withOpacity(0.8) : AppColors.primaryDark.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(Icons.arrow_forward, size: 18, color: isDark ? AppColors.successLight : AppColors.primaryDark),
        ],
      ),
    );
  }
}