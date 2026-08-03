import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:noble_cards/theme/app_colors.dart';
import 'package:noble_cards/theme/app_radius.dart';
import 'package:noble_cards/theme/app_spacing.dart';
import '../providers/buy_provider.dart';

class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BuyProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? AppColors.primary.withOpacity(0.05)
        : AppColors.primary.withOpacity(0.03);
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subTextColor = isDark
        ? AppColors.darkSubText
        : AppColors.lightSubText;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order Summary',
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Text(
                    'See Details',
                    style: TextStyle(color: AppColors.primary, fontSize: 12),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 10,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildRow(
            'Amount',
            '${provider.currencySymbol}${provider.amount.toStringAsFixed(2)}',
            subTextColor,
            textColor,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildRow(
            'Quantity',
            'x ${provider.quantity}',
            subTextColor,
            textColor,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildRow(
            'Rate',
            '${provider.currentRate.toStringAsFixed(2)}%',
            subTextColor,
            textColor,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Divider(color: AppColors.primary.withOpacity(0.1)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total to Pay',
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${provider.currencySymbol}${provider.totalToPay.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    String label,
    String value,
    Color labelColor,
    Color valueColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: labelColor, fontSize: 14)),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
