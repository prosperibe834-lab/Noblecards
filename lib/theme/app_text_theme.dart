import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextTheme {
  AppTextTheme._();

  static const TextTheme light = TextTheme(
    headlineLarge: TextStyle(
      fontFamily: "Poppins",
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.lightText,
    ),
    titleLarge: TextStyle(
      fontFamily: "Poppins",
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: AppColors.lightText,
    ),
    bodyLarge: TextStyle(
      fontFamily: "Inter",
      fontSize: 16,
      color: AppColors.lightText,
    ),
    bodyMedium: TextStyle(
      fontFamily: "Inter",
      fontSize: 14,
      color: AppColors.lightSubText,
    ),
  );

  static const TextTheme dark = TextTheme(
    headlineLarge: TextStyle(
      fontFamily: "Poppins",
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.darkText,
    ),
    titleLarge: TextStyle(
      fontFamily: "Poppins",
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: AppColors.darkText,
    ),
    bodyLarge: TextStyle(
      fontFamily: "Inter",
      fontSize: 16,
      color: AppColors.darkText,
    ),
    bodyMedium: TextStyle(
      fontFamily: "Inter",
      fontSize: 14,
      color: AppColors.darkSubText,
    ),
  );
}