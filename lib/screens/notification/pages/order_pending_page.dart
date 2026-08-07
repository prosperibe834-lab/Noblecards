// Where to paste: lib/screens/notification/pages/order_pending_page.dart

import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class OrderPendingPage extends StatelessWidget {
  const OrderPendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text("Order Status")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Boxicons.bx_time_five, size: 70, color: Colors.orange),
            const SizedBox(height: 16),
            const Text("Order Pending Review", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _row("Order ID", "#NC-984210"),
                    _row("Gift Card", "Steam Gift Card \$100"),
                    _row("Submitted Time", "Today, 08:30 AM"),
                    _row("Current Stage", "Verification"),
                    _row("Expected", "Within 15 mins"),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Boxicons.bx_support),
                    label: const Text("Support"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Boxicons.bx_refresh),
                    label: const Text("Refresh"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(val, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}