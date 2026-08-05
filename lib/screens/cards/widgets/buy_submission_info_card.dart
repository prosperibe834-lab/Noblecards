import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';

class BuySubmissionInfoCard extends StatelessWidget {
  const BuySubmissionInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          _buildDetailRow(context, Boxicons.bx_hash, 'Reference ID', 'NC-2026-54231', isHighlighted: true, isGreen: true),
          _buildDashedDivider(isDark),
          _buildDetailRow(context, Boxicons.bx_credit_card, 'Gift Card', 'Amazon Gift Card'),
          _buildDashedDivider(isDark),
          _buildDetailRow(context, Boxicons.bx_globe, 'Region', 'United States 🇺🇸'),
          _buildDashedDivider(isDark),
          _buildDetailRow(context, Boxicons.bx_layer, 'Quantity', '1'),
          _buildDashedDivider(isDark),
          _buildDetailRow(context, Boxicons.bx_purchase_tag, 'Card Type', 'Digital Code'),
          _buildDashedDivider(isDark),
          _buildDetailRow(context, Boxicons.bx_dollar_circle, 'Face Value', '\$100.00'),
          _buildDashedDivider(isDark),
          _buildDetailRow(context, Boxicons.bx_wallet, 'Amount Paid', '\$98.50', isHighlighted: true, isGreen: true),
          _buildDashedDivider(isDark),
          _buildDetailRow(context, Boxicons.bx_credit_card_front, 'Payment Method', 'USD Wallet'),
          _buildDashedDivider(isDark),
          _buildDetailRow(context, Boxicons.bx_calendar, 'Purchase Date', '29 Jul 2026, 10:42 AM'),
          _buildDashedDivider(isDark),
          _buildDetailRow(context, Boxicons.bx_send, 'Delivery', 'Instant'),
          _buildDashedDivider(isDark),
          _buildDetailRow(context, Boxicons.bx_check_shield, 'Status', 'Completed', isHighlighted: true, isGreen: true),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, 
    IconData icon, 
    String label, 
    String value, {
    bool isHighlighted = false,
    bool isGreen = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: isDark ? Colors.white54 : Colors.black54),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w600,
              color: isGreen 
                  ? AppColors.success 
                  : (isDark ? Colors.white : Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashedDivider(bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 4.0;
        const dashHeight = 1.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: isDark ? Colors.white12 : Colors.black.withOpacity(0.08)),
              ),
            );
          }),
        );
      },
    );
  }
}