import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';

class ForgotPasswordHeader extends StatelessWidget {
  final VoidCallback onBackTap;

  const ForgotPasswordHeader({super.key, required this.onBackTap});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Top Back Button Navigation
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: onBackTap,
            icon: Icon(
              Boxicons.bx_arrow_back,
              color: isDark ? AppColors.darkText : AppColors.lightText,
              size: 24,
            ),
            splashRadius: 24,
            tooltip: 'Back',
          ),
        ),
        const SizedBox(height: 12),

        // Theme-Aware NobleCards Logo Asset
        Image.asset(
          isDark
              ? 'lib/assets/logos/MainDarkLogo.png.png'
              : 'lib/assets/logos/MainLightLogo.png.png',
          height: 62,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Fallback UI block if asset path is missing during initial run
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Boxicons.bx_credit_card, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 10),
                Text(
                  'NobleCards',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 32),

        // Heading Title
        Text(
          'Forgot Password?',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),

        // Subtitle Description
        Text(
          "No worries! Enter your email address and\nwe'll send you a link to reset your password.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.45,
                color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
              ),
        ),
      ],
    );
  }
}