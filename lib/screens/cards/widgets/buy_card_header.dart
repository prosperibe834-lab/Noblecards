import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boxicons/boxicons.dart';
import 'package:noble_cards/theme/app_colors.dart';
import 'package:noble_cards/theme/app_radius.dart';
import 'package:noble_cards/theme/app_spacing.dart';
import '../models/gift_card_model.dart';
import '../providers/buy_provider.dart';
import '../providers/region_provider.dart';
import '../utils/country_helper.dart';

class BuyCardHeader extends StatelessWidget {
  final GiftCardModel card;

  const BuyCardHeader({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.md),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Center(
                child: card.logoUrl.isNotEmpty
                    ? Image.network(
                        card.logoUrl,
                        height: 42,
                        width: 42,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => _buildFallbackLogo(),
                      )
                    : _buildFallbackLogo(),
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
                Consumer2<RegionProvider, BuyProvider>(
                  builder: (context, regionProvider, buyProvider, child) {
                    final region = regionProvider.selectedRegion;
                    final countryFlag = (region?.flag != null && region!.flag != '🌍' && region.flag.isNotEmpty)
                        ? region.flag
                        : CountryHelper.flagEmoji(region?.countryCode ?? card.countryCode);
                    final countryName = (region != null && region.countryName.length > 3)
                        ? region.countryName
                        : CountryHelper.countryName(region?.countryCode ?? card.countryCode);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              countryFlag,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Expanded(
                              child: Text(
                                countryName,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Buy Rate: ${buyProvider.currentRate.toStringAsFixed(2)}%',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    _buildChip(card.category),
                    const SizedBox(width: AppSpacing.sm),
                    _buildChip(
                      '⚡ Instant Delivery',
                      color: AppColors.success,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Boxicons.bx_heart, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildFallbackLogo() {
    return Container(
      color: const Color(0xFF0F172A),
      alignment: Alignment.center,
      child: Text(
        card.name.isNotEmpty ? card.name.characters.first.toUpperCase() : 'G',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
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
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
