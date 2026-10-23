// Location: lib/deposit/widgets/payment_method_intro_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/theme_provider.dart';

class PaymentMethodIntroCard extends StatelessWidget {
  const PaymentMethodIntroCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [AppColors.primaryDark.withOpacity(0.6), const Color(0xFF022C22)]
              : [AppColors.successLight.withOpacity(0.3), AppColors.primary.withOpacity(0.1)],
        ),
        border: Border.all(
          color: isDark ? AppColors.primaryDark.withOpacity(0.5) : AppColors.successLight.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.verified_user_rounded, color: AppColors.primary, size: 16),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Secure & Flexible',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.successLight : AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Choose Your\nPayment Method',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.55,
                child: Text(
                  'Select how you want to fund your account. All transactions are secure and encrypted.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: -10,
            bottom: -10,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.account_balance_wallet, size: 50, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
