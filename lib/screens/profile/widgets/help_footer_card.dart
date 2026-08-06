import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';

class HelpFooterCard extends StatelessWidget {
  const HelpFooterCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                padding: const EdgeInsets.all(10),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "We're here to help you 24/7",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your satisfaction is our priority',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.darkSubText : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
            right: 30,
            bottom: 0,
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