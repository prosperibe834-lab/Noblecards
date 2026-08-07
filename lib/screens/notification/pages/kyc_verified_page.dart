// Where to paste: lib/screens/notification/pages/kyc_verified_page.dart

import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class KycVerifiedPage extends StatelessWidget {
  const KycVerifiedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("KYC Verification")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Boxicons.bx_check_shield, size: 70, color: Color(0xFF00C853)),
            const SizedBox(height: 16),
            const Text("Identity Verified!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text("Higher transaction limits and instant bank withdrawals are now unlocked for your account."),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              onPressed: () => Navigator.pop(context),
              child: const Text("Done"),
            )
          ],
        ),
      ),
    );
  }
}