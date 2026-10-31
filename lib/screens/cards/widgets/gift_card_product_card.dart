import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_shadow.dart';
import '../../../theme/app_spacing.dart';
import '../models/gift_card_model.dart';

class GiftCardProductCard extends StatelessWidget {
  final GiftCardModel card;
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
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: isDark ? AppShadow.dark : AppShadow.light,
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        padding: const EdgeInsets.all(AppSpacing.s),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: card.logoUrl.isNotEmpty
                          ? Image.network(
                              card.logoUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => _buildFallbackLogo(),
                            )
                          : _buildFallbackLogo(),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.darkText
                              : AppColors.lightText,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Text(
                            card.countryFlag.isNotEmpty ? card.countryFlag : '🌐',
                            style: const TextStyle(fontSize: 11),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              card.country,
                              style: TextStyle(
                                fontSize: 10,
                                color: isDark
                                    ? AppColors.darkSubText
                                    : AppColors.lightSubText,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              _buildPriceOrRate(card, isSellMode),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              card.supportedRegions.length > 1
                  ? 'Multi-Currency Available'
                  : (isSellMode
                      ? 'Instant Payout'
                      : 'Instant Digital Delivery'),
              style: TextStyle(
                fontSize: 10,
                color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.successLight],
                ),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isSellMode ? 'Sell Now' : 'View Details',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (!isSellMode) ...[
                      const SizedBox(width: 4),
                      const Icon(
                        Boxicons.bx_right_arrow_alt,
                        color: Colors.white,
                        size: 14,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buildPriceOrRate(GiftCardModel card, bool isSellMode) {
    if (isSellMode) {
      return 'Rate ${card.sellRate.toStringAsFixed(2)}%';
    }
    if (card.minDenomination.isNotEmpty && card.maxDenomination.isNotEmpty) {
      if (card.minDenomination == card.maxDenomination) {
        return '${card.currency} ${card.minDenomination}';
      }
      return '${card.currency} ${card.minDenomination} - ${card.currency} ${card.maxDenomination}';
    }
    if (card.denominations.isNotEmpty) {
      if (card.denominations.length == 1) {
        return '${card.currency} ${card.denominations.first}';
      }
      return '${card.currency} ${card.denominations.first} - ${card.currency} ${card.denominations.last}';
    }
    if (card.currency.isNotEmpty) {
      return '${card.currency} Custom Amount';
    }
    return 'Instant Delivery';
  }

  Widget _buildFallbackLogo() {
    return Container(
      color: AppColors.primary.withOpacity(0.12),
      alignment: Alignment.center,
      child: Text(
        card.name.isNotEmpty ? card.name.characters.first.toUpperCase() : 'G',
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
