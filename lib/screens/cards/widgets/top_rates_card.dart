import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';

import '../models/gift_card_model.dart';

class TopRatesCard extends StatelessWidget {
  final List<GiftCardModel> cards;

  const TopRatesCard({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final topList = cards.take(5).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          ...List.generate(topList.length, (index) {
            final card = topList[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                children: [
                  Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Image.network(
                    card.logoUrl,
                    width: 24,
                    height: 24,
                    errorBuilder: (_, __, ___) => const Icon(Icons.credit_card, size: 24),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${card.name} US',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Sell Rate',
                        style: TextStyle(fontSize: 9, color: AppColors.lightSubText),
                      ),
                      Text(
                        '${card.sellRate}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkText : AppColors.lightText,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

