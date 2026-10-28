import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boxicons/boxicons.dart';
import '../../../localization/app_localizations.dart';
import '../../cards/buy_gift_cards_catalog_screen.dart';
import '../../cards/sell_gift_cards_catalog_screen.dart';
import '../../rate/market_rates_screen.dart';
import '../../orders/orders_screen.dart';
import '../../wallet_screen.dart';
import '../../TransactionHistory/widgets/transaction_history_screen.dart';
import '../../referral/referral_screen.dart';

class QuickActionItem {
  final String key;
  final String label;
  final IconData icon;

  const QuickActionItem({
    required this.key,
    required this.label,
    required this.icon,
  });
}

class HomeQuickActions extends StatelessWidget {
  final VoidCallback? onNavigateToCards;

  const HomeQuickActions({
    super.key,
    this.onNavigateToCards,
  });

  // All 8 quick actions matching Image 1
  static const List<QuickActionItem> actions = [
    QuickActionItem(
      key: 'buy_cards',
      label: 'Buy Gift Cards',
      icon: Boxicons.bx_gift,
    ),
    QuickActionItem(
      key: 'sell_cards',
      label: 'Sell Cards',
      icon: Boxicons.bx_purchase_tag,
    ),
    QuickActionItem(
      key: 'exchange_rates',
      label: 'Exchange Rates',
      icon: Boxicons.bx_line_chart,
    ),
    QuickActionItem(
      key: 'my_orders',
      label: 'My Orders',
      icon: Boxicons.bx_receipt,
    ),
    QuickActionItem(
      key: 'my_wallet',
      label: 'My Wallet',
      icon: Boxicons.bx_wallet,
    ),
    QuickActionItem(
      key: 'transaction_history',
      label: 'Transaction History',
      icon: Boxicons.bx_history,
    ),
    QuickActionItem(
      key: 'saved_cards',
      label: 'Saved Cards',
      icon: Boxicons.bx_credit_card,
    ),
    QuickActionItem(
      key: 'referral_program',
      label: 'Referral Program',
      icon: Boxicons.bx_user_plus,
    ),
  ];

  void _handleAction(BuildContext context, String actionKey) {
    HapticFeedback.lightImpact();
    switch (actionKey) {
      case 'buy_cards':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BuyGiftCardsCatalogScreen()),
        );
        break;
      case 'sell_cards':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SellGiftCardsCatalogScreen()),
        );
        break;
      case 'exchange_rates':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MarketRatesScreen()),
        );
        break;
      case 'my_orders':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const OrdersScreen()),
        );
        break;
      case 'my_wallet':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const WalletScreen()),
        );
        break;
      case 'transaction_history':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TransactionHistoryScreen()),
        );
        break;
      case 'saved_cards':
        onNavigateToCards?.call();
        break;
      case 'referral_program':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ReferralScreen()),
        );
        break;
      default:
        onNavigateToCards?.call();
    }
  }

  void _showAllActionsBottomSheet(BuildContext context) {
    HapticFeedback.mediumImpact();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0F1A20) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);

    showModalBottomSheet(
      context: context,
      backgroundColor: bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF273844) : const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "All Quick Actions",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: actions.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.84,
                  ),
                  itemBuilder: (_, index) {
                    final item = actions[index];
                    return _QuickActionButton(
                      item: item,
                      isDark: isDark,
                      onTap: () {
                        Navigator.pop(ctx);
                        _handleAction(context, item.key);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header: "Quick Actions" + "View All >" matching Image 2
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.tr('quick_actions', fallback: "Quick Actions"),
              style: TextStyle(
                color: titleColor,
                fontSize: 16.5,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
            GestureDetector(
              onTap: () => _showAllActionsBottomSheet(context),
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

        // 4x2 Grid of all 8 items styled exactly like Image 2
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.84,
          ),
          itemBuilder: (context, index) {
            final item = actions[index];
            return _QuickActionButton(
              item: item,
              isDark: isDark,
              onTap: () => _handleAction(context, item.key),
            );
          },
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final QuickActionItem item;
  final bool isDark;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.item,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Exact styling from Image 2:
    // Outer rounded card container with dark slate / soft mint background
    final cardBg = isDark ? const Color(0xFF0D1D17) : const Color(0xFFEAF8F1);
    final borderColor = isDark ? const Color(0xFF163327) : const Color(0xFFD4F2E4);
    final iconGlowBg = isDark
        ? const Color(0xFF00E599).withOpacity(0.12)
        : const Color(0xFF00D084).withOpacity(0.12);
    final iconColor = isDark ? const Color(0xFF00E599) : const Color(0xFF00D084);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor, width: 1.1),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: const Color(0x0C00D084),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Inner Glowing Icon Badge (from Image 2)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconGlowBg,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  if (isDark)
                    BoxShadow(
                      color: const Color(0xFF00E599).withOpacity(0.10),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                ],
              ),
              child: Center(
                child: Icon(
                  item.icon,
                  color: iconColor,
                  size: 21,
                ),
              ),
            ),
            const SizedBox(height: 6),

            // Label text below icon
            Text(
              context.tr(item.key, fallback: item.label),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                height: 1.15,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
