import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boxicons/boxicons.dart';
import '../../../localization/app_localizations.dart';

class MarketDataItem {
  final String key;
  final String tag;
  final IconData icon;
  final String price;
  final String change;
  final Color iconBgColor;
  final Color iconColor;

  const MarketDataItem({
    required this.key,
    required this.tag,
    required this.icon,
    required this.price,
    required this.change,
    required this.iconBgColor,
    required this.iconColor,
  });
}

class HomeTodaysMarket extends StatelessWidget {
  final VoidCallback onViewAll;
  final ValueChanged<MarketDataItem>? onItemTap;

  const HomeTodaysMarket({
    super.key,
    required this.onViewAll,
    this.onItemTap,
  });

  static const List<MarketDataItem> marketItems = [
    MarketDataItem(
      key: 'highest_paying',
      tag: 'Highest Paying',
      icon: Boxicons.bxl_amazon,
      price: '₦480.00',
      change: '↑ 8.2%',
      iconBgColor: Color(0xFF111111),
      iconColor: Colors.white,
    ),
    MarketDataItem(
      key: 'trending',
      tag: 'Trending',
      icon: Boxicons.bxl_steam,
      price: '₦430.00',
      change: '↑ 6.5%',
      iconBgColor: Color(0xFF1B2838),
      iconColor: Colors.white,
    ),
    MarketDataItem(
      key: 'most_traded',
      tag: 'Most Traded',
      icon: Boxicons.bxl_apple,
      price: '₦690.00',
      change: '↑ 5.1%',
      iconBgColor: Color(0xFF2E1065),
      iconColor: Colors.white,
    ),
    MarketDataItem(
      key: 'best_selling',
      tag: 'Best Selling',
      icon: Boxicons.bxl_play_store,
      price: '₦340.00',
      change: '↑ 4.3%',
      iconBgColor: Color(0xFFE6F8F0),
      iconColor: Color(0xFF00D084),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF121C24) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E2D38) : const Color(0xFFE2E8F0);
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subColor = isDark ? const Color(0xFF8B9FA8) : const Color(0xFF64748B);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header: "Today's Market" & "View all"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.tr('todays_market', fallback: "Today's Market"),
              style: TextStyle(
                color: titleColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                onViewAll();
              },
              child: Text(
                context.tr('view_all', fallback: "View all"),
                style: const TextStyle(
                  color: Color(0xFF00D084),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Horizontal List of Market Cards
        SizedBox(
          height: 98,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: marketItems.length,
            itemBuilder: (context, index) {
              final item = marketItems[index];

              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onItemTap?.call(item);
                },
                child: Container(
                  width: 132,
                  margin: EdgeInsets.only(
                    right: index == marketItems.length - 1 ? 0 : 12,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 11),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor, width: 1.1),
                    boxShadow: [
                      if (!isDark)
                        BoxShadow(
                          color: Colors.black.withOpacity(0.035),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Tag
                      Text(
                        context.tr(item.key, fallback: item.tag),
                        style: TextStyle(
                          color: subColor,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Brand Icon + Price and % Change
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: item.iconBgColor,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Center(
                              child: Icon(
                                item.icon,
                                color: item.iconColor,
                                size: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item.price,
                                  style: TextStyle(
                                    color: titleColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.2,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  item.change,
                                  style: const TextStyle(
                                    color: Color(0xFF00D084),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
