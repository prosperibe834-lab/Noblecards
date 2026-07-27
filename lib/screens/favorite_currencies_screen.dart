import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_app_bar.dart';

import '../theme/app_colors.dart';

class FavoriteCurrenciesScreen extends StatelessWidget {
  const FavoriteCurrenciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: const CustomAppBar(title: 'Favorite Currencies'),
      body: Center(
        child: Text(
          'Currency Management',
          style: TextStyle(
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
      ),
    );
  }
}
