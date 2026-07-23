import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'package:country_picker/country_picker.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_shadow.dart';
import '../theme/app_animation.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _referralController = TextEditingController();

  // Focus Nodes
  final _fullNameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();
  final _referralFocus = FocusNode();

  // States
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  bool _isLoading = false;
  String _selectedGender = 'Male';

  // Selected Country Data
  Map<String, String> _selectedCountry = {
    'name': 'Nigeria',
    'code': 'NG',
    'dialCode': '+234',
    'flag': '🇳🇬',
  };

  // Password Requirements State
  bool get _hasMinLength => _passwordController.text.length >= 8;
  bool get _hasUppercase => _passwordController.text.contains(RegExp(r'[A-Z]'));
  bool get _hasLowercase => _passwordController.text.contains(RegExp(r'[a-z]'));
  bool get _hasNumber => _passwordController.text.contains(RegExp(r'[0-9]'));
  bool get _hasSpecialChar =>
      _passwordController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  double get _passwordStrength {
    int score = 0;
    if (_hasMinLength) score++;
    if (_hasUppercase) score++;
    if (_hasLowercase) score++;
    if (_hasNumber) score++;
    if (_hasSpecialChar) score++;
    return score / 5.0;
  }

  Color get _strengthColor {
    if (_passwordStrength <= 0.2) return AppColors.error;
    if (_passwordStrength <= 0.6) return AppColors.warning;
    return AppColors.success;
  }

  String get _strengthText {
    if (_passwordController.text.isEmpty) return '';
    if (_passwordStrength <= 0.2) return 'Too Weak';
    if (_passwordStrength <= 0.6) return 'Medium';
    if (_passwordStrength < 1.0) return 'Strong';
    return 'Very Strong';
  }

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() => setState(() {}));
    _confirmPasswordController.addListener(() => setState(() {}));
    _fullNameController.addListener(() => setState(() {}));
    _emailController.addListener(() => setState(() {}));
    _phoneController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _referralController.dispose();
    _fullNameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _referralFocus.dispose();
    super.dispose();
  }

  // Handle Form Submission
  void _handleSignup() async {
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please agree to the Terms of Service & Privacy Policy",
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate() && _passwordStrength >= 0.8) {
      setState(() => _isLoading = true);

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Account created successfully!"),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } else if (_passwordStrength < 0.8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please satisfy all password security requirements."),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  // Searchable Country Picker Modal
  void _showCountryPickerModal(bool isDark) {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      favorite: const ['NG', 'US', 'GB', 'CA'],
      countryListTheme: CountryListThemeData(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        bottomSheetHeight: 520,
        inputDecoration: InputDecoration(
          hintText: 'Search country',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = {
            'name': country.name,
            'code': country.countryCode,
            'dialCode': '+${country.phoneCode}',
            'flag': country.flagEmoji,
          };
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.sm),

                // ==================================================
                // HEADER SECTION
                // ==================================================
                Center(
                  child: Image.asset(
                    isDark
                        ? 'lib/assets/logos/DarkModeLogo.png'
                        : 'lib/assets/logos/LightModeLogo.png',
                    height: 60,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Text(
                      "NobleCards",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                Text(
                  "Create Your Account",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  "Create your NobleCards account and start buying and selling gift cards securely with the best market rates.",
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 14,
                    height: 1.4,
                    color: isDark
                        ? AppColors.darkSubText
                        : AppColors.lightSubText,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // ==================================================
                // 1. FULL NAME
                // ==================================================
                _buildFieldLabel("Full Name", isDark),
                const SizedBox(height: AppSpacing.xs),
                _buildCustomTextField(
                  controller: _fullNameController,
                  focusNode: _fullNameFocus,
                  isDark: isDark,
                  hintText: "Enter your full name",
                  prefixIcon: Boxicons.bx_user,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your full name";
                    }
                    if (value.trim().split(' ').length < 2) {
                      return "Please enter your first and last name";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // ==================================================
                // 2. EMAIL ADDRESS
                // ==================================================
                _buildFieldLabel("Email Address", isDark),
                const SizedBox(height: AppSpacing.xs),
                _buildCustomTextField(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  isDark: isDark,
                  hintText: "Enter your email address",
                  prefixIcon: Boxicons.bx_envelope,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Invalid email address";
                    }
                    final emailRegex = RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    );
                    if (!emailRegex.hasMatch(value.trim())) {
                      return "Invalid email address";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // ==================================================
                // 3. COUNTRY SELECTOR
                // ==================================================
                _buildFieldLabel("Country", isDark),
                const SizedBox(height: AppSpacing.xs),
                GestureDetector(
                  onTap: () => _showCountryPickerModal(isDark),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkInput
                          : AppColors.lightInput,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          _selectedCountry['flag']!,
                          style: const TextStyle(fontSize: 22),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            _selectedCountry['name']!,
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontSize: 15,
                              color: isDark
                                  ? AppColors.darkText
                                  : AppColors.lightText,
                            ),
                          ),
                        ),
                        Icon(
                          Boxicons.bx_chevron_down,
                          color: isDark
                              ? AppColors.darkSubText
                              : AppColors.lightSubText,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // ==================================================
                // 4. PHONE NUMBER
                // ==================================================
                _buildFieldLabel("Phone Number", isDark),
                const SizedBox(height: AppSpacing.xs),
                TextFormField(
                  controller: _phoneController,
                  focusNode: _phoneFocus,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 15,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                  decoration: InputDecoration(
                    hintText: "8123456789",
                    hintStyle: TextStyle(
                      color: isDark
                          ? AppColors.darkSubText.withOpacity(0.5)
                          : AppColors.lightSubText.withOpacity(0.5),
                    ),
                    filled: true,
                    fillColor: isDark
                        ? AppColors.darkInput
                        : AppColors.lightInput,
                    prefixIcon: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                      ),
                      margin: const EdgeInsets.only(right: AppSpacing.sm),
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _selectedCountry['flag']!,
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _selectedCountry['dialCode']!,
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.darkText
                                  : AppColors.lightText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: BorderSide(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: BorderSide(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: const BorderSide(color: AppColors.error),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().length < 7) {
                      return "Phone number is invalid.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // ==================================================
                // 5. GENDER
                // ==================================================
                _buildFieldLabel("Gender", isDark),
                const SizedBox(height: AppSpacing.xs),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  dropdownColor: isDark
                      ? AppColors.darkCard
                      : AppColors.lightCard,
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 15,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Boxicons.bx_user_circle,
                      color: isDark
                          ? AppColors.darkSubText
                          : AppColors.lightSubText,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: isDark
                        ? AppColors.darkInput
                        : AppColors.lightInput,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: BorderSide(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: BorderSide(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                  items: ['Male', 'Female', 'Prefer not to say']
                      .map(
                        (gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedGender = val);
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // ==================================================
                // 6. PASSWORD
                // ==================================================
                _buildFieldLabel("Password", isDark),
                const SizedBox(height: AppSpacing.xs),
                _buildCustomTextField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  isDark: isDark,
                  hintText: "Enter password",
                  prefixIcon: Boxicons.bx_lock_alt,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Boxicons.bx_hide : Boxicons.bx_show,
                      color: isDark
                          ? AppColors.darkSubText
                          : AppColors.lightSubText,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),

                // Password Strength Indicator Bar
                if (_passwordController.text.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: AnimatedContainer(
                          duration: AppAnimation.fast,
                          height: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppRadius.full),
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder,
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: _passwordStrength,
                            child: AnimatedContainer(
                              duration: AppAnimation.fast,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.full,
                                ),
                                color: _strengthColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        _strengthText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _strengthColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Requirements Checklist
                  _buildRequirementItem(
                    "Minimum 8 characters",
                    _hasMinLength,
                    isDark,
                  ),
                  _buildRequirementItem(
                    "One uppercase letter",
                    _hasUppercase,
                    isDark,
                  ),
                  _buildRequirementItem(
                    "One lowercase letter",
                    _hasLowercase,
                    isDark,
                  ),
                  _buildRequirementItem("One number", _hasNumber, isDark),
                  _buildRequirementItem(
                    "One special character",
                    _hasSpecialChar,
                    isDark,
                  ),
                ],
                const SizedBox(height: AppSpacing.md),

                // ==================================================
                // 7. CONFIRM PASSWORD
                // ==================================================
                _buildFieldLabel("Confirm Password", isDark),
                const SizedBox(height: AppSpacing.xs),
                _buildCustomTextField(
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocus,
                  isDark: isDark,
                  hintText: "Re-enter password",
                  prefixIcon: Boxicons.bx_lock_alt,
                  obscureText: _obscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Boxicons.bx_hide
                          : Boxicons.bx_show,
                      color: isDark
                          ? AppColors.darkSubText
                          : AppColors.lightSubText,
                    ),
                    onPressed: () {
                      setState(
                        () =>
                            _obscureConfirmPassword = !_obscureConfirmPassword,
                      );
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please confirm your password.";
                    }
                    if (value != _passwordController.text) {
                      return "Passwords do not match.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // ==================================================
                // 8. REFERRAL CODE
                // ==================================================
                _buildFieldLabel("Referral Code (Optional)", isDark),
                const SizedBox(height: AppSpacing.xs),
                _buildCustomTextField(
                  controller: _referralController,
                  focusNode: _referralFocus,
                  isDark: isDark,
                  hintText: "Enter referral code (Optional)",
                  prefixIcon: Boxicons.bx_gift,
                ),
                const SizedBox(height: AppSpacing.lg),

                // ==================================================
                // TERMS & CONDITIONS CHECKBOX
                // ==================================================
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _agreeToTerms,
                        activeColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.xs),
                        ),
                        onChanged: (val) {
                          setState(() => _agreeToTerms = val ?? false);
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Wrap(
                        children: [
                          Text(
                            "I agree to the ",
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontSize: 13,
                              color: isDark
                                  ? AppColors.darkSubText
                                  : AppColors.lightSubText,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Open Terms
                            },
                            child: const Text(
                              "Terms of Service",
                              style: TextStyle(
                                fontFamily: "Inter",
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          Text(
                            " and ",
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontSize: 13,
                              color: isDark
                                  ? AppColors.darkSubText
                                  : AppColors.lightSubText,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Open Privacy Policy
                            },
                            child: const Text(
                              "Privacy Policy",
                              style: TextStyle(
                                fontFamily: "Inter",
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),

                // ==================================================
                // PRIMARY BUTTON
                // ==================================================
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSignup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
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
                            "Create Account",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // ==================================================
                // BOTTOM SECTION
                // ==================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 14,
                        color: isDark
                            ? AppColors.darkSubText
                            : AppColors.lightSubText,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to Login Screen
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper: Field Labels
  Widget _buildFieldLabel(String label, bool isDark) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: "Inter",
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.darkText : AppColors.lightText,
      ),
    );
  }

  // Helper: Reusable Text Form Fields
  Widget _buildCustomTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required bool isDark,
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(
        fontFamily: "Inter",
        fontSize: 15,
        color: isDark ? AppColors.darkText : AppColors.lightText,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: isDark
              ? AppColors.darkSubText.withOpacity(0.5)
              : AppColors.lightSubText.withOpacity(0.5),
        ),
        filled: true,
        fillColor: isDark ? AppColors.darkInput : AppColors.lightInput,
        prefixIcon: Icon(
          prefixIcon,
          color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
          size: 20,
        ),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
      validator: validator,
    );
  }

  // Helper: Password Requirement Checklist Item
  Widget _buildRequirementItem(String text, bool isSatisfied, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isSatisfied ? Boxicons.bx_check_circle : Boxicons.bx_circle,
            size: 16,
            color: isSatisfied
                ? AppColors.success
                : (isDark ? AppColors.darkSubText : AppColors.lightSubText),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            text,
            style: TextStyle(
              fontFamily: "Inter",
              fontSize: 12,
              color: isSatisfied
                  ? (isDark ? AppColors.darkText : AppColors.lightText)
                  : (isDark ? AppColors.darkSubText : AppColors.lightSubText),
            ),
          ),
        ],
      ),
    );
  }
}
