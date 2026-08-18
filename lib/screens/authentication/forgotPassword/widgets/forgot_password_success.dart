import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';

class ForgotPasswordSuccessView extends StatelessWidget {
  final String email;
  final VoidCallback onBackToSignIn;

  const ForgotPasswordSuccessView({
    super.key,
    required this.email,
    required this.onBackToSignIn,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        // Success Checkmark Badge
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Boxicons.bx_check_circle,
              color: AppColors.success,
              size: 48,
            ),
          ),
        ),
        const SizedBox(height: 28),

        Text(
          'Reset Link Sent!',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'We have sent a password reset link to:\n$email\n\nPlease check your inbox and follow the instructions.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                  color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                ),
          ),
        ),
        const SizedBox(height: 40),

        // Return to Login Button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            onPressed: onBackToSignIn,
            icon: const Icon(Boxicons.bx_arrow_back, color: AppColors.primary, size: 18),
            label: Text(
              'Back to Sign In',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}