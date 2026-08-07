// Where to paste: lib/screens/notification/pages/welcome_bonus_page.dart

import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class WelcomeBonusPage extends StatelessWidget {
  const WelcomeBonusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Welcome Bonus")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Boxicons.bx_gift, size: 70, color: Colors.purple),
            const SizedBox(height: 16),
            const Text("\$5.00 Welcome Bonus", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Credited to your wallet"),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              onPressed: () => Navigator.pop(context),
              child: const Text("View Wallet"),
            )
          ],
        ),
      ),
    );
  }
}