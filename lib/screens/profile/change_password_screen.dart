import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'widgets/password_input_field.dart';
import 'widgets/password_strength_checker.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleUpdatePassword() async {
    // 1. Unfocus keyboard
    FocusScope.of(context).unfocus();

    // 2. Validate all fields
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 3. Ensure new password meets all criteria (Strength check)
    final pwd = _newPasswordController.text;
    final hasMinLength = pwd.length >= 8;
    final hasNumber = pwd.contains(RegExp(r'[0-9]'));
    final hasUppercase = pwd.contains(RegExp(r'[A-Z]'));
    final hasSpecial = pwd.contains(RegExp(r'[!@#\$&*~%,.?;:\-_+]'));

    if (!hasMinLength || !hasNumber || !hasUppercase || !hasSpecial) {
      _showErrorSnackBar('Please ensure your new password meets all strength requirements.');
      return;
    }

    // 4. Set loading state and simulate network request
    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2)); // Simulating API Call
      
      // Reset loading state
      if (mounted) setState(() => _isLoading = false);
      
      // Show Success Modal
      if (mounted) _showSuccessModal();

    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      _showErrorSnackBar('An error occurred. Please try again.');
    }
  }

  void _showErrorSnackBar(String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Boxicons.bx_error_circle, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(message, style: const TextStyle(color: Colors.white))),
          ],
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSuccessModal() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF141C28) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Boxicons.bx_check_shield,
                    color: Color(0xFF10B981),
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Password Updated\nSuccessfully',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Your password has been changed successfully. You'll remain signed in on this device.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      Navigator.of(context).pop(); // Go back to previous screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Theme Colors
    final bgColor = isDark ? const Color(0xFF0B0E14) : const Color(0xFFF8FAF9);
    final primaryTextColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    const primaryGreen = Color(0xFF10B981);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Boxicons.bx_chevron_left, color: primaryTextColor, size: 28),
          onPressed: () => Navigator.maybePop(context),
        ),
        centerTitle: true,
        title: Text(
          'Change Password',
          style: TextStyle(
            color: primaryTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TOP INTRO GRAPHIC SECTION
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Text(
                        'Update your password to keep your account secure.',
                        style: TextStyle(
                          color: primaryTextColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        height: 90,
                        alignment: Alignment.centerRight,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: primaryGreen,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryGreen.withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  )
                                ],
                              ),
                              child: const Icon(Boxicons.bxs_lock, color: Colors.white, size: 30),
                            ),
                            Positioned(
                              top: 5,
                              right: 0,
                              child: Icon(Boxicons.bxs_star, color: primaryGreen.withOpacity(0.8), size: 12),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 0,
                              child: Icon(Boxicons.bx_star, color: primaryGreen.withOpacity(0.5), size: 10),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // TOP SECURITY BANNER
                _buildSecurityBanner(
                  isDark: isDark,
                  icon: Boxicons.bx_shield_quarter,
                  text: "For your security, choose a strong password that you don't use on other websites.",
                ),
                const SizedBox(height: 24),

                // CURRENT PASSWORD FIELD
                PasswordInputField(
                  label: 'Current Password',
                  hint: 'Enter your current password',
                  controller: _currentPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Current password is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // NEW PASSWORD FIELD
                PasswordInputField(
                  label: 'New Password',
                  hint: 'Enter your new password',
                  controller: _newPasswordController,
                  onChanged: (val) => setState(() {}), // Trigger rebuild for strength indicator
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'New password is required';
                    }
                    if (value == _currentPasswordController.text && value.isNotEmpty) {
                      return 'New password cannot be the same as current';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // STRENGTH CHECKER
                PasswordStrengthChecker(
                  password: _newPasswordController.text,
                ),
                const SizedBox(height: 24),

                // CONFIRM PASSWORD FIELD
                PasswordInputField(
                  label: 'Confirm New Password',
                  hint: 'Confirm your new password',
                  controller: _confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your new password';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // BOTTOM SECURITY BANNER
                _buildSecurityBanner(
                  isDark: isDark,
                  icon: Boxicons.bx_check_shield,
                  text: "You'll be logged out of all devices except this one after password change.",
                  trailingIcon: Boxicons.bxs_lock_alt,
                ),
                const SizedBox(height: 32),

                // SUBMIT BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleUpdatePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      disabledBackgroundColor: primaryGreen.withOpacity(0.6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            'Update Password',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 40), // Bottom padding for scroll
              ],
            ),
          ),
        ),
      ),
    );
  }

  // WIDGET: Security Banner
  Widget _buildSecurityBanner({
    required bool isDark,
    required IconData icon,
    required String text,
    IconData? trailingIcon,
  }) {
    final bannerBg = isDark ? const Color(0xFF082218) : const Color(0xFFF0FDF4);
    final border = isDark ? const Color(0xFF0F4732) : const Color(0xFFDCFCE7);
    final contentColor = isDark ? const Color(0xFF34D399) : const Color(0xFF059669);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bannerBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: contentColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: contentColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
          ),
          if (trailingIcon != null) ...[
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: contentColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(trailingIcon, color: contentColor, size: 20),
            ),
          ],
        ],
      ),
    );
  }
}