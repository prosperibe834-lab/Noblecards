import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boxicons/boxicons.dart';
import 'package:noble_cards/theme/app_colors.dart';
import 'package:noble_cards/theme/app_radius.dart';
import 'package:noble_cards/theme/app_spacing.dart';
import '../models/gift_card_model.dart';
import '../providers/buy_provider.dart';
import '../providers/region_provider.dart';
import 'availability_badge.dart';

class SellCardHeader extends StatelessWidget {
  final GiftCardModel card;
  final VoidCallback onChange;

  const SellCardHeader({super.key, required this.card, required this.onChange});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkCard : AppColors.white;
    final textColor = isDark ? AppColors.lightText : AppColors.darkText;

    return Hero(
      tag: card.id,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.25),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Center(
                    child: Image.network(
                      card.logoUrl,
                      width: 36,
                      height: 36,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.credit_card, color: Colors.white, size: 30),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(card.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                      const SizedBox(height: AppSpacing.xs),
                      Consumer2<RegionProvider, BuyProvider>(
                        builder: (context, regionProvider, buyProvider, child) {
                          final selectedRegion = regionProvider.selectedRegion;
                          return Row(
                            children: [
                              Text(selectedRegion?.flag ?? card.countryFlag, style: const TextStyle(fontSize: 14)),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                selectedRegion?.countryName ?? card.country,
                                style: const TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  onTap: onChange,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: const Text('Change', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Consumer<BuyProvider>(
              builder: (context, provider, child) {
                return Row(
                  children: [
                    AvailabilityBadge(isAvailable: true),
                    const SizedBox(width: AppSpacing.sm),
                    const Text('Instant Payment', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(width: AppSpacing.sm),
                    const Icon(Boxicons.bx_time, color: Colors.white70, size: 14),
                    const SizedBox(width: AppSpacing.xs),
                    const Text('~5 Minutes', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                );
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Sell Rate', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: AppSpacing.xs),
                    Consumer<BuyProvider>(
                      builder: (context, provider, child) => Text(
                        '${provider.currentRate.toStringAsFixed(2)}%',
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text('Estimated processing', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    SizedBox(height: AppSpacing.xs),
                    Text('~5 minutes', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
