import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';

import '../providers/search_provider.dart';

class AnimatedSearchBar extends StatelessWidget {
  final VoidCallback onFilterTap;

  const AnimatedSearchBar({super.key, required this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final searchProvider = context.watch<SearchProvider>();

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkInput : AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    onChanged: searchProvider.setQuery,
                    style: TextStyle(
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search gift cards, brands or categories',
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: onFilterTap,
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkInput : AppColors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Icon(
              Icons.tune_rounded,
              size: 20,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
          ),
        ),
      ],
    );
  }
}