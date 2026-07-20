import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    brightness: Brightness.light,

    scaffoldBackgroundColor: AppColors.lightBackground,

    primaryColor: AppColors.primary,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
    ),

    cardColor: AppColors.lightCard,

    dividerColor: AppColors.lightBorder,

    textTheme: AppTextTheme.light,

    fontFamily: "Inter",
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,

    brightness: Brightness.dark,

    scaffoldBackgroundColor: AppColors.darkBackground,

    primaryColor: AppColors.primary,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
    ),

    cardColor: AppColors.darkCard,

    dividerColor: AppColors.darkBorder,

    textTheme: AppTextTheme.dark,

    fontFamily: "Inter",
  );
}