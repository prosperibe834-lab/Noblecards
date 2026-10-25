import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../localization/app_localizations.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_radius.dart';

class TopRatesSection extends StatelessWidget {
  const TopRatesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final rates = [
      {"catKey": "gaming", "icon": Boxicons.bxs_game, "rate": "82%", "labelKey": "best_rate", "color": AppColors.secondary},
      {"catKey": "shopping", "icon": Boxicons.bx_shopping_bag, "rate": "81%", "labelKey": "great_rate", "color": AppColors.accentViolet},
      {"catKey": "entertainment", "icon": Boxicons.bx_movie_play, "rate": "78%", "labelKey": "good_rate", "color": AppColors.error},
      {"catKey": "dining", "icon": Boxicons.bx_restaurant, "rate": "76%", "labelKey": "good_rate", "color": AppColors.accent},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Boxicons.bx_star, color: AppColors.primary, size: 20),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    context.tr('top_rates_today'),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
                  ),
                ],
              ),
              Text(context.tr('view_all'), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 90,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            scrollDirection: Axis.horizontal,
            itemCount: rates.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final rate = rates[index];
              return Container(
                width: 100,
                padding: const EdgeInsets.all(AppSpacing.s),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(rate["icon"] as IconData, size: 14, color: rate["color"] as Color),
                        const SizedBox(width: 4),
                        Text(
                          context.tr(rate["catKey"] as String),
                          style: TextStyle(fontSize: 10, color: Theme.of(context).textTheme.bodyMedium?.color),
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      rate["rate"] as String,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
                    ),
                    Text(
                      context.tr(rate["labelKey"] as String),
                      style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }
}