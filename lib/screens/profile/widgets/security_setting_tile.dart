import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';
import 'custom_biometric_switch.dart';

class SecuritySettingTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool? switchValue;
  final ValueChanged<bool>? onSwitchChanged;
  final String? trailingText;
  final VoidCallback? onTap;

  const SecuritySettingTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.switchValue,
    this.onSwitchChanged,
    this.trailingText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
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
            const SizedBox(width: 12),
            if (switchValue != null)
              CustomBiometricSwitch(
                value: switchValue!,
                onChanged: onSwitchChanged,
              )
            else if (trailingText != null)
              Row(
                children: [
                  Text(
                    trailingText!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Boxicons.bx_chevron_right,
                    size: 18,
                    color: isDark ? AppColors.darkSubText : Colors.grey,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}