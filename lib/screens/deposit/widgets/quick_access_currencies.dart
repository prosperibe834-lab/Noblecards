// Location: lib/deposit/widgets/quick_access_currencies.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/theme_provider.dart';
import '../providers/favourite_currencies_provider.dart';

class QuickAccessCurrencies extends StatelessWidget {
  const QuickAccessCurrencies({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FavouriteCurrenciesProvider>();
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final theme = Theme.of(context);
    final favourites = provider.favouriteCurrencies;

    if (favourites.isEmpty) {
      return const SizedBox.shrink(); // Hide section if no favourites
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Quick Access', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
              Text(
                '${favourites.length} selected', 
                style: const TextStyle(color: AppColors.primary, fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: favourites.map((currency) {
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : AppColors.lightCard,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    border: Border.all(color: AppColors.primary.withOpacity(0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(currency.flagAsset, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        currency.code,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: isDark ? AppColors.darkText : AppColors.lightText,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      const Icon(Icons.check_circle, color: AppColors.primary, size: 14),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
