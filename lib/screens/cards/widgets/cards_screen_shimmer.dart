import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_radius.dart';

class CardsScreenShimmer extends StatelessWidget {
  const CardsScreenShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? AppColors.darkCard : AppColors.lightBorder;

    Widget shimmerBox(double height, double width, {double radius = AppRadius.md}) {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: baseColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(radius),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  shimmerBox(24, 120),
                  const SizedBox(height: 8),
                  shimmerBox(14, 200),
                ],
              ),
              Row(
                children: [
                  shimmerBox(36, 36, radius: AppRadius.full),
                  const SizedBox(width: 8),
                  shimmerBox(36, 36, radius: AppRadius.full),
                ],
              )
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          shimmerBox(220, double.infinity, radius: AppRadius.xl),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(child: shimmerBox(120, double.infinity, radius: AppRadius.lg)),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: shimmerBox(120, double.infinity, radius: AppRadius.lg)),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          shimmerBox(20, 100),
          const SizedBox(height: AppSpacing.md),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(4, (index) => Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: shimmerBox(40, 120, radius: AppRadius.full),
              )),
            ),
          )
        ],
      ),
    );
  }
}