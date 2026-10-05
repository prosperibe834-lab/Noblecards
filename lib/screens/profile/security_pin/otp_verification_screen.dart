import 'dart:async';
import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../authentication/services/authentication_service.dart';
import '../../../widgets/otp_input.dart';
import '../../../widgets/primary_gradient_button.dart';
import '../../../widgets/transaction_pin_input.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key, this.userEmail = 'your registered email'});

  final String userEmail;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpCtrl = TextEditingController();
  final TextEditingController _newPinCtrl = TextEditingController();
  final TextEditingController _confirmPinCtrl = TextEditingController();
  final FocusNode _newPinFocus = FocusNode();
  final FocusNode _confirmPinFocus = FocusNode();
  Timer? _timer;
  int _seconds = 60;
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _resetToken;

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
    _newPinCtrl.dispose();
    _confirmPinCtrl.dispose();
    _newPinFocus.dispose();
    _confirmPinFocus.dispose();
    super.dispose();
  }

  Future<void> _requestResend() async {
    try {
      await AuthenticationService().requestTransactionPinReset();
      _startTimer();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP Sent Successfully'),
          backgroundColor: Color(0xFF00C853),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _verifyOtp(String otp) async {
    if (_isLoading || otp.length != 6) return;

    setState(() => _isLoading = true);
    try {
      final data = await AuthenticationService().verifyTransactionPinResetCode(otp);
      final token = data['resetToken'] as String?;
      if (token == null || token.isEmpty) {
        throw const FormatException('Reset token was not returned by the server.');
      }
      setState(() => _resetToken = token);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _newPinFocus.requestFocus();
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Identity verified. Please set your new PIN.'),
          backgroundColor: Color(0xFF00C853),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _completeReset() async {
    if (_isSubmitting || _resetToken == null) return;

    final pin = _newPinCtrl.text.trim();
    final confirmPin = _confirmPinCtrl.text.trim();
    if (pin.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid 4-digit PIN.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (pin != confirmPin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PIN confirmation does not match.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await AuthenticationService().completeTransactionPinReset(
        resetToken: _resetToken!,
        pin: pin,
        confirmPin: confirmPin,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaction PIN has been reset successfully.'),
          backgroundColor: Color(0xFF00C853),
        ),
      );
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
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
          icon: Icon(
            Boxicons.bx_chevron_left,
            color: isDark ? Colors.white : Colors.black,
            size: 28,
          ),
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
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : Colors.black54,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(
                    text:
                        "Fill in the box below with the OTP.\nPlease check the OTP sent to ",
                  ),
                  TextSpan(
                    text: widget.userEmail,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            OtpInput(controller: _otpCtrl, onCompleted: _verifyOtp),
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
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                        TextButton(
                          onPressed: _requestResend,
                          child: const Text(
                            "Try Again / Resend OTP",
                            style: TextStyle(
                              color: Color(0xFF00C853),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            if (_resetToken != null) ...[
              const SizedBox(height: 32),
              Text(
                "Set a new PIN",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              TransactionPinInput(
                controller: _newPinCtrl,
                focusNode: _newPinFocus,
              ),
              const SizedBox(height: 16),
              TransactionPinInput(
                controller: _confirmPinCtrl,
                focusNode: _confirmPinFocus,
              ),
            ],
            const Spacer(),
            PrimaryGradientButton(
              text: _resetToken == null ? 'Verify' : 'Reset PIN',
              isLoading: _isLoading || _isSubmitting,
              onPressed: _resetToken == null
                  ? (_otpCtrl.text.length == 6 ? () => _verifyOtp(_otpCtrl.text) : null)
                  : _completeReset,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
