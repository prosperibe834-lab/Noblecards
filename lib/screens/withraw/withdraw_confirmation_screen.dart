import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glass_card.dart';
import '../../models/withdrawal_models.dart';
import 'withdraw_success_screen.dart';

class WithdrawConfirmationScreen extends StatelessWidget {
  final CurrencyOption currency;
  final WithdrawalMethodModel method;
  final String accountDetails;
  final double amountUsd;
  final double feeUsd;

  const WithdrawConfirmationScreen({
    super.key,
    required this.currency,
    required this.method,
    required this.accountDetails,
    required this.amountUsd,
    required this.feeUsd,
  });

  void _authenticateAndProceed(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _buildPinAuthSheet(context),
    );
  }

  Widget _buildPinAuthSheet(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Boxicons.bx_lock_alt, size: 40),
          const SizedBox(height: 12),
          Text(
            "Security Verification",
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text("Enter your 4-digit PIN to authorize withdrawal"),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              4,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index < 2 ? theme.primaryColor : Colors.grey.shade300,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          IconButton(
            icon: const Icon(Boxicons.bx_fingerprint, size: 44),
            onPressed: () => _executeWithdrawal(context),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close sheet
                _executeWithdrawal(context);
              },
              child: const Text("Confirm & Submit"),
            ),
          )
        ],
      ),
    );
  }

  void _executeWithdrawal(BuildContext context) {
    final double netUsd = amountUsd - feeUsd;
    final double payout = netUsd * currency.rateToUsd;

    final txn = WithdrawalTransaction(
      id: "WTH-89021",
      reference: "REF-2026-072910",
      amountUsd: amountUsd,
      receivedAmount: payout,
      currency: currency.code,
      exchangeRate: currency.rateToUsd,
      feeUsd: feeUsd,
      methodTitle: method.title,
      recipientDetails: accountDetails,
      date: "July 29, 2026",
      time: "05:20 PM",
      status: "Processing",
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => WithdrawSuccessScreen(transaction: txn)),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final subTextColor = isDark ? AppColors.darkSubText : AppColors.lightSubText;

    final double netUsd = amountUsd - feeUsd;
    final double payout = netUsd * currency.rateToUsd;

    return Scaffold(
      appBar: AppBar(title: const Text("Review Withdrawal")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GlassCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text("Total Payout", style: TextStyle(color: subTextColor, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(
                    "${currency.code} ${payout.toStringAsFixed(2)}",
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                  const Divider(height: 32),
                  _item(context, "Withdraw Amount", "\$${amountUsd.toStringAsFixed(2)} USD", subTextColor),
                  _item(context, "Target Currency", currency.name, subTextColor),
                  _item(context, "Exchange Rate", "1 USD = ${currency.code} ${currency.rateToUsd.toStringAsFixed(2)}", subTextColor),
                  _item(context, "Processing Fee", "\$${feeUsd.toStringAsFixed(2)} USD", subTextColor),
                  _item(context, "Method", method.title, subTextColor),
                  _item(context, "Destination Account", accountDetails, subTextColor),
                  _item(context, "Estimated Arrival", method.estimatedTime, subTextColor),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => _authenticateAndProceed(context),
                child: const Text("Confirm Withdrawal", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _item(BuildContext context, String label, String val, Color subTextColor) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: subTextColor, fontSize: 13)),
          Text(val, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}