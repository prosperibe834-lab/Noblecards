import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';

void showFloatingSnackbar(BuildContext context, String message) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      content: Text(
        message,
        style: TextStyle(
          color: isDark ? AppColors.darkText : AppColors.lightText,
        ),
      ),
    ),
  );
}