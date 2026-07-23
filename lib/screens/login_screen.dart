import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'package:local_auth/local_auth.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadow.dart';
import '../theme/app_animation.dart';
import 'setup_pin_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final LocalAuthentication _auth = LocalAuthentication();

  int _selectedTab = 0; // 0 = Email, 1 = Phone Number
  bool _obscurePassword = true;
  bool _rememberMe = false;

  // Simulated state flags for testing
  bool hasPin = false;
  bool faceEnabled = false;

  bool _showPasswordFallback = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: AppAnimation.slow,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();

    // Trigger biometrics automatically if returning user
    if (hasPin && faceEnabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _triggerReturningBiometricAuth();
      });
    }
  }

  Future<void> _triggerReturningBiometricAuth() async {
    try {
      final bool canCheck = await _auth.canCheckBiometrics;
      final bool isSupported = await _auth.isDeviceSupported();

      if (canCheck && isSupported) {
        final bool didAuthenticate = await _auth.authenticate(
          localizedReason: 'Authenticate to access NobleCards',
          biometricOnly: true,
          persistAcrossBackgrounding: true,
        );

        if (didAuthenticate && mounted) {
          Navigator.pushReplacementNamed(context, '/home');
          return;
        }
      }
    } catch (_) {}

    if (mounted) {
      setState(() {
        _showPasswordFallback = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Biometric authentication failed. Please enter your password.',
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _handleSignIn() {
    if (!hasPin) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SetupPinScreen()),
      );
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderBg = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final inputBg = isDark ? AppColors.darkInput : AppColors.lightInput;
    final subTextColor = isDark
        ? AppColors.darkSubText
        : AppColors.lightSubText;

    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.md),

                  // App Logo Header
                 // Centered Dynamic App Logo (Light / Dark Mode)
                  Center(
                    child: Image.asset(
                      isDark
                          ? 'lib/assets/logos/DarkModeLogo.png'
                          : 'lib/assets/logos/LightModeLogo.png',
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  Row(
                    children: [
                      Text('Welcome Back', style: textTheme.headlineLarge),
                      const SizedBox(width: AppSpacing.xs),
                      const Icon(
                        Icons.waving_hand,
                        color: AppColors.primary,
                        size: 32,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Access your multi-currency virtual cards and trade securely.',
                    style: textTheme.bodyMedium,
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Form Container Card
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
                        // Email vs Phone Selector Tab
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

                        // Input Field
                        Text(
                          _selectedTab == 0 ? 'Email Address' : 'Phone Number',
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        TextFormField(
                          controller: _emailPhoneController,
                          keyboardType: _selectedTab == 0
                              ? TextInputType.emailAddress
                              : TextInputType.phone,
                          style: textTheme.bodyLarge,
                          decoration: InputDecoration(
                            hintText: _selectedTab == 0
                                ? 'name@example.com'
                                : '+234 800 000 0000',
                            prefixIcon: Icon(
                              _selectedTab == 0
                                  ? Boxicons.bx_envelope
                                  : Boxicons.bx_phone,
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
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: AppSpacing.md),

                        // Password Field
                        Text(
                          'Password',
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: textTheme.bodyLarge,
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            prefixIcon: Icon(
                              Boxicons.bx_lock_alt,
                              color: subTextColor,
                              size: 20,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Boxicons.bx_hide
                                    : Boxicons.bx_show,
                                color: subTextColor,
                                size: 20,
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
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
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: AppSpacing.md),

                        // Remember Me + Forgot Password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: Checkbox(
                                    value: _rememberMe,
                                    activeColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppRadius.xs / 2,
                                      ),
                                    ),
                                    onChanged: (val) => setState(
                                      () => _rememberMe = val ?? false,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.xs),
                                Text(
                                  'Remember me',
                                  style: textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () => Navigator.pushNamed(
                                context,
                                '/forgot-password',
                              ),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Fallback option when returning-user biometric fails
                  if (_showPasswordFallback) ...[
                    Center(
                      child: TextButton.icon(
                        onPressed: () =>
                            setState(() => _showPasswordFallback = false),
                        icon: const Icon(
                          Boxicons.bx_key,
                          color: AppColors.primary,
                        ),
                        label: const Text(
                          'Use Password Instead',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],

                  // Sign In Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _handleSignIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Signup Route Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/signup'),
                        child: const Text(
                          'Create Account',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
          duration: AppAnimation.fast,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? AppColors.darkCard : AppColors.lightCard)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? AppColors.darkSubText : AppColors.lightSubText),
            ),
          ),
        ),
      ),
    );
  }
}

// REUSABLE TRANSACTION PIN DIALOG
class TransactionPinDialog extends StatefulWidget {
  final Function(String pin) onPinSubmit;
  final VoidCallback onFaceIdPressed;
  final VoidCallback onFingerprintPressed;

  const TransactionPinDialog({
    super.key,
    required this.onPinSubmit,
    required this.onFaceIdPressed,
    required this.onFingerprintPressed,
  });

  @override
  State<TransactionPinDialog> createState() => _TransactionPinDialogState();
}

class _TransactionPinDialogState extends State<TransactionPinDialog> {
  String _pin = '';

  void _onKeyPress(String val) {
    if (_pin.length < 4) {
      setState(() => _pin += val);
      if (_pin.length == 4) {
        widget.onPinSubmit(_pin);
      }
    }
  }

  void _onDelete() {
    if (_pin.isNotEmpty) {
      setState(() => _pin = _pin.substring(0, _pin.length - 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Enter Transaction PIN', style: textTheme.titleLarge),
              IconButton(
                icon: const Icon(Boxicons.bx_x),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Circle indicators: ● ● ○ ○
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              final isFilled = index < _pin.length;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isFilled ? AppColors.primary : Colors.transparent,
                  border: Border.all(
                    color: isFilled
                        ? AppColors.primary
                        : AppColors.lightSubText,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    isFilled ? '●' : '○',
                    style: TextStyle(
                      fontSize: 8,
                      color: isFilled ? Colors.white : AppColors.lightSubText,
                    ),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: AppSpacing.xl),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: widget.onFaceIdPressed,
                icon: const Icon(
                  Boxicons.bx_scan,
                  size: 20,
                  color: AppColors.primary,
                ),
                label: const Text(
                  'Use Face ID',
                  style: TextStyle(color: AppColors.primary, fontSize: 13),
                ),
              ),
              TextButton.icon(
                onPressed: widget.onFingerprintPressed,
                icon: const Icon(
                  Boxicons.bx_fingerprint,
                  size: 20,
                  color: AppColors.primary,
                ),
                label: const Text(
                  'Use Fingerprint',
                  style: TextStyle(color: AppColors.primary, fontSize: 13),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Numeric Keypad Grid
          Column(
            children: [
              Row(children: [_key('1'), _key('2'), _key('3')]),
              const SizedBox(height: AppSpacing.sm),
              Row(children: [_key('4'), _key('5'), _key('6')]),
              const SizedBox(height: AppSpacing.sm),
              Row(children: [_key('7'), _key('8'), _key('9')]),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  const Expanded(child: SizedBox()),
                  _key('0'),
                  Expanded(
                    child: IconButton(
                      icon: const Icon(Boxicons.bx_left_arrow_alt, size: 26),
                      onPressed: _onDelete,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _key(String val) {
    return Expanded(
      child: InkWell(
        onTap: () => _onKeyPress(val),
        child: Container(
          height: 48,
          alignment: Alignment.center,
          child: Text(
            val,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}



