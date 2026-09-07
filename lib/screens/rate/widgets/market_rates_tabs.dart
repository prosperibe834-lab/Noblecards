import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_radius.dart';
import '../providers/market_rates_provider.dart';

class MarketRatesTabs extends StatelessWidget {
  const MarketRatesTabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MarketRatesProvider>();
    final tabs = ['All Cards', 'Best Sellers', 'Trending'];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: tabs.map((tab) {
                final isSelected = provider.selectedTab == tab;
                return GestureDetector(
                  onTap: () => provider.setTab(tab),
                  child: Container(
                    margin: const EdgeInsets.only(right: AppSpacing.lg),
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected ? AppColors.primary : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      tab,
                      style: TextStyle(
                        color: isSelected ? AppColors.primary : Theme.of(context).textTheme.bodyMedium!.color,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontFamily: 'Inter',
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        
        // Sort Dropdown
        PopupMenuButton<String>(
          onSelected: provider.setSort,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
          color: Theme.of(context).cardColor,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s, vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkInput : Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Row(
              children: [
                Text(provider.selectedSort, style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodyLarge!.color)),
                const SizedBox(width: 4),
                Icon(Boxicons.bx_chevron_down, size: 16, color: Theme.of(context).textTheme.bodyLarge!.color),
              ],
            ),
          ),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'Highest Buy', child: Text('Highest Buy', style: TextStyle(fontSize: 14))),
            const PopupMenuItem(value: 'Lowest Buy', child: Text('Lowest Buy', style: TextStyle(fontSize: 14))),
            const PopupMenuItem(value: 'Highest Sell', child: Text('Highest Sell', style: TextStyle(fontSize: 14))),
            const PopupMenuItem(value: 'Biggest 24h Gain', child: Text('Biggest 24h Gain', style: TextStyle(fontSize: 14))),
            const PopupMenuItem(value: 'Biggest 24h Drop', child: Text('Biggest 24h Drop', style: TextStyle(fontSize: 14))),
          ],
        ),
      ],
    );
  }
}