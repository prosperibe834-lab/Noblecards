import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_shadow.dart';
import '../services/authentication_service.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/reset_password_background.dart';
import 'widgets/reset_password_illustration.dart';
import 'widgets/reset_password_shimmer.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final AuthenticationService _authService = AuthenticationService();

  bool _isInitialLoading = false; // Toggle to true if fetching preconditions
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onBackToLogin() {
    // TODO: Navigate back to the Login Screen
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      // Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _onEmailChanged(String value) {
    // Optional: Implement real-time validation if needed
  }

  Future<void> _doPasswordReset() async {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus(); // Dismiss keyboard
      HapticFeedback.lightImpact();

      setState(() => _isLoading = true);

      try {
        await _authService.resetPasswordForEmail(_emailController.text.trim());
        
        if (mounted) {
          HapticFeedback.mediumImpact();
          // TODO: Navigate to OTP Verification Screen
          // Navigator.push(context, MaterialPageRoute(builder: (_) => const OtpVerificationScreen()));
        }
      } catch (e) {
        if (mounted) {
          _showErrorSnackBar(e.toString().replaceAll('Exception: ', ''));
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message, 
          style: const TextStyle(color: Colors.white, fontFamily: 'Inter'),
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'Try Again',
          textColor: Colors.white,
          onPressed: _doPasswordReset,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitialLoading) {
      return const Scaffold(body: ResetPasswordShimmer());
    }

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: ResetPasswordBackground(
        child: Column(
          children: [
            // Top App Bar Area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(
                    Boxicons.bx_arrow_back,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                  onPressed: _isLoading ? null : _onBackToLogin,
                  tooltip: 'Back to Sign In',
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
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      
                      // Logo
                      Center(
                        child: Image.asset(
                          isDark 
                              ? 'lib/assets/logos/MainDarkLogo.png.png' 
                              : 'lib/assets/logos/MainLightLogo.png.png',
                          height: 48,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Boxicons.bx_credit_card_front, 
                            size: 48, 
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Headlines
                      Text(
                        'Reset Password',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Enter your email address and we\'ll send\nyou a 6-digit OTP code to reset your password.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Animation Illustration
                      const ResetPasswordIllustration(),
                      const SizedBox(height: 32),

                      // Input Field
                      AuthTextField(
                        label: 'Email Address',
                        hintText: 'Enter your email address',
                        prefixIcon: Boxicons.bx_envelope,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        onChanged: _onEmailChanged,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email address';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Info Banner
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark 
                              ? AppColors.primary.withOpacity(0.08) 
                              : AppColors.successLight.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark 
                                ? AppColors.primary.withOpacity(0.2) 
                                : AppColors.successLight.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Boxicons.bx_check_shield,
                              color: AppColors.primary,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'We\'ll send a secure OTP code to your email address to help you reset your password.',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: isDark ? AppColors.darkText : AppColors.lightText,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Send Button
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.primary], // Fallback if primaryLight missing
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          // Specific gradient from reference image using available theme colors
                          boxShadow: isDark ? AppShadow.dark : AppShadow.light,
                        ),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _doPasswordReset,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            disabledBackgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
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
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Boxicons.bx_paper_plane, color: Colors.white, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Send OTP Code',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Footer Navigation
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Remember your password? ",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          GestureDetector(
                            onTap: _isLoading ? null : _onBackToLogin,
                            child: Text(
                              'Back to Sign In',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}