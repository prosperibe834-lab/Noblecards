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

  static const List<QuickActionItem> actions = [
    QuickActionItem(
      key: 'buy_cards',
      label: 'Buy Gift\nCards',
      icon: Boxicons.bx_shopping_bag,
    ),
    QuickActionItem(
      key: 'sell_cards',
      label: 'Sell\nCards',
      icon: Boxicons.bx_refresh,
    ),
    QuickActionItem(
      key: 'exchange_rates',
      label: 'Exchange\nRates',
      icon: Boxicons.bx_line_chart,
    ),
    QuickActionItem(
      key: 'my_orders',
      label: 'My\nOrders',
      icon: Boxicons.bx_receipt,
    ),
    QuickActionItem(
      key: 'my_wallet',
      label: 'My\nWallet',
      icon: Boxicons.bx_wallet,
    ),
    QuickActionItem(
      key: 'transaction_history',
      label: 'Transaction\nHistory',
      icon: Boxicons.bx_history,
    ),
    QuickActionItem(
      key: 'saved_cards',
      label: 'Saved\nCards',
      icon: Boxicons.bx_credit_card,
    ),
    QuickActionItem(
      key: 'referral_program',
      label: 'Referral\nProgram',
      icon: Boxicons.bx_gift,
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF121C24) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E2D38) : const Color(0xFFF1F5F9);
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header: "Quick Actions"
        Text(
          context.tr('quick_actions', fallback: "Quick Actions"),
          style: TextStyle(
            color: titleColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 12),

        // 4x2 Grid Matrix
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.88,
          ),
          itemBuilder: (context, index) {
            final item = actions[index];
            return _QuickActionButton(
              item: item,
              cardBg: cardBg,
              borderColor: borderColor,
              isDark: isDark,
              onTap: () => _handleAction(context, item.key),
            );
          },
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatefulWidget {
  final QuickActionItem item;
  final Color cardBg;
  final Color borderColor;
  final bool isDark;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.item,
    required this.cardBg,
    required this.borderColor,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<_QuickActionButton> {
  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDark ? Colors.white : const Color(0xFF0F172A);

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: widget.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: widget.borderColor, width: 1.1),
          boxShadow: [
            if (!widget.isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.025),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Emerald Icon Box
            Container(
              padding: const EdgeInsets.all(7.5),
              decoration: BoxDecoration(
                color: const Color(0xFF00D084).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                widget.item.icon,
                color: const Color(0xFF00D084),
                size: 20,
              ),
            ),
            const SizedBox(height: 7),

            // Title (2 lines)
            Text(
              context.tr(widget.item.key, fallback: widget.item.label),
              textAlign: TextAlign.center,
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
