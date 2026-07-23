import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadow.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  int _currentStep = 1; // 1 = Input Email/Phone, 2 = Enter OTP, 3 = New Password
  int _selectedTab = 0; // 0 = Email, 1 = Phone

  final _identifierController = TextEditingController(); // Email or Phone
  final List<TextEditingController> _otpControllers = List.generate(4, (_) => TextEditingController());
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureNewPass = true;
  bool _obscureConfirmPass = true;

  // STEP 1: Send OTP
  void _handleSendOtp() {
    if (_identifierController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email address or phone number.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    setState(() => _currentStep = 2);
  }

  // STEP 2: Verify OTP
  void _handleVerifyOtp() {
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the complete 4-digit verification code.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    setState(() => _currentStep = 3);
  }

  // STEP 3: Reset Password
  void _handleResetPassword() {
    final newPass = _newPasswordController.text;
    final confirmPass = _confirmPasswordController.text;

    if (newPass.isEmpty || confirmPass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter and confirm your new password.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (newPass != confirmPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Success notification and redirect to login
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password reset successful! Please sign in with your new password.'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _identifierController.dispose();
    for (var c in _otpControllers) {
      c.dispose();
    }
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderBg = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final inputBg = isDark ? AppColors.darkInput : AppColors.lightInput;
    final subTextColor = isDark ? AppColors.darkSubText : AppColors.lightSubText;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Boxicons.bx_arrow_back),
          onPressed: () {
            if (_currentStep > 1) {
              setState(() => _currentStep--);
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Centered Dynamic App Logo
              Center(
                child: Image.asset(
                  isDark
                      ? 'lib/assets/logos/DarkModeLogo.png'
                      : 'lib/assets/logos/LightModeLogo.png',
                  height: 65,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Step 1 Layout: Input Email or Phone
              if (_currentStep == 1) ...[
                Row(
                  children: [
                    Text('Reset Password', style: textTheme.headlineLarge),
                    const SizedBox(width: AppSpacing.xs),
                    const Icon(Boxicons.bx_key, color: AppColors.primary, size: 30),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Select your preferred recovery method and enter your details to receive an OTP.',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.xl),

                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    border: Border.all(color: borderBg),
                    boxShadow: isDark ? AppShadow.dark : AppShadow.light,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tab Switcher
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: inputBg,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Row(
                          children: [
                            _buildTabButton('Email', 0, isDark),
                            _buildTabButton('Phone Number', 1, isDark),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      Text(
                        _selectedTab == 0 ? 'Email Address' : 'Phone Number',
                        style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      TextFormField(
                        controller: _identifierController,
                        keyboardType: _selectedTab == 0 ? TextInputType.emailAddress : TextInputType.phone,
                        style: textTheme.bodyLarge,
                        decoration: InputDecoration(
                          hintText: _selectedTab == 0 ? 'name@example.com' : '+234 800 000 0000',
                          prefixIcon: Icon(
                            _selectedTab == 0 ? Boxicons.bx_envelope : Boxicons.bx_phone,
                            color: subTextColor,
                            size: 20,
                          ),
                          filled: true,
                          fillColor: inputBg,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            borderSide: BorderSide(color: borderBg),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            borderSide: BorderSide(color: borderBg),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _handleSendOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                    ),
                    child: const Text(
                      'Send OTP Code',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],

              // Step 2 Layout: Enter OTP Code
              if (_currentStep == 2) ...[
                Row(
                  children: [
                    Text('Enter OTP', style: textTheme.headlineLarge),
                    const SizedBox(width: AppSpacing.xs),
                    const Icon(Boxicons.bx_shield_quarter, color: AppColors.primary, size: 30),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Enter the 4-digit verification code sent to:\n${_identifierController.text}',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.xl),

                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    border: Border.all(color: borderBg),
                    boxShadow: isDark ? AppShadow.dark : AppShadow.light,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) {
                      return SizedBox(
                        width: 55,
                        child: TextFormField(
                          controller: _otpControllers[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: textTheme.headlineLarge?.copyWith(color: AppColors.primary),
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: inputBg,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              borderSide: BorderSide(color: borderBg),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              borderSide: BorderSide(color: borderBg),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              borderSide: const BorderSide(color: AppColors.primary, width: 2),
                            ),
                          ),
                          onChanged: (val) {
                            if (val.isNotEmpty && index < 3) {
                              FocusScope.of(context).nextFocus();
                            } else if (val.isEmpty && index > 0) {
                              FocusScope.of(context).previousFocus();
                            }
                          },
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _handleVerifyOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                    ),
                    child: const Text(
                      'Verify & Continue',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],

              // Step 3 Layout: Set New Password
              if (_currentStep == 3) ...[
                Row(
                  children: [
                    Text('New Password', style: textTheme.headlineLarge),
                    const SizedBox(width: AppSpacing.xs),
                    const Icon(Boxicons.bx_lock_open_alt, color: AppColors.primary, size: 30),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Set your new secure account password below.',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.xl),

                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    border: Border.all(color: borderBg),
                    boxShadow: isDark ? AppShadow.dark : AppShadow.light,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('New Password', style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: AppSpacing.xs),
                      TextFormField(
                        controller: _newPasswordController,
                        obscureText: _obscureNewPass,
                        style: textTheme.bodyLarge,
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          prefixIcon: Icon(Boxicons.bx_lock_alt, color: subTextColor, size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureNewPass ? Boxicons.bx_hide : Boxicons.bx_show, color: subTextColor, size: 20),
                            onPressed: () => setState(() => _obscureNewPass = !_obscureNewPass),
                          ),
                          filled: true,
                          fillColor: inputBg,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            borderSide: BorderSide(color: borderBg),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            borderSide: BorderSide(color: borderBg),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                          ),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.md),

                      Text('Confirm New Password', style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: AppSpacing.xs),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPass,
                        style: textTheme.bodyLarge,
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          prefixIcon: Icon(Boxicons.bx_lock_alt, color: subTextColor, size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureConfirmPass ? Boxicons.bx_hide : Boxicons.bx_show, color: subTextColor, size: 20),
                            onPressed: () => setState(() => _obscureConfirmPass = !_obscureConfirmPass),
                          ),
                          filled: true,
                          fillColor: inputBg,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            borderSide: BorderSide(color: borderBg),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            borderSide: BorderSide(color: borderBg),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _handleResetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                    ),
                    child: const Text(
                      'Save Password',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, int index, bool isDark) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? (isDark ? AppColors.darkCard : AppColors.lightCard) : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppColors.primary : (isDark ? AppColors.darkSubText : AppColors.lightSubText),
            ),
          ),
        ),
      ),
    );
  }
}