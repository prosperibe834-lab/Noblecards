import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boxicons/boxicons.dart';
import 'package:noble_cards/theme/app_colors.dart';
import 'package:noble_cards/theme/app_radius.dart';
import 'package:noble_cards/theme/app_spacing.dart';
import '../providers/buy_provider.dart';

class RateInfoCard extends StatelessWidget {
  const RateInfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BuyProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subTextColor = isDark ? AppColors.darkSubText : AppColors.lightSubText;

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Boxicons.bx_trending_up, color: AppColors.success, size: 14),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text('Current Buy Rate', style: TextStyle(color: subTextColor, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text('${provider.currentRate.toStringAsFixed(2)}%', 
                  style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Boxicons.bx_time, color: subTextColor, size: 18),
                    const SizedBox(width: AppSpacing.xs),
                    Text('Last Updated', style: TextStyle(color: subTextColor, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Container(
                      width: 8, height: 8,
                      decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text('15 seconds ago', style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
