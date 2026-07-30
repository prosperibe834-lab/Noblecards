import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glass_card.dart';
import '../../models/withdrawal_models.dart';

class WithdrawalReceiptScreen extends StatelessWidget {
  final WithdrawalTransaction transaction;

  const WithdrawalReceiptScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final subTextColor = isDark ? AppColors.darkSubText : AppColors.lightSubText;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Official Receipt"),
        actions: [
          IconButton(icon: const Icon(Boxicons.bx_share_alt), onPressed: () {}),
          IconButton(icon: const Icon(Boxicons.bx_download), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: GlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Boxicons.bx_credit_card_front, color: theme.primaryColor, size: 28),
                  const SizedBox(width: 8),
                  Text("NOBLECARDS", style: theme.textTheme.titleLarge?.copyWith(fontSize: 18, letterSpacing: 1.2)),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                "WITHDRAWAL RECEIPT",
                style: TextStyle(fontSize: 11, letterSpacing: 2, color: subTextColor),
              ),
              const SizedBox(height: 8),
              Text(
                "${transaction.currency} ${transaction.receivedAmount.toStringAsFixed(2)}",
                style: theme.textTheme.headlineLarge?.copyWith(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Divider(),
              _item(context, "Reference ID", transaction.reference, subTextColor),
              _item(context, "Status", transaction.status.toUpperCase(), subTextColor, valueColor: AppColors.success),
              _item(context, "Withdrawn (USD)", "\$${transaction.amountUsd.toStringAsFixed(2)}", subTextColor),
              _item(context, "Exchange Rate", "1 USD = ${transaction.currency} ${transaction.exchangeRate.toStringAsFixed(2)}", subTextColor),
              _item(context, "Fee", "\$${transaction.feeUsd.toStringAsFixed(2)} USD", subTextColor),
              _item(context, "Method", transaction.methodTitle, subTextColor),
              _item(context, "Recipient", transaction.recipientDetails, subTextColor),
              _item(context, "Date & Time", "${transaction.date} • ${transaction.time}", subTextColor),
              const Divider(height: 32),
              Text(
                "NobleCards Global Payout Services",
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 11, color: subTextColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(BuildContext context, String label, String val, Color subTextColor, {Color? valueColor}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12, color: subTextColor)),
          Text(val, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12, fontWeight: FontWeight.bold, color: valueColor)),
        ],
      ),
    );
  }
}