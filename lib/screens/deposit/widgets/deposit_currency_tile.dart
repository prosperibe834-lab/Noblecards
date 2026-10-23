// Location: lib/deposit/widgets/deposit_currency_tile.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/theme_provider.dart';
import '../models/deposit_currency.dart';
import '../providers/deposit_currency_provider.dart';

class DepositCurrencyTile extends StatelessWidget {
  final DepositCurrency currency;

  const DepositCurrencyTile({super.key, required this.currency});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final theme = Theme.of(context);
    final provider = context.watch<DepositCurrencyProvider>();
    final isSelected = provider.selectedCurrency?.code == currency.code;

    return GestureDetector(
      onTap: () {
        provider.selectCurrency(currency);
        Navigator.pop(context, currency);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? AppColors.primary.withOpacity(0.5) : theme.dividerColor,
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
              if (currency.isPopular) ...[
                const SizedBox(width: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                  ),
                  child: const Text(
                    'Popular',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ),
              ]
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
          trailing: Icon(
            Icons.chevron_right,
            color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
            size: 20,
          ),
        ),
      ),
    );
  }
}
