import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../theme/app_theme.dart';

import '../theme/app_colors.dart';

import '../theme/app_spacing.dart';

class BiometricAuthWidget extends StatelessWidget {
  final VoidCallback onAuthenticated;

  const BiometricAuthWidget({super.key, required this.onAuthenticated});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          iconSize: 64,
          icon: const Icon(
            Boxicons.bx_fingerprint,
            color: AppColors.primary,
          ),
          onPressed: onAuthenticated,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Tap to authenticate using Face ID / Fingerprint',
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
          ),
        ),
      ],
    );
  }
}
