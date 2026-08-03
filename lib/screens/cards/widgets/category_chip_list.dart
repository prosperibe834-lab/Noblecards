import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';

import '../providers/filter_provider.dart';

class CategoryChipList extends StatelessWidget {
  const CategoryChipList({super.key});

  @override
  Widget build(BuildContext context) {
    final filterProvider = context.watch<FilterProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
        itemCount: filterProvider.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = filterProvider.categories[index];
          final isSelected = filterProvider.selectedCategory == category;

          return GestureDetector(
            onTap: () => filterProvider.setCategory(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.accentViolet
                    : (isDark ? AppColors.darkCard : AppColors.white),
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
              ),
              child: Text(
                category,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? AppColors.darkSubText : AppColors.lightSubText),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}