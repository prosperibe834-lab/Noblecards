// Where to paste: lib/screens/notification/pages/promotion_details_page.dart

import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class PromotionDetailsPage extends StatelessWidget {
  const PromotionDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Promotion Details")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Boxicons.bx_bell, size: 60, color: Colors.amber),
            const SizedBox(height: 16),
            const Text("2% Bonus Weekend Special", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text("Sell any gift card this weekend and instantly receive a 2% extra bonus credited to your wallet balance."),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              onPressed: () {},
              child: const Text("Trade Now"),
            )
          ],
        ),
      ),
    );
  }
}