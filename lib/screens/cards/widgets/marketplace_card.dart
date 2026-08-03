import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../buy_card_screen.dart'; // Adjust path depending on your folder structure

import '../models/gift_card_model.dart';
import 'availability_badge.dart';
import 'buy_sell_buttons.dart';
import 'favorite_button.dart';
import 'instant_badge.dart';

class MarketplaceCard extends StatelessWidget {
  final GiftCardModel card;
  final VoidCallback onTap;
  final VoidCallback onBuy;
  final VoidCallback onSell;

  const MarketplaceCard({
    super.key,
    required this.card,
    required this.onTap,
    required this.onBuy,
    required this.onSell,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.network(
                  card.logoUrl,
                  height: 36,
                  width: 36,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.credit_card, size: 36),
                ),
                FavoriteButton(cardId: card.id),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              card.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
            Text(
              '${card.countryFlag} ${card.category}',
              style: TextStyle(
                fontSize: 10,
                color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
              ),
            ),
            const SizedBox(height: 6),
            const Row(
              children: [
                InstantBadge(),
                SizedBox(width: 4),
                AvailabilityBadge(),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Buy Rate', style: TextStyle(fontSize: 9, color: AppColors.lightSubText)),
                    Text(
                      '${card.buyRate}%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Sell Rate', style: TextStyle(fontSize: 9, color: AppColors.lightSubText)),
                    Text(
                      '${card.sellRate}%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accentViolet,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            BuySellButtons(
              onBuy: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BuyCardScreen(card: card),
                  ),
                );
              },
              onSell: onSell,
            ),
          ],
        ),
      ),
    );
  }
}