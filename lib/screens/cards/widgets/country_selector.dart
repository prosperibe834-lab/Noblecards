import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';

import '../providers/country_provider.dart';

class CountrySelector extends StatelessWidget {
  final VoidCallback onTap;

  const CountrySelector({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final countryProvider = context.watch<CountryProvider>();
    final selected = countryProvider.selectedCountry;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkInput : AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(selected.flag, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Text(
              selected.name,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
            ),
          ],
        ),
      ),
    );
  }
}