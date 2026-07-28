import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../widgets/animated_success_widget.dart';
import '../widgets/glass_card.dart';
import 'deposit_receipt_screen.dart';

class DepositSuccessScreen extends StatelessWidget {
  final double amount;
  final String currency;
  final double convertedUsd;

  const DepositSuccessScreen({
    super.key,
    required this.amount,
    required this.currency,
    required this.convertedUsd,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const AnimatedSuccessWidget(size: 100),
              const SizedBox(height: 24),
              const Text(
                "Deposit Successful!",
                style: TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "Your wallet has been updated immediately.",
                style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildRow("Amount Paid", "$currency ${amount.toStringAsFixed(2)}"),
                    const Divider(height: 20),
                    _buildRow("USD Credited", "\$${convertedUsd.toStringAsFixed(2)}", isHighlight: true),
                    const Divider(height: 20),
                    _buildRow("Transaction Ref", "NC-89201948", isBold: true),
                  ],
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  icon: const Icon(Boxicons.bx_receipt),
                  label: const Text("View Official Receipt", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DepositReceiptScreen(
                          amount: amount,
                          currency: currency,
                          convertedUsd: convertedUsd,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                  child: const Text("Done", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isHighlight = false, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.grey)),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: isHighlight ? 16 : 14,
            fontWeight: (isHighlight || isBold) ? FontWeight.bold : FontWeight.w600,
            color: isHighlight ? Colors.green : null,
          ),
        ),
      ],
    );
  }
}