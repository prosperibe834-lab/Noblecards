import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';

class ReceiptHeader extends StatelessWidget {
  const ReceiptHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Boxicons.bx_credit_card_front, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 8),
                Text(
                  'NobleCards',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : Colors.black,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'GIFT CARD SUBMISSION RECEIPT',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
              ),
            ),
          ],
        ),
        Icon(
          Boxicons.bx_badge_check,
          size: 48,
          color: AppColors.success.withOpacity(isDark ? 0.8 : 1.0),
        ),
      ],
    );
  }
}