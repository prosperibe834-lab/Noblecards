import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';

import '../models/gift_card_model.dart';
import 'availability_badge.dart';

class HotTodayCard extends StatelessWidget {
  final GiftCardModel card;
  final VoidCallback onTap;

  const HotTodayCard({
    super.key,
    required this.card,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                card.logoUrl,
                height: 40,
                width: 40,
                errorBuilder: (_, __, ___) => const Icon(Icons.credit_card, size: 40),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              card.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
            Text(
              '${card.countryFlag} ${card.country}',
              style: TextStyle(
                fontSize: 10,
                color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Buy', style: TextStyle(fontSize: 9, color: AppColors.lightSubText)),
                    Text(
                      '${card.buyRate}%',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Sell', style: TextStyle(fontSize: 9, color: AppColors.lightSubText)),
                    Text(
                      '${card.sellRate}%',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accentViolet,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            const AvailabilityBadge(),
          ],
        ),
      ),
    );
  }
}