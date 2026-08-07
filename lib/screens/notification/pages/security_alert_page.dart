// Where to paste: lib/screens/notification/pages/security_alert_page.dart

import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class SecurityAlertPage extends StatelessWidget {
  const SecurityAlertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Security Alert")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Boxicons.bx_shield_quarter, size: 70, color: Colors.redAccent),
            const SizedBox(height: 16),
            const Text("New Login Detected", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _row("Device", "iPhone 17 Pro Max"),
                    _row("IP Address", "192.168.1.45"),
                    _row("Location", "Lagos, Nigeria"),
                    _row("Date & Time", "Yesterday, 11:45 PM"),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color(0xFF00C853),
              ),
              onPressed: () {},
              child: const Text("This Was Me"),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              onPressed: () {},
              child: const Text("Secure My Account", style: TextStyle(color: Colors.redAccent)),
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