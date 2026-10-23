// Location: lib/deposit/widgets/favourite_currency_search_field.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/theme_provider.dart';
import '../providers/favourite_currencies_provider.dart';

class FavouriteCurrencySearchField extends StatelessWidget {
  const FavouriteCurrencySearchField({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FavouriteCurrenciesProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(
          color: theme.dividerColor,
          width: 1,
        ),
      ),
      child: TextField(
        onChanged: provider.updateSearch,
        style: TextStyle(
          fontFamily: 'Inter',
          color: isDark ? AppColors.darkText : AppColors.lightText,
        ),
        decoration: InputDecoration(
          hintText: 'Search currency by code or name...',
          hintStyle: TextStyle(
            fontFamily: 'Inter',
            color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14),
        ),
      ),
    );
  }
}
