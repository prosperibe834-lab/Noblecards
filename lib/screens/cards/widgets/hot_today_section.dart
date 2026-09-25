import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_shadow.dart';

class HotTodaySection extends StatelessWidget {
  const HotTodaySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final items = [
      {"title": "Gaming", "price": "From \$10", "badge": "+12%", "icon": Boxicons.bxs_game, "colors": [AppColors.secondary, Color(0xFF3B82F6)]},
      {"title": "Shopping", "price": "From \$25", "badge": "+8%", "icon": Boxicons.bx_shopping_bag, "colors": [AppColors.accentViolet, Color(0xFF6366F1)]},
      {"title": "Entertainment", "price": "From \$15", "badge": "+10%", "icon": Boxicons.bx_movie_play, "colors": [Color(0xFFD946EF), Color(0xFFA855F7)]},
      {"title": "Dining", "price": "From \$20", "badge": "+6%", "icon": Boxicons.bx_restaurant, "colors": [AppColors.accent, Color(0xFFF97316)]},
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
                  const Text("🔥", style: TextStyle(fontSize: 18)),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    "Hot Today",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
                  ),
                ],
              ),
              Text(
                "View All",
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 100,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                width: 110,
                padding: const EdgeInsets.all(AppSpacing.s),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  gradient: LinearGradient(
                    colors: item["colors"] as List<Color>,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: isDark ? AppShadow.dark : AppShadow.light,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(item["icon"] as IconData, color: Colors.white, size: 24),
                    Text(
                      item["title"] as String,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item["price"] as String,
                          style: const TextStyle(color: Colors.white70, fontSize: 10),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item["badge"] as String,
                            style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
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