// Location: lib/deposit/widgets/supported_currency_tile.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/theme_provider.dart';
import '../models/deposit_currency.dart';
import '../providers/favourite_currencies_provider.dart';

class SupportedCurrencyTile extends StatelessWidget {
  final DepositCurrency currency;

  const SupportedCurrencyTile({super.key, required this.currency});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FavouriteCurrenciesProvider>();
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final theme = Theme.of(context);
    
    final isFavourite = provider.isFavourite(currency.code);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isFavourite 
              ? AppColors.primary 
              : theme.dividerColor,
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
          ),
          child: Center(
            child: Text(currency.flagAsset, style: const TextStyle(fontSize: 24)),
          ),
        ),
        title: Row(
          children: [
            Text(
              currency.code,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              '(${currency.symbol})',
              style: TextStyle(
                fontFamily: 'Inter',
                color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                fontSize: 14,
              ),
            ),
          ],
        ),
        subtitle: Text(
          currency.name,
          style: TextStyle(
            fontFamily: 'Inter',
            color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
            fontSize: 12,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => provider.toggleFavourite(currency.code),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Icon(
                  isFavourite ? Icons.star : Icons.star_border,
                  key: ValueKey<bool>(isFavourite),
                  color: isFavourite ? AppColors.accent : (isDark ? AppColors.darkSubText : AppColors.lightSubText),
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Icon(
              Icons.chevron_right,
              color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
