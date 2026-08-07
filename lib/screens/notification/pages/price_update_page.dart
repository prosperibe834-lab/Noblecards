// Where to paste: lib/screens/notification/pages/price_update_page.dart

import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class PriceUpdatePage extends StatelessWidget {
  const PriceUpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rate Update")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Boxicons.bx_trending_up, size: 70, color: Color(0xFF00C853)),
            const SizedBox(height: 16),
            const Text("Apple Gift Card Rate Increased", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _row("Gift Card", "Apple / iTunes"),
                    _row("Old Rate", "₦820/\$"),
                    _row("New Rate", "₦860/\$"),
                    _row("Change", "+4.88%"),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              onPressed: () {},
              child: const Text("Sell Apple Cards"),
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