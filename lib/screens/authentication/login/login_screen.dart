import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_shadow.dart';
import '../services/authentication_service.dart';
import '../services/biometric_auth_service.dart';
import '../forgotPassword/forgot_password_screen.dart';
import 'widgets/login_background.dart';
import 'widgets/login_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  final BiometricAuthService _biometricService = BiometricAuthService();
  final AuthenticationService _authService = AuthenticationService();

  bool _isLoading = false;
  bool _isBiometricLoading = false;
  BiometricSupportType _biometricType = BiometricSupportType.none;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _checkBiometrics() async {
    final canUse = await _biometricService.canUseBiometrics();
    if (canUse) {
      final type = await _biometricService.getAvailableBiometricType();
      if (mounted) {
        setState(() {
          _biometricType = type;
        });
      }
    }
  }

  void _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      setState(() => _isLoading = true);

      try {
        await _authService.signInWithEmail(
          email: _emailController.text,
          password: _passwordController.text,
        );

        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (route) => false,
        );
      } catch (error) {
        final message = error.toString().replaceFirst('Exception: ', '');
        _showErrorSnackBar(message);
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  void _handleBiometricLogin() async {
    setState(() => _isBiometricLoading = true);
    
    final authenticated = await _biometricService.authenticate();
    
    if (authenticated) {
      // TODO: Handle successful biometric session restore
      // Either trigger Firebase custom token login or restore secure session
      
      // Simulate verification delay
      await Future.delayed(const Duration(seconds: 1));
      
      // TODO: Navigate to Main Layout/Dashboard
      // Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      _showErrorSnackBar('Biometric authentication failed or was canceled.');
    }
    
    if (mounted) setState(() => _isBiometricLoading = false);
  }

  void _handleForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
    );
  }

  void _handleSignUp() {
    if (!mounted) return;
    Navigator.pushNamed(context, '/signup');
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: LoginBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  Center(
                    child: Image.asset(
                      isDark 
                          ? 'lib/assets/logos/MainDarkLogo.png.png' 
                          : 'lib/assets/logos/MainLightLogo.png.png',
                      height: 64,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Boxicons.bx_wallet_alt, 
                        size: 64, 
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Header Texts
                  Text(
                    'Welcome back',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Login to your account and continue\nwhere you left off',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 40),

                  // Inputs
                  LoginTextField(
                    controller: _emailController,
                    focusNode: _emailFocus,
                    hintText: 'Email address',
                    prefixIcon: Boxicons.bx_envelope,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter your email';
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  LoginTextField(
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    hintText: 'Password',
                    prefixIcon: Boxicons.bx_lock_alt,
                    isPassword: true,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter your password';
                      if (value.length < 6) return 'Password must be at least 6 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Forgot Password Link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _isLoading ? null : _handleForgotPassword,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.secondary,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Forgot password?',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Sign In Button
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      boxShadow: isDark ? AppShadow.dark : AppShadow.light,
                    ),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
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
                          : const Text(
                              'Log In',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),

                  // Biometric Section (Only visible if hardware supports it)
                  if (_biometricType != BiometricSupportType.none) ...[
                    const SizedBox(height: 32),
                    
                    // Divider
                    Row(
                      children: [
                        Expanded(child: Divider(color: Theme.of(context).dividerColor)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'or continue with',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Expanded(child: Divider(color: Theme.of(context).dividerColor)),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Biometric Button
                    InkWell(
                      onTap: _isBiometricLoading ? null : _handleBiometricLogin,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Theme.of(context).dividerColor),
                          color: isDark ? AppColors.darkCard : AppColors.lightCard,
                        ),
                        child: _isBiometricLoading
                            ? const Center(
                                child: SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                    strokeWidth: 2.5,
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _biometricType == BiometricSupportType.face
                                        ? Boxicons.bx_face
                                        : Boxicons.bx_fingerprint,
                                    color: AppColors.primary,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _biometricType == BiometricSupportType.face
                                            ? 'Login with Face ID'
                                            : 'Login with Fingerprint',
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'Quick & secure',
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 40),

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: _isLoading ? null : _handleSignUp,
                        child: Text(
                          'Sign up',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w600,
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
}


