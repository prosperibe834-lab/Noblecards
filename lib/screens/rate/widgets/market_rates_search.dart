import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../providers/market_rates_provider.dart';
import 'market_filter_sheet.dart';

class MarketRatesSearch extends StatelessWidget {
  const MarketRatesSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<MarketRatesProvider>();

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkInput : Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                width: 1,
              ),
            ),
            child: TextField(
              onChanged: provider.setSearchQuery,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: 'Search gift cards...',
                hintStyle: Theme.of(context).textTheme.bodyMedium,
                prefixIcon: Icon(
                  Boxicons.bx_search,
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        GestureDetector(
          onTap: () {
            final provider = context.read<MarketRatesProvider>();
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (context) => ChangeNotifierProvider.value(
                value: provider,
                child: const MarketFilterSheet(),
              ),
            );
          },
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkInput : Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                width: 1,
              ),
            ),
            child: Icon(
              Boxicons.bx_filter,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),
        ),
      ],
    );
  }
}
