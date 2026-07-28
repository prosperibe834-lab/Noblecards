import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../widgets/glass_card.dart';

class DepositReceiptScreen extends StatelessWidget {
  final double amount;
  final String currency;
  final double convertedUsd;

  const DepositReceiptScreen({
    super.key,
    required this.amount,
    required this.currency,
    required this.convertedUsd,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction Receipt", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
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
                  Icon(Boxicons.bx_credit_card_front, color: Theme.of(context).primaryColor, size: 28),
                  const SizedBox(width: 8),
                  const Text("NOBLECARDS", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
              const SizedBox(height: 16),
              const Text("DEPOSIT RECEIPT", style: TextStyle(fontFamily: 'Poppins', fontSize: 11, letterSpacing: 2, color: Colors.grey)),
              const SizedBox(height: 8),
              Text(
                "\$${convertedUsd.toStringAsFixed(2)} USD",
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              const Divider(),
              _item("Transaction ID", "TXN-2026-081920"),
              _item("Status", "COMPLETED", color: Colors.green),
              _item("Deposit Amount", "$currency ${amount.toStringAsFixed(2)}"),
              _item("Exchange Rate", "1 USD = $currency ${(amount / convertedUsd).toStringAsFixed(2)}"),
              _item("Fee", "$currency 0.00"),
              _item("Payment Method", "Flutterwave Virtual Account"),
              _item("Date & Time", "July 28, 2026 • 03:02 PM"),
              const Divider(height: 32),
              const Text(
                "NobleCards Financial Services Ltd.",
                style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Colors.grey),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(String label, String val, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey)),
          Text(
            val,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}