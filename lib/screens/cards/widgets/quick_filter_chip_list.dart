import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';

import '../providers/filter_provider.dart';

class QuickFilterChipList extends StatelessWidget {
  const QuickFilterChipList({super.key});

  @override
  Widget build(BuildContext context) {
    final filterProvider = context.watch<FilterProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
        itemCount: filterProvider.quickFilters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filterProvider.quickFilters[index];
          final isSelected = filterProvider.selectedQuickFilter == filter;

          return GestureDetector(
            onTap: () => filterProvider.setQuickFilter(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark ? AppColors.darkCard : AppColors.white)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
              ),
              child: Row(
                children: [
                  if (filter == 'Trending')
                    const Icon(Icons.show_chart_rounded, size: 14, color: AppColors.accent),
                  if (filter == 'Highest Rate')
                    const Icon(Icons.emoji_events_outlined, size: 14, color: AppColors.accent),
                  if (filter == 'Instant Delivery')
                    const Icon(Icons.flash_on_rounded, size: 14, color: AppColors.primary),
                  if (filter != 'All' && filter != 'Favorites' && filter != 'Available' && filter != 'Recently Added')
                    const SizedBox(width: 4),
                  Text(
                    filter,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected
                          ? (isDark ? AppColors.darkText : AppColors.lightText)
                          : (isDark ? AppColors.darkSubText : AppColors.lightSubText),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}