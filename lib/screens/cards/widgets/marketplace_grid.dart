import 'package:flutter/material.dart';
import '../../../theme/app_spacing.dart';
import '../models/gift_card_model.dart';
import 'marketplace_card.dart';

class MarketplaceGrid extends StatelessWidget {
  final List<GiftCardModel> cards;
  final Function(GiftCardModel) onCardTap;
  final Function(GiftCardModel) onBuyTap;
  final Function(GiftCardModel) onSellTap;

  const MarketplaceGrid({
    super.key,
    required this.cards,
    required this.onCardTap,
    required this.onBuyTap,
    required this.onSellTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cards.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.76,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          final card = cards[index];
          return MarketplaceCard(
            card: card,
            onTap: () => onCardTap(card),
            onBuy: () => onBuyTap(card),
            onSell: () => onSellTap(card),
          );
        },
      ),
    );
  }
}