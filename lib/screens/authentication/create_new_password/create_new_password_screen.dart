import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_shadow.dart';
import 'models/password_strength.dart';
import 'utils/password_validator.dart';
import 'widgets/password_background.dart';
import 'widgets/password_header.dart';
import 'widgets/password_input_field.dart';
import 'widgets/password_strength_indicator.dart';
import 'widgets/password_tips_card.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  State<CreateNewPasswordScreen> createState() => _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isNewPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;
  bool _isLoading = false;

  PasswordValidationState _validationState = const PasswordValidationState();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void onBack() {
    // TODO: Navigate back
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void onBackToSignIn() {
    // TODO: Navigate to Login screen
  }

  void toggleNewPasswordVisibility() {
    setState(() {
      _isNewPasswordObscured = !_isNewPasswordObscured;
    });
  }

  void toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
    });
  }

  void _onPasswordChanged(String value) {
    setState(() {
      _validationState = PasswordValidator.evaluate(value);
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> onUpdatePassword() async {
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (newPassword.isEmpty) {
      _showError('Please enter a new password.');
      return;
    }
    
    if (!_validationState.isFullyValid && _validationState.strengthLevel != PasswordStrengthLevel.strong && _validationState.strengthLevel != PasswordStrengthLevel.veryStrong) {
      _showError('Please ensure your password meets all requirements.');
      return;
    }

    if (newPassword != confirmPassword) {
      _showError('Passwords do not match. Please try again.');
      return;
    }

    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);

    try {
      // TODO: Connect Firebase / Backend logic here
      // await authService.updatePassword(newPassword);
      
      // Simulate network request
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        // TODO: Navigate to Success Screen or Login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password updated successfully!', style: TextStyle(color: Colors.white)),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) _showError('Failed to update password. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: PasswordBackground(
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
                    const PasswordHeader(),
                    const SizedBox(height: 40),

                    // Inputs Area
                    PasswordInputField(
                      label: 'New Password',
                      hintText: 'At least 8 characters with letters, numbers & symbols',
                      controller: _newPasswordController,
                      isObscured: _isNewPasswordObscured,
                      onToggleVisibility: toggleNewPasswordVisibility,
                      onChanged: _onPasswordChanged,
                    ),
                    const SizedBox(height: 16),
                    
                    PasswordInputField(
                      label: 'Confirm New Password',
                      hintText: 'Re-enter your new password',
                      controller: _confirmPasswordController,
                      isObscured: _isConfirmPasswordObscured,
                      onToggleVisibility: toggleConfirmPasswordVisibility,
                      onChanged: (_) {}, // Only validation checks the match
                    ),
                    const SizedBox(height: 32),

                    PasswordStrengthIndicator(strength: _validationState.strengthLevel),
                    const SizedBox(height: 24),

                    PasswordTipsCard(validationState: _validationState),
                    const SizedBox(height: 40),

                    // Update Button
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
                        onPressed: _isLoading ? null : onUpdatePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
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
                                  Text(
                                    'Update Password',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Boxicons.bx_right_arrow_alt, color: Colors.white, size: 24),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Footer Divider & Navigation
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

                    Center(
                      child: TextButton.icon(
                        onPressed: _isLoading ? null : onBackToSignIn,
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