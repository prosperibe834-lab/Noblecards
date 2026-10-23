// Location: lib/deposit/widgets/add_favourite_currency_banner.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/theme_provider.dart';
import '../select_deposit_currency_screen.dart';

class AddFavouriteCurrencyBanner extends StatelessWidget {
  const AddFavouriteCurrencyBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.primary.withOpacity(0.3) : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(isDark ? 0.2 : 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.swap_horiz, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need a different currency?',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                Text(
                  'You can add more currencies anytime.',
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SelectDepositCurrencyScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.full)),
              elevation: 0,
              minimumSize: const Size(0, 36),
            ),
            child: const Text('Add Currency +', style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}