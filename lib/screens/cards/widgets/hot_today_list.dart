import 'package:flutter/material.dart';
import '../../../theme/app_spacing.dart';
import '../models/gift_card_model.dart';
import 'hot_today_card.dart';

class HotTodayList extends StatelessWidget {
  final List<GiftCardModel> cards;
  final Function(GiftCardModel) onCardTap;

  const HotTodayList({
    super.key,
    required this.cards,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 175,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
        itemCount: cards.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return HotTodayCard(
            card: cards[index],
            onTap: () => onCardTap(cards[index]),
          );
        },
      ),
    );
  }
}