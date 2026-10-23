// Location: lib/deposit/widgets/deposit_currency_search_field.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/theme_provider.dart';
import '../providers/deposit_currency_provider.dart';
import 'deposit_currency_filter_bottom_sheet.dart';

class DepositCurrencySearchField extends StatelessWidget {
  const DepositCurrencySearchField({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DepositCurrencyProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.lightCard,
              borderRadius: BorderRadius.circular(AppRadius.md),
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
                hintText: 'Search currency or country...',
                hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  color: isDark ? AppColors.darkSubText.withOpacity(0.7) : AppColors.lightSubText.withOpacity(0.7),
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                  size: 20,
                ),
                suffixIcon: provider.searchQuery.isNotEmpty 
                  ? IconButton(
                      icon: Icon(Icons.close, size: 18, color: isDark ? AppColors.darkSubText : AppColors.lightSubText),
                      onPressed: provider.clearSearch,
                    )
                  : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus(); 
            showDepositCurrencyFilterSheet(context);
          },
          child: Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.lightCard,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: provider.hasActiveFilters ? AppColors.primary : theme.dividerColor,
                width: 1,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.tune,
                  color: provider.hasActiveFilters 
                      ? AppColors.primary 
                      : (isDark ? AppColors.darkSubText : AppColors.lightSubText),
                  size: 22,
                ),
                if (provider.hasActiveFilters)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
