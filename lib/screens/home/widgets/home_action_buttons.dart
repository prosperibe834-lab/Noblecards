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

    final sellBgColor = isDark ? const Color(0xFF0E1A16) : Colors.white;
    final sellBorderColor = isDark ? const Color(0xFF1B382D) : const Color(0xFFE2E8F0);
    final sellTextColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final sellArrowColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Row(
      children: [
        // 1. Buy Gift Cards (Solid Emerald Green with Right Arrow)
        Expanded(
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              onBuyTap();
            },
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00E599), Color(0xFF00A859)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? const Color(0x4000E599) : const Color(0x3500D084),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Boxicons.bx_credit_card_front,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 7),
                  Flexible(
                    child: Text(
                      context.tr('buy_gift_cards', fallback: "Buy Gift Cards"),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                        letterSpacing: -0.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Icon(
                    Boxicons.bx_right_arrow_alt,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // 2. Sell Gift Cards (Adaptive Card Button with Green Tag and Right Arrow)
        Expanded(
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              onSellTap();
            },
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: sellBgColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: sellBorderColor, width: 1.2),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Boxicons.bx_purchase_tag,
                    color: isDark ? const Color(0xFF00E599) : const Color(0xFF00D084),
                    size: 18,
                  ),
                  const SizedBox(width: 7),
                  Flexible(
                    child: Text(
                      context.tr('sell_gift_cards', fallback: "Sell Gift Cards"),
                      style: TextStyle(
                        color: sellTextColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                        letterSpacing: -0.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    Boxicons.bx_right_arrow_alt,
                    color: sellArrowColor,
                    size: 16,
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
