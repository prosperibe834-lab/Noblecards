import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../../theme/app_colors.dart';

class OtpResendSection extends StatelessWidget {
  final String formattedTime;
  final bool isExpired;
  final VoidCallback onResend;

  const OtpResendSection({
    super.key,
    required this.formattedTime,
    required this.isExpired,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Timer Display
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Resend available in ',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
              ),
            ),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: isExpired ? AppColors.error : AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
              child: Text(isExpired ? '00:00' : formattedTime),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Resend Action
        GestureDetector(
          onTap: isExpired ? onResend : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Boxicons.bx_refresh,
                color: isExpired 
                    ? AppColors.primary 
                    : (isDark ? AppColors.darkSubText : AppColors.lightSubText),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Didn't receive the code? ",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                ),
              ),
              Text(
                'Resend OTP',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isExpired 
                      ? AppColors.primary 
                      : (isDark ? AppColors.darkSubText : AppColors.lightSubText),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}