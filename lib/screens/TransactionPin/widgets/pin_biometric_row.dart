import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';

class PinBiometricRow extends StatelessWidget {
  final bool isBiometricEnabled;
  final ValueChanged<bool> onToggleChanged;
  final VoidCallback? onBiometricTap;

  const PinBiometricRow({
    super.key,
    required this.isBiometricEnabled,
    required this.onToggleChanged,
    this.onBiometricTap,
  });

  String get _biometricLabel {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'Use Face ID';
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return 'Use Fingerprint';
    }
    return 'Use Biometrics';
  }

  IconData get _biometricIcon {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return Icons.face_rounded;
    }
    return Icons.fingerprint_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark
        ? const Color(0xFF132A22)
        : const Color(0xFFE8F8F2);

    final borderColor = isDark
        ? AppColors.primary.withOpacity(0.25)
        : AppColors.primary.withOpacity(0.18);

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: isBiometricEnabled ? onBiometricTap : null,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: borderColor, width: 1.0),
          ),
          child: Row(
            children: [
              // Biometric Icon Box
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.primary.withOpacity(0.15)
                      : Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(_biometricIcon, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 12),

              // Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _biometricLabel,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkText
                            : AppColors.lightText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Quick and secure verification',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: isDark
                            ? AppColors.darkSubText.withOpacity(0.8)
                            : AppColors.lightSubText,
                      ),
                    ),
                  ],
                ),
              ),

              // Toggle Switch
              Transform.scale(
                scale: 0.85,
                child: Switch.adaptive(
                  value: isBiometricEnabled,
                  onChanged: onToggleChanged,
                  activeColor: Colors.white,
                  activeTrackColor: AppColors.primary,
                  inactiveThumbColor: isDark
                      ? Colors.grey.shade400
                      : Colors.white,
                  inactiveTrackColor: isDark
                      ? AppColors.darkBorder
                      : AppColors.lightBorder,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
