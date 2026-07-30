import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/glass_card.dart';

class WithdrawalSummaryCard extends StatelessWidget {
  final double amountUsd;
  final double rate;
  final String currencyCode;
  final double feeUsd;
  final String estimatedArrival;

  const WithdrawalSummaryCard({
    super.key,
    required this.amountUsd,
    required this.rate,
    required this.currencyCode,
    required this.feeUsd,
    required this.estimatedArrival,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final subTextColor = isDark ? AppColors.darkSubText : AppColors.lightSubText;

    final double netAmountUsd = (amountUsd - feeUsd).clamp(0, double.infinity);
    final double payoutAmount = netAmountUsd * rate;

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Live Summary",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "Estimated: $estimatedArrival",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _row(context, "You Withdraw", "\$${amountUsd.toStringAsFixed(2)} USD", subTextColor),
          _row(context, "Exchange Rate", "1 USD = $currencyCode ${rate.toStringAsFixed(2)}", subTextColor),
          _row(context, "Processing Fee", "\$${feeUsd.toStringAsFixed(2)} USD", subTextColor),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "You'll Receive",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Text(
                  "$currencyCode ${payoutAmount.toStringAsFixed(2)}",
                  key: ValueKey<double>(payoutAmount),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value, Color subTextColor) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: subTextColor,
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}