import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';

class BiometricHeaderCard extends StatelessWidget {
  const BiometricHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF072718),
                  const Color(0xFF0B3A24),
                ]
              : [
                  const Color(0xFFE8F8F0),
                  const Color(0xFFD3F3E3),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppColors.success.withOpacity(isDark ? 0.3 : 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withOpacity(isDark ? 0.1 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Row(
        children: [
          // Shield Icon Container
          Container(
            width: 52,
            height: 52,
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
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          // Content Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Secure & Convenient',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Use biometrics to quickly and securely access your NobleCards account.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.35,
                    color: isDark ? AppColors.darkSubText : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Floating Biometric Icons Stack
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.success.withOpacity(0.15),
                ),
                child: const Icon(
                  Boxicons.bx_fingerprint,
                  color: AppColors.success,
                  size: 26,
                ),
              ),
              Positioned(
                top: -6,
                right: -6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                      )
                    ],
                  ),
                  child: const Icon(
                    Boxicons.bx_scan,
                    color: AppColors.success,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}