import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../providers/market_rates_provider.dart';

class MarketRatesSummaryCards extends StatelessWidget {
  const MarketRatesSummaryCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLoading = context.watch<MarketRatesProvider>().isLoading;

    if (isLoading) {
      return SizedBox(
        height: 80,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context, index) => Container(
            width: 160,
            margin: const EdgeInsets.only(right: AppSpacing.md),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkCard
                  : AppColors.lightBorder.withOpacity(0.5),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        ),
      );
    }

    final cards = [
      {
        'title': 'Top Gainer',
        'value': 'Amazon',
        'sub': '↑ 8.24%',
        'subColor': AppColors.primary,
        'icon': Boxicons.bx_line_chart,
        'iconBg': AppColors.primary.withOpacity(0.1),
        'iconColor': AppColors.primary,
      },
      {
        'title': 'Most Traded',
        'value': 'Apple',
        'sub': '\$1.24M',
        'subColor': AppColors.primary,
        'icon': Boxicons.bx_transfer,
        'iconBg': AppColors.secondary.withOpacity(0.1),
        'iconColor': AppColors.secondary,
      },
      {
        'title': 'Avg. Discount',
        'value': '12.6%',
        'sub': 'Below Face Value',
        'subColor': Theme.of(context).textTheme.bodyMedium!.color,
        'icon': Boxicons.bx_purchase_tag_alt,
        'iconBg': AppColors.warning.withOpacity(0.1),
        'iconColor': AppColors.warning,
      },
    ];

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];
          return Container(
            width: 160,
            margin: const EdgeInsets.only(right: AppSpacing.md),
            padding: const EdgeInsets.all(AppSpacing.s),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: isDark
                  ? Border.all(color: AppColors.darkBorder)
                  : Border.all(color: AppColors.lightBorder, width: 0.5),
              boxShadow: isDark
                  ? []
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: card['iconBg'] as Color,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(
                    card['icon'] as IconData,
                    color: card['iconColor'] as Color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSpacing.s),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        card['title'] as String,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                          fontSize: 10,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        card['value'] as String,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        card['sub'] as String,
                        style: TextStyle(
                          color: card['subColor'] as Color,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
