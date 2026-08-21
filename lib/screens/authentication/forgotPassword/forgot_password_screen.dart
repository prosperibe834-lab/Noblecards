import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_shadow.dart';
import '../verifyOtp/verify_otp_screen.dart';
import 'models/forgot_password_state.dart';
import 'services/password_reset_service.dart';
import 'widgets/forgot_password_background.dart';
import 'widgets/forgot_password_button.dart';
import 'widgets/forgot_password_email_field.dart';
import 'widgets/forgot_password_header.dart';
import 'widgets/forgot_password_info_card.dart';
import 'widgets/forgot_password_success.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final BasePasswordResetService? passwordResetService;

  const ForgotPasswordScreen({
    super.key,
    this.passwordResetService,
  });

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final TextEditingController _emailController;
  late final BasePasswordResetService _resetService;

  ForgotPasswordState _state = const ForgotPasswordState();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _resetService = widget.passwordResetService ?? PasswordResetService();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool _validateEmail(String email) {
    if (email.trim().isEmpty) {
      setState(() {
        _state = _state.copyWith(errorMessage: 'Email address is required.');
      });
      return false;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email.trim())) {
      setState(() {
        _state = _state.copyWith(errorMessage: 'Please enter a valid email address.');
      });
      return false;
    }

    setState(() {
      _state = _state.copyWith(errorMessage: null);
    });
    return true;
  }

  Future<void> _handleSendResetOtp() async {
    final email = _emailController.text.trim();
    if (!_validateEmail(email)) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _state = _state.copyWith(
        email: email,
        status: ForgotPasswordStatus.loading,
      );
    });

    try {
      await _resetService.sendPasswordResetOtp(email);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyOtpScreen(
            email: email,
            flow: OtpVerificationFlow.passwordRecovery,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _state = _state.copyWith(
          status: ForgotPasswordStatus.failure,
          errorMessage: e.toString().replaceAll('Exception: ', ''),
        );
      });
    }
  }

  void _onBackNavigation() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void _onBackToSignIn() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      // Connect custom routing if navigated directly:
      // Navigator.pushReplacementNamed(context, '/signIn');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: ForgotPasswordBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: _state.status == ForgotPasswordStatus.success
              ? ForgotPasswordSuccessView(
                  email: _state.email,
                  onBackToSignIn: _onBackToSignIn,
                )
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),

                      // Header
                      ForgotPasswordHeader(
                        onBackTap: _onBackNavigation,
                      ),
                      const SizedBox(height: 36),

                      // Email Field
                      ForgotPasswordEmailField(
                        controller: _emailController,
                        errorText: _state.errorMessage,
                        enabled: _state.status != ForgotPasswordStatus.loading,
                        onChanged: (val) {
                          if (_state.errorMessage != null) {
                            _validateEmail(val);
                          }
                        },
                      ),
                      const SizedBox(height: 18),

                      // Security Info Card
                      const ForgotPasswordInfoCard(),
                      const SizedBox(height: 32),

                      // Submit Button
                      ForgotPasswordButton(
                        isLoading: _state.status == ForgotPasswordStatus.loading,
                        onPressed: _state.status == ForgotPasswordStatus.loading
                            ? null
                            : _handleSendResetOtp,
                      ),
                      const SizedBox(height: 36),

                      // Divider "Remember your password?"
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14.0),
                            child: Text(
                              'Remember your password?',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 13,
                                    color: isDark
                                        ? AppColors.darkSubText
                                        : AppColors.lightSubText,
                                  ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Back to Sign In Option Card
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: _onBackToSignIn,
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkCard : AppColors.lightCard,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                              ),
                              boxShadow: isDark ? [] : AppShadow.light,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Boxicons.bx_arrow_back,
                                  color: AppColors.primary,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Back to Sign In',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}


