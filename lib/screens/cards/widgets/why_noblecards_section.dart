import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_radius.dart';

class WhyNobleCardsSection extends StatelessWidget {
  const WhyNobleCardsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget buildFeature(IconData icon, String title) {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.lightBackground,
              shape: BoxShape.circle,
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: Theme.of(context).textTheme.bodyMedium?.color,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildFeature(Boxicons.bx_rocket, "Fast Delivery"),
          buildFeature(Boxicons.bx_lock_alt, "Secure Checkout"),
          buildFeature(Boxicons.bx_globe, "Global Selection"),
        ],
      ),
    );
  }
}