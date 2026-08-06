import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';
import 'custom_biometric_switch.dart';

class BiometricMethodCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSupported;
  final bool isEnabled;
  final ValueChanged<bool>? onToggle;
  final String? infoText;

  const BiometricMethodCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSupported,
    required this.isEnabled,
    this.onToggle,
    this.infoText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withOpacity(0.04),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Badge
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppColors.success,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              // Titles
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.3,
                        color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Switch
              CustomBiometricSwitch(
                value: isSupported && isEnabled,
                onChanged: isSupported ? onToggle : null,
              ),
            ],
          ),

          // Status bar inside card or Info box
          if (infoText != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.04)
                    : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark ? Colors.white10 : Colors.grey.shade200,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      infoText!,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.darkSubText : Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Boxicons.bx_shield_quarter,
                    color: AppColors.success,
                    size: 18,
                  ),
                ],
              ),
            ),
          ] else ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.success.withOpacity(0.08)
                    : AppColors.success.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Status',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.darkSubText : Colors.black54,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        !isSupported
                            ? 'Not Supported'
                            : (isEnabled ? 'Enabled' : 'Disabled'),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: !isSupported
                              ? AppColors.error
                              : (isEnabled ? AppColors.success : Colors.grey),
                        ),
                      ),
                      if (isSupported && isEnabled) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Boxicons.bxs_check_circle,
                          color: AppColors.success,
                          size: 14,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}