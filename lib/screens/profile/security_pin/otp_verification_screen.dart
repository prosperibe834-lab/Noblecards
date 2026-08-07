import 'dart:async';
import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../widgets/otp_input.dart';
import '../../../widgets/primary_gradient_button.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpCtrl = TextEditingController();
  Timer? _timer;
  int _seconds = 60;
  bool _isLoading = false;

  // Placeholder. Connect your actual user state here.
  final String _userEmail = "user@gmail.com"; 

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() => _seconds = 60);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        timer.cancel();
      } else {
        setState(() => _seconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpCtrl.dispose();
    super.dispose();
  }

  void _verifyOtp(String otp) async {
    setState(() => _isLoading = true);
    
    // Simulate verification delay
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    setState(() => _isLoading = false);

    // Pop back to change PIN screen, conceptually unlocking Section 2 & 3
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Identity verified. Please set your new PIN."),
        backgroundColor: Color(0xFF00C853),
      ),
    );
  }

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Verify OTP",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 14, color: isDark ? Colors.white70 : Colors.black54, height: 1.5),
                children: [
                  const TextSpan(text: "Fill in the box below with the OTP.\nPlease check the OTP sent to "),
                  TextSpan(text: _userEmail, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 40),
            OtpInput(
              controller: _otpCtrl,
              onCompleted: _verifyOtp,
            ),
            const SizedBox(height: 40),
            Center(
              child: _seconds > 0
                  ? Text(
                      "00:${_seconds.toString().padLeft(2, '0')}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    )
                  : Column(
                      children: [
                        Text(
                          "Didn't receive code?",
                          style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                        ),
                        TextButton(
                          onPressed: () {
                            _startTimer();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("OTP Sent Successfully"),
                                backgroundColor: Color(0xFF00C853),
                              ),
                            );
                          },
                          child: const Text(
                            "Try Again / Resend OTP",
                            style: TextStyle(color: Color(0xFF00C853), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
            ),
            const Spacer(),
            PrimaryGradientButton(
              text: "Verify",
              isLoading: _isLoading,
              onPressed: _otpCtrl.text.length == 6 ? () => _verifyOtp(_otpCtrl.text) : null,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}