import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';

class InfoBanner extends StatelessWidget {
  const InfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.success.withOpacity(0.1)
            : AppColors.success.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.success.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Boxicons.bx_shield_quarter,
            color: AppColors.success,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your information is safe with us.',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.success,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'We don\'t share your personal data with anyone.',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.darkSubText : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          // Shield checkmark badge icon
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Boxicons.bxs_check_shield,
              color: AppColors.success,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}