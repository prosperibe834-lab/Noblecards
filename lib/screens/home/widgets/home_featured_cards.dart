import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boxicons/boxicons.dart';
import '../../../localization/app_localizations.dart';

class FeaturedCardItem {
  final String id;
  final String name;
  final String discountText;
  final String buyRate;
  final String sellRate;
  final IconData icon;
  final String badgeText;
  final Color badgeBg;
  final Color badgeTextColor;
  final bool isDarkCardOnly;

  const FeaturedCardItem({
    required this.id,
    required this.name,
    required this.discountText,
    required this.buyRate,
    required this.sellRate,
    required this.icon,
    required this.badgeText,
    required this.badgeBg,
    required this.badgeTextColor,
    this.isDarkCardOnly = false,
  });
}

class HomeFeaturedCards extends StatelessWidget {
  final VoidCallback onViewAll;
  final ValueChanged<FeaturedCardItem>? onCardTap;

  const HomeFeaturedCards({
    super.key,
    required this.onViewAll,
    this.onCardTap,
  });

  static const List<FeaturedCardItem> _items = [
    FeaturedCardItem(
      id: 'apple',
      name: 'Apple',
      discountText: 'Up to 5% Off',
      buyRate: r'$90.00',
      sellRate: r'$82.00',
      icon: Boxicons.bxl_apple,
      badgeText: '🔥 Popular',
      badgeBg: Color(0xFFFFEDD5),
      badgeTextColor: Color(0xFFEA580C),
    ),
    FeaturedCardItem(
      id: 'amazon',
      name: 'Amazon',
      discountText: 'Up to 7% Off',
      buyRate: r'$95.00',
      sellRate: r'$87.00',
      icon: Boxicons.bxl_amazon,
      badgeText: '👍 Best Rate',
      badgeBg: Color(0x35F59E0B),
      badgeTextColor: Color(0xFFF59E0B),
      isDarkCardOnly: true,
    ),
    FeaturedCardItem(
      id: 'steam',
      name: 'Steam',
      discountText: 'Up to 10% Off',
      buyRate: r'$85.00',
      sellRate: r'$78.00',
      icon: Boxicons.bxl_steam,
      badgeText: '⚡ Instant',
      badgeBg: Color(0x3538BDF8),
      badgeTextColor: Color(0xFF38BDF8),
      isDarkCardOnly: true,
    ),
    FeaturedCardItem(
      id: 'google_play',
      name: 'Google Play',
      discountText: 'Up to 6% Off',
      buyRate: r'$88.00',
      sellRate: r'$80.00',
      icon: Boxicons.bxl_play_store,
      badgeText: '✓ Verified',
      badgeBg: Color(0x3510B981),
      badgeTextColor: Color(0xFF10B981),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header: Green bar + "Featured Gift Cards" + "View All >"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00D084),
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
                onViewAll();
              },
              child: Row(
                children: [
                  Text(
                    context.tr('view_all', fallback: "View All"),
                    style: const TextStyle(
                      color: Color(0xFF00D084),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 2),
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

        // Horizontal Carousel of Featured Cards (Apple & Amazon first)
        SizedBox(
          height: 142,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _items.length,
            itemBuilder: (context, index) {
              final item = _items[index];
              return _FeaturedCardWidget(
                item: item,
                isDark: isDark,
                isLast: index == _items.length - 1,
                onTap: () {
                  HapticFeedback.lightImpact();
                  onCardTap?.call(item);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FeaturedCardWidget extends StatelessWidget {
  final FeaturedCardItem item;
  final bool isDark;
  final bool isLast;
  final VoidCallback onTap;

  const _FeaturedCardWidget({
    required this.item,
    required this.isDark,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // If card is Amazon or Steam, it uses the sleek dark navy background in both light & dark mode.
    // If card is Apple, it uses soft pale mint in light mode, and dark emerald in dark mode.
    final bool useDarkTheme = isDark || item.isDarkCardOnly;

    final Gradient gradient = useDarkTheme
        ? (item.id == 'apple'
            ? const LinearGradient(
                colors: [Color(0xFF0D251D), Color(0xFF081B15)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [Color(0xFF18222C), Color(0xFF111820)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ))
        : const LinearGradient(
            colors: [Color(0xFFE2F9EE), Color(0xFFEDFCF5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    final Color borderColor = useDarkTheme
        ? (item.id == 'apple' ? const Color(0xFF164735) : const Color(0xFF263545))
        : const Color(0xFFC7F3DE);

    final Color titleColor = useDarkTheme ? Colors.white : const Color(0xFF0F172A);
    final Color subColor = useDarkTheme ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 228,
        margin: EdgeInsets.only(right: isLast ? 0 : 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: gradient,
          border: Border.all(color: borderColor, width: 1.2),
          boxShadow: [
            if (!useDarkTheme)
              BoxShadow(
                color: const Color(0x1200D084),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(17),
          child: Stack(
            children: [
              // Translucent Brand Watermark on the Right
              Positioned(
                right: -10,
                bottom: -15,
                child: Icon(
                  item.icon,
                  size: 92,
                  color: item.id == 'amazon'
                      ? const Color(0xFFF59E0B).withOpacity(0.14)
                      : (useDarkTheme
                          ? const Color(0xFF00E599).withOpacity(0.12)
                          : const Color(0xFF00D084).withOpacity(0.18)),
                ),
              ),

              // Card Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Row: Brand Icon Badge + Name & Badge + Dropdown Chevron
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Circular Icon Badge
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: useDarkTheme ? const Color(0xFF22303E) : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: useDarkTheme ? const Color(0xFF2F4255) : const Color(0xFFE2E8F0),
                              width: 1,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            item.icon,
                            color: item.id == 'amazon'
                                ? const Color(0xFFF59E0B)
                                : (useDarkTheme ? Colors.white : const Color(0xFF0F172A)),
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Title & Badge
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: TextStyle(
                                  color: titleColor,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.2,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                decoration: BoxDecoration(
                                  color: item.badgeBg,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  item.badgeText,
                                  style: TextStyle(
                                    color: item.badgeTextColor,
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w700,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Dropdown Chevron on Top-Right
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Color(0xFF00D084),
                          size: 18,
                        ),
                      ],
                    ),

                    // Middle Row: Discount Text
                    Text(
                      item.discountText,
                      style: TextStyle(
                        color: subColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    // Bottom Row: Dual Rates (Buy Rate -> and Sell Rate ↑)
                    Row(
                      children: [
                        // Buy Rate
                        Row(
                          children: [
                            Text(
                              "Buy  ",
                              style: TextStyle(
                                color: subColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              item.buyRate,
                              style: TextStyle(
                                color: titleColor,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: 2),
                            const Icon(
                              Boxicons.bx_right_arrow_alt,
                              color: Color(0xFF00D084),
                              size: 13,
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),

                        // Sell Rate
                        Row(
                          children: [
                            Text(
                              "Sell  ",
                              style: TextStyle(
                                color: subColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              item.sellRate,
                              style: TextStyle(
                                color: titleColor,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: 2),
                            const Icon(
                              Boxicons.bx_up_arrow_alt,
                              color: Color(0xFF00D084),
                              size: 13,
                            ),
                          ],
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
