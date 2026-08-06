import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle h2 = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.lightText,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.lightText,
  );

  static const TextStyle bodyText2 = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    color: AppColors.lightSubText,
  );
}
