import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';

class AppearanceFooter extends StatelessWidget {
  const AppearanceFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.success.withOpacity(0.08)
            : AppColors.success.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.success.withOpacity(isDark ? 0.2 : 0.15),
          width: 1,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.success.withOpacity(0.15),
                  border: Border.all(
                    color: AppColors.success.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Boxicons.bx_shield_quarter,
                  color: AppColors.success,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Theme changes apply immediately throughout NobleCards.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkSubText : Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 30), // Spacing for absolute stars
            ],
          ),
          
          // Decorative Sparkles
          Positioned(
            right: 10,
            top: -4,
            child: Icon(
              Icons.auto_awesome,
              color: AppColors.success.withOpacity(0.6),
              size: 18,
            ),
          ),
          Positioned(
            right: 0,
            bottom: -4,
            child: Icon(
              Boxicons.bx_star,
              color: AppColors.success.withOpacity(0.4),
              size: 12,
            ),
          ),
        ],
      ),
    );
  }
}