import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:noble_cards/theme/app_colors.dart';
import 'package:noble_cards/theme/app_radius.dart';
import 'package:noble_cards/theme/app_spacing.dart';

class SellLoadingShimmer extends StatelessWidget {
  const SellLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.lightBorder,
      highlightColor: AppColors.lightInput,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: List.generate(6, (_) {
            return Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
            );
          }),
        ),
      ),
    );
  }
}
