import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';

class GiftCardCatalogShimmer extends StatelessWidget {
  final bool isDark;
  const GiftCardCatalogShimmer({Key? key, required this.isDark}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseColor = isDark ? AppColors.darkCard : AppColors.lightBorder;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          Container(height: 180, decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.circular(AppRadius.lg))),
          const SizedBox(height: AppSpacing.md),
          Container(height: 50, decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.circular(AppRadius.full))),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: List.generate(4, (index) => Expanded(
              child: Container(margin: const EdgeInsets.only(right: 8), height: 40, decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.circular(20))),
            )),
          ),
          const SizedBox(height: AppSpacing.lg),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.85, crossAxisSpacing: 16, mainAxisSpacing: 16),
            itemCount: 4,
            itemBuilder: (_, __) => Container(decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.circular(AppRadius.md))),
          )
        ],
      ),
    );
  }
}