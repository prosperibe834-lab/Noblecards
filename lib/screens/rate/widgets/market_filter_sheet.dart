import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../providers/market_rates_provider.dart';

class MarketFilterSheet extends StatelessWidget {
  const MarketFilterSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.read<MarketRatesProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Theme.of(context).dividerColor, borderRadius: BorderRadius.circular(AppRadius.full)))),
            const SizedBox(height: AppSpacing.lg),
            
            Text('Filter Markets', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.lg),

            Text('Category', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              children: ['All Cards', 'Best Sellers', 'Trending'].map((cat) {
                final isSelected = provider.selectedTab == cat;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (val) {
                    if(val) provider.setTab(cat);
                  },
                  selectedColor: AppColors.primary.withOpacity(0.2),
                  labelStyle: TextStyle(color: isSelected ? AppColors.primary : Theme.of(context).textTheme.bodyLarge!.color),
                  backgroundColor: isDark ? AppColors.darkCard : Colors.white,
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),
            
            Text('Country (Coming Soon)', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                Chip(label: const Text('🇺🇸 USA'), backgroundColor: isDark ? AppColors.darkCard : Colors.white),
                Chip(label: const Text('🇬🇧 UK'), backgroundColor: isDark ? AppColors.darkCard : Colors.white),
                Chip(label: const Text('🇨🇦 Canada'), backgroundColor: isDark ? AppColors.darkCard : Colors.white),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                ),
                child: const Text('Apply Filters', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}