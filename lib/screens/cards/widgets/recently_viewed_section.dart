import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_radius.dart';

class RecentlyViewedSection extends StatelessWidget {
  const RecentlyViewedSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Boxicons.bx_time_five, color: Theme.of(context).textTheme.bodyMedium?.color, size: 20),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    "Recently Viewed",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
                  ),
                ],
              ),
              Text("View All", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 60,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            scrollDirection: Axis.horizontal,
            itemCount: 4, // Placeholder for local recent data
            itemBuilder: (context, index) {
              return Container(
                width: 100,
                margin: const EdgeInsets.only(right: AppSpacing.sm),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  color: Theme.of(context).cardColor,
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark 
                        ? AppColors.darkBorder 
                        : AppColors.lightBorder,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Boxicons.bx_image_alt, 
                    color: AppColors.lightSubText.withOpacity(0.5),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}