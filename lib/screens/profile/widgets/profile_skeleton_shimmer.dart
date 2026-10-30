import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';

class ProfileSkeletonShimmer extends StatelessWidget {
  const ProfileSkeletonShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final highlightColor = isDark ? const Color(0xFF334155) : const Color(0xFFF8FAFC);
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;

    Widget shimmerBox({
      required double width,
      required double height,
      double borderRadius = AppRadius.xs,
      BoxShape shape = BoxShape.rectangle,
    }) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: baseColor,
          shape: shape,
          borderRadius: shape == BoxShape.circle
              ? null
              : BorderRadius.circular(borderRadius),
        ),
      );
    }

    Widget shimmerSection({required int itemCount}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          shimmerBox(width: 90, height: 14, borderRadius: AppRadius.xs),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Column(
              children: List.generate(
                itemCount,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    children: [
                      shimmerBox(
                        width: 36,
                        height: 36,
                        borderRadius: AppRadius.sm,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: shimmerBox(
                          width: double.infinity,
                          height: 14,
                          borderRadius: AppRadius.xs,
                        ),
                      ),
                      const SizedBox(width: 24),
                      shimmerBox(
                        width: 14,
                        height: 14,
                        borderRadius: AppRadius.xs,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header Shimmer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Row(
                children: [
                  shimmerBox(
                    width: 64,
                    height: 64,
                    shape: BoxShape.circle,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        shimmerBox(width: 140, height: 16),
                        const SizedBox(height: 8),
                        shimmerBox(width: 100, height: 12),
                        const SizedBox(height: 10),
                        shimmerBox(width: 80, height: 20, borderRadius: AppRadius.full),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Account Level Card Shimmer
            Container(
              height: 74,
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
            ),
            const SizedBox(height: 16),

            // Quick Stats Shimmer (3 cards)
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 84,
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 84,
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 84,
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Section 1: My Account Shimmer
            shimmerSection(itemCount: 4),
            const SizedBox(height: 24),

            // Section 2: Wallet Shimmer
            shimmerSection(itemCount: 4),
            const SizedBox(height: 24),

            // Referral Card Shimmer
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
