// Location: lib/deposit/favourite_currencies_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/theme_provider.dart';

import 'providers/favourite_currencies_provider.dart';
import 'widgets/favourite_currency_search_field.dart';
import 'widgets/quick_access_currencies.dart';
import 'widgets/supported_currency_tile.dart';
import 'widgets/add_favourite_currency_banner.dart';
import 'widgets/favourite_currency_help_bottom_sheet.dart';

class FavouriteCurrenciesScreen extends StatelessWidget {
  const FavouriteCurrenciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FavouriteCurrenciesProvider(),
      child: const _FavouriteCurrenciesScreenContent(),
    );
  }
}

class _FavouriteCurrenciesScreenContent extends StatelessWidget {
  const _FavouriteCurrenciesScreenContent();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final provider = context.watch<FavouriteCurrenciesProvider>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? AppColors.darkText : AppColors.lightText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: isDark ? AppColors.darkSubText : AppColors.lightSubText),
            onPressed: () => showFavouriteCurrencyHelpSheet(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Favourite Currencies', style: theme.textTheme.headlineLarge),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Quickly access and manage your preferred currencies for faster transactions.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.public, color: AppColors.primary, size: 36),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            
            // Search Field
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: FavouriteCurrencySearchField(),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Quick Access Chips
            const QuickAccessCurrencies(),
            const SizedBox(height: AppSpacing.lg),

            // All Supported Currencies List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text('All Supported Currencies', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: AppSpacing.sm),

            Expanded(
              child: provider.isLoading 
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : provider.filteredCurrencies.isEmpty
                      ? _buildEmptySearchState(context)
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                          physics: const BouncingScrollPhysics(),
                          itemCount: provider.filteredCurrencies.length,
                          itemBuilder: (context, index) {
                            final currency = provider.filteredCurrencies[index];
                            return SupportedCurrencyTile(currency: currency);
                          },
                        ),
            ),

            // Fixed Banner at bottom
            Container(
              padding: const EdgeInsets.only(left: AppSpacing.lg, right: AppSpacing.lg, bottom: AppSpacing.md, top: AppSpacing.sm),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.05),
                    offset: const Offset(0, -4),
                    blurRadius: 10,
                  )
                ],
              ),
              child: const AddFavouriteCurrencyBanner(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySearchState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: isDark ? AppColors.darkSubText : AppColors.lightSubText),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No currencies found',
            style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkText : AppColors.lightText),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Try searching a different code or name.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
