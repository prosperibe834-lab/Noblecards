import 'package:flutter/material.dart';
import 'package:noble_cards/theme/app_colors.dart';
import 'package:noble_cards/theme/app_spacing.dart';

class SellEmptyState extends StatelessWidget {
  const SellEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.card_giftcard, size: 64, color: AppColors.primary),
            SizedBox(height: AppSpacing.md),
            Text('No cards added yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Add a card to start your sell order. You can submit multiple cards in one batch.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.lightSubText, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
