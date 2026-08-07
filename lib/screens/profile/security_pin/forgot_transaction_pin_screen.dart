import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../widgets/primary_gradient_button.dart';
import 'otp_verification_screen.dart';

class ForgotTransactionPinScreen extends StatelessWidget {
  const ForgotTransactionPinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1419) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Boxicons.bx_chevron_left, color: isDark ? Colors.white : Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'security_shield',
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF00C853).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Boxicons.bx_shield_quarter, color: Color(0xFF00C853), size: 60),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "Forgot Transaction PIN?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "To reset your transaction PIN we need to verify your identity. Press Continue to send an OTP to your registered email.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 48),
            PrimaryGradientButton(
              text: "Continue",
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const OtpVerificationScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}