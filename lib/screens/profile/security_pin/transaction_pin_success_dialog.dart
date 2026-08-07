import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../widgets/primary_gradient_button.dart';

class TransactionPinSuccessDialog extends StatelessWidget {
  const TransactionPinSuccessDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const TransactionPinSuccessDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: isDark ? const Color(0xFF141A21) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder(
              duration: const Duration(milliseconds: 600),
              tween: Tween<double>(begin: 0, end: 1),
              builder: (context, double value, child) {
                return Transform.scale(
                  scale: Curves.elasticOut.transform(value),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00C853).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Boxicons.bx_check_circle,
                      color: Color(0xFF00C853),
                      size: 64,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              "Transaction PIN Updated",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Your transaction PIN has been changed successfully. You can now use your new PIN.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            PrimaryGradientButton(
              text: "Done",
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Return to Security screen
              },
            ),
          ],
        ),
      ),
    );
  }
}