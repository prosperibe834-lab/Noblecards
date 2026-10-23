// Location: lib/deposit/widgets/deposit_currency_filter_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/theme_provider.dart';
import '../providers/deposit_currency_provider.dart';

void showDepositCurrencyFilterSheet(BuildContext context) {
  final provider = context.read<DepositCurrencyProvider>();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => ChangeNotifierProvider.value(
      value: provider,
      child: const DepositCurrencyFilterBottomSheet(),
    ),
  );
}

class DepositCurrencyFilterBottomSheet extends StatefulWidget {
  const DepositCurrencyFilterBottomSheet({super.key});

  @override
  State<DepositCurrencyFilterBottomSheet> createState() => _DepositCurrencyFilterBottomSheetState();
}

class _DepositCurrencyFilterBottomSheetState extends State<DepositCurrencyFilterBottomSheet> {
  late String _tempRegion;
  late bool _tempPopularOnly;
  late CurrencySortOption _tempSort;

  final List<String> _regions = ['All Regions', 'Africa', 'North America', 'Europe', 'Asia-Pacific'];

  @override
  void initState() {
    super.initState();
    final provider = context.read<DepositCurrencyProvider>();
    _tempRegion = provider.selectedRegion;
    _tempPopularOnly = provider.popularOnly;
    _tempSort = provider.sortOption;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.sm,
        bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? AppSpacing.md : AppSpacing.xxl,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filter Currencies', style: theme.textTheme.titleLarge),
                IconButton(
                  icon: Icon(Icons.close, color: isDark ? AppColors.darkSubText : AppColors.lightSubText),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            
            // Region Filter
            Text('Currency Region', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _regions.map((region) {
                final isSelected = _tempRegion == region;
                return ChoiceChip(
                  label: Text(region, style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: isSelected ? Colors.white : (isDark ? AppColors.darkText : AppColors.lightText))),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    side: BorderSide(color: isSelected ? AppColors.primary : theme.dividerColor),
                  ),
                  onSelected: (val) {
                    setState(() { _tempRegion = region; });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Popularity Switch
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Popular currencies only', style: TextStyle(fontFamily: 'Inter', color: isDark ? AppColors.darkText : AppColors.lightText)),
                  Switch(
                    value: _tempPopularOnly,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() { _tempPopularOnly = val; });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Sorting
            Text('Sort By', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppSpacing.sm),
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Column(
                children: [
                  _buildSortRadio('Popular first', CurrencySortOption.popularFirst, isDark),
                  Divider(height: 1, color: theme.dividerColor),
                  _buildSortRadio('Alphabetical: A–Z', CurrencySortOption.alphabeticalAZ, isDark),
                  Divider(height: 1, color: theme.dividerColor),
                  _buildSortRadio('Alphabetical: Z–A', CurrencySortOption.alphabeticalZA, isDark),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.read<DepositCurrencyProvider>().resetFilters();
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: theme.dividerColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.full)),
                    ),
                    child: Text('Reset', style: TextStyle(fontFamily: 'Inter', color: isDark ? AppColors.darkText : AppColors.lightText, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<DepositCurrencyProvider>().setFilters(
                        region: _tempRegion, 
                        popularOnly: _tempPopularOnly, 
                        sort: _tempSort
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.full)),
                    ),
                    child: const Text('Apply Filters', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSortRadio(String title, CurrencySortOption value, bool isDark) {
    return RadioListTile<CurrencySortOption>(
      title: Text(title, style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: isDark ? AppColors.darkText : AppColors.lightText)),
      value: value,
      groupValue: _tempSort,
      activeColor: AppColors.primary,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      onChanged: (val) {
        if (val != null) setState(() { _tempSort = val; });
      },
    );
  }
}