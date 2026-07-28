import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../widgets/glass_card.dart';
import '../widgets/copy_button.dart';
import '../widgets/countdown_timer_card.dart';
import '../widgets/pin_auth_dialog.dart';
import 'deposit_processing_screen.dart';

class BankTransferScreen extends StatelessWidget {
  final double amount;
  final String currency;
  final double convertedUsd;

  const BankTransferScreen({
    super.key,
    required this.amount,
    required this.currency,
    required this.convertedUsd,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pay via Bank Transfer", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Countdown Timer
            CountdownTimerCard(
              onExpired: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Virtual Account Expired. Please generate a new one.")),
                );
              },
            ),

            const SizedBox(height: 16),

            // Details Card
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildDetailRow(context, "Bank Name", "Wema Bank / Flutterwave"),
                  const Divider(height: 24),
                  _buildDetailRow(context, "Account Number", "7820194832", isCopyable: true),
                  const Divider(height: 24),
                  _buildDetailRow(context, "Account Name", "NobleCards - Settlement"),
                  const Divider(height: 24),
                  _buildDetailRow(context, "Amount", "$currency ${amount.toStringAsFixed(2)}", isBold: true),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Instruction Note
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Boxicons.bx_info_circle, color: Colors.amber, size: 22),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Transfer the EXACT amount above. Deposit is credited automatically within 60 seconds.",
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.amber),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Payment Confirmation CTA
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => PinAuthDialog(
                      onSuccess: (pin) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DepositProcessingScreen(
                              amount: amount,
                              currency: currency,
                              convertedUsd: convertedUsd,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                child: const Text(
                  "I Have Made The Transfer",
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, {bool isCopyable = false, bool isBold = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            color: isDark ? Colors.white60 : Colors.black54,
          ),
        ),
        Row(
          children: [
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: isBold ? 16 : 14,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              ),
            ),
            if (isCopyable) ...[
              const SizedBox(width: 8),
              CopyButton(textToCopy: value),
            ]
          ],
        )
      ],
    );
  }
}