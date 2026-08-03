import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boxicons/boxicons.dart';
import 'package:noble_cards/theme/app_colors.dart';
import 'package:noble_cards/theme/app_radius.dart';
import 'package:noble_cards/theme/app_spacing.dart';
import '../models/gift_card_model.dart';
import '../providers/buy_provider.dart';
import '../providers/region_provider.dart';

class BuyCardHeader extends StatelessWidget {
  final GiftCardModel card;

  const BuyCardHeader({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: card.id,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Center(
                child: Image.network(
                  card.logoUrl,
                  height: 36,
                  width: 36,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Text(
                    card.name.isNotEmpty ? card.name.characters.first.toUpperCase() : 'A',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Consumer<RegionProvider>(
                    builder: (context, regionProvider, child) {
                      final region = regionProvider.selectedRegion;
                      final countryFlag = region?.flag ?? card.countryFlag;
                      final countryName = region?.countryName ?? card.country;
                      final buyProvider = context.watch<BuyProvider>();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(countryFlag, style: const TextStyle(fontSize: 14)),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                countryName,
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Buy Rate: ${buyProvider.currentRate.toStringAsFixed(2)}%',
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      _buildChip('Shopping'),
                      const SizedBox(width: AppSpacing.sm),
                      _buildChip('? Instant Delivery', color: AppColors.success),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Boxicons.bx_heart, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: (color ?? Colors.white).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
      ),
    );
  }
}
