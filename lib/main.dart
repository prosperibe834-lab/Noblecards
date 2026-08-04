import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/login_screen.dart';
import 'screens/setup_pin_screen.dart';
import 'screens/biometric_setup_screen.dart';
import 'screens/forgot_password_screen.dart';
// import 'package:noble_cards/screens/home_screen.dart';
import 'widgets/main_navigation_screen.dart';
import 'navigation/app_router.dart';

import 'providers/payment_provider.dart';
import 'providers/wallet_provider.dart';
import 'screens/cards/providers/submission_provider.dart';
import 'screens/cards/providers/sell_receipt_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Transparent status bar for edge-to-edge UI
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

 runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
        ChangeNotifierProvider(create: (_) => SubmissionProvider()),
        ChangeNotifierProvider(create: (_) => SellReceiptProvider()),
      ],
      child: const NobleCardsApp(),
    ),
  );
}

class NobleCardsApp extends StatelessWidget {
  const NobleCardsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'NobleCards',
      debugShowCheckedModeBanner: false,

      // Utilizing themes from lib/theme/app_theme.dart
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,

      // Initial screen route
      home: const OnboardingScreen(),

// <--- 2. ADDED THIS: Handles dynamic routes (/favourite-currencies, /exchange-rate)
      onGenerateRoute: AppRouter.generateRoute,

      routes: {
        '/home': (context) => const MainNavigationScreen(),
        '/signup': (context) => const SignupScreen(),

        '/login': (context) => const LoginScreen(),
        '/setup-pin': (context) => const SetupPinScreen(),
        '/biometric-setup': (context) => const BiometricSetupScreen(),

        '/forgot-password': (context) => const ForgotPasswordScreen(),

        '/register': (context) => Scaffold(
          appBar: AppBar(title: const Text('Create Account')),
          body: const Center(child: Text('Registration Flow')),
        ),
      },
    );
  }
}
