import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boxicons/boxicons.dart';
import '../../../localization/app_localizations.dart';

class HomeActionButtons extends StatelessWidget {
  final VoidCallback onBuyTap;
  final VoidCallback onSellTap;

  const HomeActionButtons({
    super.key,
    required this.onBuyTap,
    required this.onSellTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sellBgColor = isDark ? const Color(0xFF131E27) : Colors.white;
    final sellBorderColor = isDark ? const Color(0xFF1E2D38) : const Color(0xFFE2E8F0);
    final sellTextColor = isDark ? Colors.white : const Color(0xFF0F172A);

    return Row(
      children: [
        // 1. Buy Gift Cards (Emerald Filled Gradient)
        Expanded(
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              onBuyTap();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00E599), Color(0xFF00B074)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x3500D084),
                    blurRadius: 14,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Boxicons.bx_shopping_bag,
                    color: Colors.white,
                    size: 19,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    context.tr('buy_gift_cards', fallback: "Buy Gift Cards"),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // 2. Sell Gift Cards (Adaptive Card Button)
        Expanded(
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              onSellTap();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: sellBgColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: sellBorderColor, width: 1.2),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Boxicons.bx_purchase_tag,
                    color: Color(0xFF00D084),
                    size: 19,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    context.tr('sell_gift_cards', fallback: "Sell Gift Cards"),
                    style: TextStyle(
                      color: sellTextColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

