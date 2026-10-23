// Location: lib/deposit/select_deposit_currency_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/theme_provider.dart';

import 'providers/deposit_currency_provider.dart';
import 'widgets/deposit_currency_search_field.dart';
import 'widgets/popular_deposit_currencies.dart';
import 'widgets/deposit_currency_tile.dart';
import 'widgets/deposit_currency_security_banner.dart';

class SelectDepositCurrencyScreen extends StatelessWidget {
  const SelectDepositCurrencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DepositCurrencyProvider(),
      child: const _SelectDepositCurrencyScreenContent(),
    );
  }
}

class _SelectDepositCurrencyScreenContent extends StatelessWidget {
  const _SelectDepositCurrencyScreenContent();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final provider = context.watch<DepositCurrencyProvider>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? AppColors.darkText : AppColors.lightText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          children: [
            Text('Select Deposit Currency', style: theme.textTheme.titleLarge?.copyWith(fontSize: 18)),
            const SizedBox(height: 2),
            Text(
              'Choose the currency you want to deposit with.',
              style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: isDark ? AppColors.darkSubText : AppColors.lightSubText),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.md),
            
            // Search and Filter Settings
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: DepositCurrencySearchField(),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Popular Chips List
            const PopularDepositCurrencies(),
            const SizedBox(height: AppSpacing.lg),

            // All Currencies Heading
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('All Currencies', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Scrollable List of Currencies
            Expanded(
              child: provider.filteredCurrencies.isEmpty
                  ? _buildEmptyState(context, isDark)
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      physics: const BouncingScrollPhysics(),
                      itemCount: provider.filteredCurrencies.length,
                      itemBuilder: (context, index) {
                        return DepositCurrencyTile(currency: provider.filteredCurrencies[index]);
                      },
                    ),
            ),

            // Fixed Bottom Security Banner
            Container(
              padding: const EdgeInsets.only(left: AppSpacing.lg, right: AppSpacing.lg, bottom: AppSpacing.md, top: AppSpacing.sm),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.05),
                    offset: const Offset(0, -10),
                    blurRadius: 20,
                  )
                ],
              ),
              child: const DepositCurrencySecurityBanner(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
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
            'Try another currency code, name, or country.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
