import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_shadow.dart';
import '../../../theme/app_spacing.dart';
import '../models/mock_gift_card.dart';

class GiftCardProductCard extends StatelessWidget {
  final MockGiftCard card;
  final bool isSellMode;
  final bool isDark;
  final VoidCallback onTap;

  const GiftCardProductCard({
    Key? key,
    required this.card,
    required this.isSellMode,
    required this.isDark,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: isDark ? AppShadow.dark : AppShadow.light,
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        padding: const EdgeInsets.all(AppSpacing.s),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Center(
                    child: Icon(Boxicons.bx_gift, color: AppColors.primary, size: 24),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(card.brand, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? AppColors.darkText : AppColors.lightText, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                      if (!isSellMode) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Boxicons.bx_map, size: 12, color: AppColors.textSecondary),
                            const SizedBox(width: 2),
                            Text(card.country, style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkSubText : AppColors.lightSubText)),
                          ],
                        ),
                      ],
                      if (isSellMode && card.badge.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                          child: Text(card.badge, style: const TextStyle(fontSize: 9, color: AppColors.accent, fontWeight: FontWeight.bold)),
                        )
                      ]
                    ],
                  ),
                ),
                if (!isSellMode && card.badge.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(AppRadius.full)),
                    child: Row(
                      children: [
                        const Icon(Boxicons.bxs_flame, size: 10, color: Colors.white),
                        const SizedBox(width: 2),
                        Text(card.badge, style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Text(
              'Rate ${card.rate}',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
            ),
            const SizedBox(height: 2),
            Text(
              '\$${card.minDenomination} - \$${card.maxDenomination}',
              style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkSubText : AppColors.lightSubText),
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.primary, AppColors.successLight]),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isSellMode ? 'Sell Now' : 'View Details',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    if (!isSellMode) ...[
                      const SizedBox(width: 4),
                      const Icon(Boxicons.bx_right_arrow_alt, color: Colors.white, size: 14),
                    ]
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}