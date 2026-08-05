import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';

class MarketplaceHeader extends StatelessWidget {
  final int count;

  const MarketplaceHeader({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Marketplace',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
              Text(
                'Showing $count Cards',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                ),
              ),
            ],
          ),
          
        ],
      ),
    );
  }
}