import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';

class GiftCardCatalogEmptyState extends StatelessWidget {
  final bool isDark;
  final VoidCallback onReset;

  const GiftCardCatalogEmptyState({Key? key, required this.isDark, required this.onReset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Boxicons.bx_search_alt, size: 64, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            const SizedBox(height: AppSpacing.md),
            Text('No gift cards found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkText : AppColors.lightText)),
            const SizedBox(height: AppSpacing.sm),
            Text('Try another brand or category.', style: TextStyle(color: isDark ? AppColors.darkSubText : AppColors.lightSubText)),
            const SizedBox(height: AppSpacing.lg),
            TextButton(
              onPressed: onReset,
              child: const Text('Clear Filters', style: TextStyle(color: AppColors.primary)),
            )
          ],
        ),
      ),
    );
  }
}