import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_shadow.dart';
import '../services/authentication_service.dart';
import 'models/otp_timer_model.dart';
import 'utils/otp_validator.dart';
import 'widgets/otp_background.dart';
import 'widgets/otp_header.dart';
import 'widgets/otp_info_card.dart';
import 'widgets/otp_input_field.dart';
import 'widgets/otp_resend_section.dart';

enum OtpVerificationFlow { signup, signIn, passwordRecovery }

class VerifyOtpScreen extends StatefulWidget {
  final String email;
  final Map<String, dynamic> profileData;
  final OtpVerificationFlow flow;

  const VerifyOtpScreen({
    super.key,
    required this.email,
    this.profileData = const {},
    this.flow = OtpVerificationFlow.signup,
  });

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final AuthenticationService _authService = AuthenticationService();
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
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      switch (widget.flow) {
        case OtpVerificationFlow.signup:
          await _authService.resendEmailOtp(email: widget.email);
        case OtpVerificationFlow.signIn:
          await _authService.resendSignInOtp(email: widget.email);
        case OtpVerificationFlow.passwordRecovery:
          await _authService.resendPasswordResetOtp(email: widget.email);
      }

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
    } catch (error) {
      if (mounted) {
        final message = error.toString().replaceFirst('Exception: ', '');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message, style: const TextStyle(color: Colors.white)),
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

    setState(() => _isLoading = true);
    FocusScope.of(context).unfocus();

    try {
      final response = switch (widget.flow) {
        OtpVerificationFlow.signup => await _authService.verifyEmailOtp(
            email: widget.email,
            token: _currentOtp,
          ),
        OtpVerificationFlow.signIn => await _authService.verifySignInOtp(
            email: widget.email,
            token: _currentOtp,
          ),
        OtpVerificationFlow.passwordRecovery =>
          await _authService.verifyPasswordResetOtp(
            email: widget.email,
            token: _currentOtp,
          ),
      };

      if (!mounted) return;

      if (response.session != null) {
        if (widget.flow == OtpVerificationFlow.passwordRecovery) {
          Navigator.pushReplacementNamed(context, '/create-new-password');
          return;
        }

        if (widget.flow == OtpVerificationFlow.signup) {
          final verifiedUser = response.user ?? _authService.currentUser;
          if (verifiedUser == null) {
            throw Exception('OTP verification did not create an authenticated session.');
          }

          await _authService.saveUserProfile(
            userId: verifiedUser.id,
            profileData: widget.profileData,
          );
          if (!mounted) return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification successful!', style: TextStyle(color: Colors.white)),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );

        await Future.delayed(const Duration(milliseconds: 500));
        if (!mounted) return;

        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification failed. Please try again.', style: TextStyle(color: Colors.white)),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (error) {
      final message = error.toString().replaceFirst('Exception: ', '');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message, style: const TextStyle(color: Colors.white)),
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

