import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boxicons/boxicons.dart';
import '../../../localization/app_localizations.dart';

class FeaturedCardItem {
  final String id;
  final String name;
  final String flag;
  final String buyRate;
  final String sellRate;
  final IconData icon;
  final String badgeText;
  final Color badgeColor;
  final List<Color> cardGradient;
  final Color rimBorderColor;
  final Color iconGlowColor;

  const FeaturedCardItem({
    required this.id,
    required this.name,
    required this.flag,
    required this.buyRate,
    required this.sellRate,
    required this.icon,
    required this.badgeText,
    required this.badgeColor,
    required this.cardGradient,
    required this.rimBorderColor,
    required this.iconGlowColor,
  });
}

class HomeFeaturedCards extends StatefulWidget {
  final VoidCallback onViewAll;
  final ValueChanged<FeaturedCardItem>? onCardTap;

  const HomeFeaturedCards({
    super.key,
    required this.onViewAll,
    this.onCardTap,
  });

  @override
  State<HomeFeaturedCards> createState() => _HomeFeaturedCardsState();
}

class _HomeFeaturedCardsState extends State<HomeFeaturedCards> {
  final Set<String> _favoriteIds = {};

  final List<FeaturedCardItem> _items = const [
    FeaturedCardItem(
      id: 'apple',
      name: 'Apple',
      flag: '🇺🇸',
      buyRate: '₦700.00',
      sellRate: '₦680.00',
      icon: Boxicons.bxl_apple,
      badgeText: '🔥 98% Rate',
      badgeColor: Color(0xFF8B5CF6),
      cardGradient: [
        Color(0xFF2E1052),
        Color(0xFF1B0B33),
        Color(0xFF0F071D),
      ],
      rimBorderColor: Color(0x66A855F7),
      iconGlowColor: Color(0xFFC084FC),
    ),
    FeaturedCardItem(
      id: 'amazon',
      name: 'Amazon',
      flag: '🇺🇸',
      buyRate: '₦460.00',
      sellRate: '₦440.00',
      icon: Boxicons.bxl_amazon,
      badgeText: '⚡ Instant',
      badgeColor: Color(0xFFF59E0B),
      cardGradient: [
        Color(0xFF281907),
        Color(0xFF181105),
        Color(0xFF0E0B04),
      ],
      rimBorderColor: Color(0x66F59E0B),
      iconGlowColor: Color(0xFFFBBF24),
    ),
    FeaturedCardItem(
      id: 'steam',
      name: 'Steam',
      flag: '🇺🇸',
      buyRate: '₦420.00',
      sellRate: '₦400.00',
      icon: Boxicons.bxl_steam,
      badgeText: '★ Top Rate',
      badgeColor: Color(0xFF0284C7),
      cardGradient: [
        Color(0xFF09233A),
        Color(0xFF0A1826),
        Color(0xFF050E17),
      ],
      rimBorderColor: Color(0x6638BDF8),
      iconGlowColor: Color(0xFF7DD3FC),
    ),
    FeaturedCardItem(
      id: 'google_play',
      name: 'Google Play',
      flag: '🇺🇸',
      buyRate: '₦350.00',
      sellRate: '₦330.00',
      icon: Boxicons.bxl_play_store,
      badgeText: '✓ Verified',
      badgeColor: Color(0xFF10B981),
      cardGradient: [
        Color(0xFF063A29),
        Color(0xFF04261B),
        Color(0xFF021710),
      ],
      rimBorderColor: Color(0x6610B981),
      iconGlowColor: Color(0xFF34D399),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header: "Featured Gift Cards" & "View all"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 18,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00E599), Color(0xFF00B074)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  context.tr('featured_gift_cards', fallback: "Featured Gift Cards"),
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                widget.onViewAll();
              },
              child: Row(
                children: [
                  Text(
                    context.tr('view_all', fallback: "View all"),
                    style: const TextStyle(
                      color: Color(0xFF00D084),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 3),
                  const Icon(
                    Boxicons.bx_chevron_right,
                    size: 16,
                    color: Color(0xFF00D084),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Horizontal Carousel of Top-Tier Fintech Panoramic Cards
        SizedBox(
          height: 154,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _items.length,
            itemBuilder: (context, index) {
              final item = _items[index];
              final isFav = _favoriteIds.contains(item.id);

              return _FintechFeaturedCard(
                item: item,
                isFav: isFav,
                isDark: isDark,
                isLast: index == _items.length - 1,
                onFavoriteToggle: () {
                  HapticFeedback.selectionClick();
                  setState(() {
                    if (isFav) {
                      _favoriteIds.remove(item.id);
                    } else {
                      _favoriteIds.add(item.id);
                    }
                  });
                },
                onTap: () {
                  HapticFeedback.lightImpact();
                  widget.onCardTap?.call(item);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FintechFeaturedCard extends StatefulWidget {
  final FeaturedCardItem item;
  final bool isFav;
  final bool isDark;
  final bool isLast;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  const _FintechFeaturedCard({
    required this.item,
    required this.isFav,
    required this.isDark,
    required this.isLast,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  @override
  State<_FintechFeaturedCard> createState() => _FintechFeaturedCardState();
}

class _FintechFeaturedCardState extends State<_FintechFeaturedCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
          width: 255,
          margin: EdgeInsets.only(right: widget.isLast ? 0 : 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              colors: widget.item.cardGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: widget.item.rimBorderColor,
              width: 1.3,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.item.iconGlowColor.withOpacity(0.16),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // 3D Metallic Card Watermark on the Right
                Positioned(
                  right: -15,
                  bottom: -15,
                  child: Transform.rotate(
                    angle: -15 * math.pi / 180,
                    child: Icon(
                      widget.item.icon,
                      size: 110,
                      color: Colors.white.withOpacity(0.06),
                    ),
                  ),
                ),

                // Top Gloss Sheen Reflection
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 48,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.08),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),

                // Card Main Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top Row: Brand Icon Badge + Brand Name & Tag + Heart Action
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                // Frosted Brand Glyph Badge
                                Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.18),
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      widget.item.icon,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),

                                // Brand Title & Flag
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              widget.item.name,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 13,
                                                letterSpacing: -0.2,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            widget.item.flag,
                                            style: const TextStyle(fontSize: 11),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 1),
                                      // Live Rate Badge Pill
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                        decoration: BoxDecoration(
                                          color: widget.item.badgeColor.withOpacity(0.25),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          widget.item.badgeText,
                                          style: TextStyle(
                                            color: widget.item.iconGlowColor,
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),

                          // Heart Favorite Button
                          GestureDetector(
                            onTap: widget.onFavoriteToggle,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.10),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                widget.isFav ? Boxicons.bxs_heart : Boxicons.bx_heart,
                                color: widget.isFav ? const Color(0xFFEF4444) : Colors.white70,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Middle: Contactless Wave Line Symbol
                      Row(
                        children: [
                          Icon(
                            Boxicons.bx_wifi,
                            size: 14,
                            color: Colors.white.withOpacity(0.35),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 28,
                            height: 1.5,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),

                      // Bottom Row: Dual Rates (Buy/Sell) + "Trade →" Action Pill
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Rates Column
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${context.tr('buy', fallback: 'Buy')}  ${widget.item.buyRate}",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.65),
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 1),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "${context.tr('sell', fallback: 'Sell')}  ${widget.item.sellRate}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: -0.2,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Boxicons.bx_up_arrow_alt,
                                      color: Color(0xFF6EE7B7),
                                      size: 14,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Glowing CTA Pill
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF00E599), Color(0xFF00B074)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x3500D084),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Trade",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(width: 3),
                                Icon(
                                  Boxicons.bx_right_arrow_alt,
                                  color: Colors.white,
                                  size: 13,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
