import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../../theme/app_colors.dart';

class OtpInfoCard extends StatelessWidget {
  const OtpInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // Matching the soft card appearance from the reference image
    final Color cardColor = isDark 
        ? AppColors.primary.withOpacity(0.08) 
        : const Color(0xFFF0FDF4); // Soft green
    final Color borderColor = isDark 
        ? AppColors.primary.withOpacity(0.15) 
        : AppColors.successLight.withOpacity(0.3);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Boxicons.bx_check_shield,
            color: isDark ? AppColors.primary : AppColors.success,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter the code sent to your email.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'For your security, do not share this code with anyone.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}