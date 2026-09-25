import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';

class GiftCardCategoryChips extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;
  final bool isDark;

  const GiftCardCategoryChips({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.isDark,
  }) : super(key: key);

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Gaming': return Boxicons.bx_game;
      case 'Shopping': return Boxicons.bx_shopping_bag;
      case 'Entertainment': return Boxicons.bx_play_circle;
      case 'Dining': return Boxicons.bx_restaurant;
      default: return Boxicons.bx_grid_alt;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;
          return ChoiceChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (category != 'All') ...[
                  Icon(_getIconForCategory(category), size: 16, color: isSelected ? Colors.white : (isDark ? AppColors.darkSubText : AppColors.lightSubText)),
                  const SizedBox(width: 4),
                ],
                Text(category),
              ],
            ),
            selected: isSelected,
            onSelected: (_) => onCategorySelected(category),
            selectedColor: AppColors.primary,
            backgroundColor: isDark ? AppColors.darkInput : Colors.white,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : (isDark ? AppColors.darkText : AppColors.lightText),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: isSelected ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.lightBorder)),
            ),
          );
        },
      ),
    );
  }
}