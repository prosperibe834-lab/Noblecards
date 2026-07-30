import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../theme/app_colors.dart';
import '../../widgets/animated_success_widget.dart';
import '../../widgets/glass_card.dart';
import '../../models/withdrawal_models.dart';
import 'withdrawal_receipt_screen.dart';

class WithdrawSuccessScreen extends StatelessWidget {
  final WithdrawalTransaction transaction;

  const WithdrawSuccessScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final subTextColor = isDark ? AppColors.darkSubText : AppColors.lightSubText;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const AnimatedSuccessWidget(size: 90),
              const SizedBox(height: 20),
              Text(
                "Withdrawal Submitted!",
                style: theme.textTheme.titleLarge?.copyWith(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                "Your payout request is being processed.",
                style: theme.textTheme.bodyMedium?.copyWith(color: subTextColor),
              ),
              const SizedBox(height: 24),
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _row(context, "Reference", transaction.reference, subTextColor),
                    const Divider(height: 16),
                    _row(context, "Payout Amount", "${transaction.currency} ${transaction.receivedAmount.toStringAsFixed(2)}", subTextColor, isBold: true),
                    const Divider(height: 16),
                    _row(context, "Destination", transaction.recipientDetails, subTextColor),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Boxicons.bx_receipt),
                      label: const Text("View Receipt"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WithdrawalReceiptScreen(transaction: transaction),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                      child: const Text("Done", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value, Color subTextColor, {bool isBold = false}) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: subTextColor, fontSize: 13)),
        Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: isBold ? FontWeight.bold : FontWeight.w600, fontSize: 13)),
      ],
    );
  }
}