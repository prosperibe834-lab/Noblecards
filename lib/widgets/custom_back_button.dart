import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../theme/app_theme.dart';

import '../theme/app_colors.dart';

import '../theme/app_spacing.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? color;

  const CustomBackButton({
    super.key,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: IconButton(
          icon: Icon(
            Boxicons.bx_arrow_back,
            color: color ?? (isDark ? AppColors.darkText : AppColors.lightText),
            size: 22,
          ),
          onPressed: onTap ?? () => Navigator.of(context).pop(),
          splashRadius: 24,
          tooltip: 'Back',
        ),
      ),
    );
  }
}
