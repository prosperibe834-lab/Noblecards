import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_shadow.dart';
import '../create_new_password/create_new_password_screen.dart';
import 'models/otp_timer_model.dart';
import 'utils/otp_validator.dart';
import 'widgets/otp_background.dart';
import 'widgets/otp_header.dart';
import 'widgets/otp_info_card.dart';
import 'widgets/otp_input_field.dart';
import 'widgets/otp_resend_section.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;

  const VerifyOtpScreen({
    super.key,
    required this.email,
  });

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  String _currentOtp = '';
  bool _isLoading = false;
  late OtpTimerModel _timerModel;

  @override
  void initState() {
    super.initState();
    _timerModel = OtpTimerModel()..startTimer();
    _timerModel.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timerModel.dispose();
    super.dispose();
  }

  void onBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void onBackToLogin() {
    // TODO: Connect to your specific routing system
  }

  Future<void> onResendOtp() async {
    // Prevent interaction if already loading
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      // TODO: Connect Backend Resend Logic here
      await Future.delayed(const Duration(seconds: 1)); // Simulate network

      _timerModel.resetTimer();
      _currentOtp = '';
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP sent successfully!', style: TextStyle(color: Colors.white)),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to resend OTP', style: TextStyle(color: Colors.white)),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> onVerifyOtp() async {
    if (!OtpValidator.isFullyValid(_currentOtp)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 6-digit OTP', style: TextStyle(color: Colors.white)),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_timerModel.isExpired) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP expired. Please request a new one.', style: TextStyle(color: Colors.white)),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    FocusScope.of(context).unfocus();

    try {
      // TODO: Connect Firebase / Backend OTP Verification here
      await Future.delayed(const Duration(seconds: 2)); // Simulate network

      if (mounted) {
        // Success Navigation to Create New Password Screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification successful!', style: TextStyle(color: Colors.white)),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Navigate to Create New Password screen
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateNewPasswordScreen(),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid OTP. Please try again.', style: TextStyle(color: Colors.white)),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: OtpBackground(
        child: Column(
          children: [
            // Top Navigation Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(
                    Boxicons.bx_arrow_back,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                  onPressed: _isLoading ? null : onBack,
                  style: IconButton.styleFrom(
                    backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
                    shape: const CircleBorder(),
                  ),
                ),
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    OtpHeader(email: widget.email),
                    const SizedBox(height: 40),

                    // OTP Interactive Inputs
                    OtpInputField(
                      onChanged: (val) {
                        setState(() => _currentOtp = val);
                      },
                      onCompleted: () {
                        // Auto-verify if fully typed
                        if (OtpValidator.isFullyValid(_currentOtp) && !_isLoading) {
                          onVerifyOtp();
                        }
                      },
                    ),
                    const SizedBox(height: 24),

                    // Timer & Resend
                    OtpResendSection(
                      formattedTime: _timerModel.formattedTime,
                      isExpired: _timerModel.isExpired,
                      onResend: onResendOtp,
                    ),
                    const SizedBox(height: 32),

                    // Information Card
                    const OtpInfoCard(),
                    const SizedBox(height: 40),

                    // Verify Button
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [AppColors.successLight, AppColors.primary],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        boxShadow: isDark ? AppShadow.dark : AppShadow.light,
                      ),
                      child: ElevatedButton(
                        onPressed: (_isLoading || !OtpValidator.isFullyValid(_currentOtp))
                            ? null
                            : onVerifyOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          disabledBackgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Verify & Continue',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: OtpValidator.isFullyValid(_currentOtp) 
                                          ? Colors.white 
                                          : Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Boxicons.bx_right_arrow_alt,
                                    color: OtpValidator.isFullyValid(_currentOtp) 
                                        ? Colors.white 
                                        : Colors.white70,
                                    size: 24,
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Footer Divider
                    Row(
                      children: [
                        Expanded(child: Divider(color: Theme.of(context).dividerColor)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text('or', style: Theme.of(context).textTheme.bodyMedium),
                        ),
                        Expanded(child: Divider(color: Theme.of(context).dividerColor)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Back to Sign In
                    Center(
                      child: TextButton.icon(
                        onPressed: _isLoading ? null : onBackToLogin,
                        icon: const Icon(Boxicons.bx_arrow_back, color: AppColors.primary, size: 18),
                        label: Text(
                          'Back to Sign In',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

