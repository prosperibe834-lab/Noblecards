import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'localization/app_localizations.dart';
import 'providers/language_provider.dart';
import 'screens/profile/language/data/language_data.dart';
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/authentication/login/login_screen.dart';
import 'screens/authentication/forgotPassword/forgot_password_screen.dart';
import 'screens/authentication/create_new_password/create_new_password_screen.dart';
import 'screens/setup_pin_screen.dart';
import 'screens/biometric_setup_screen.dart';
// import 'package:noble_cards/screens/home_screen.dart';
import 'screens/BottomNavigation/main_navigation_screen.dart';
import 'navigation/app_router.dart';

import 'providers/exchange_rate_provider.dart';
import 'providers/payment_provider.dart';
import 'providers/wallet_provider.dart';
import 'screens/cards/providers/submission_provider.dart';
import 'screens/cards/providers/sell_receipt_provider.dart';
import 'screens/cards/providers/buy_receipt_provider.dart';
import 'screens/withraw/withdraw_screen.dart';
import 'screens/deposit/deposit_screen.dart';
import 'screens/authentication/services/authentication_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AuthenticationService.initialize();
  await ExchangeRateProvider.loadRates();

  // Transparent status bar for edge-to-edge UI.
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
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
        ChangeNotifierProvider(create: (_) => SubmissionProvider()),
        ChangeNotifierProvider(create: (_) => SellReceiptProvider()),
        ChangeNotifierProvider(create: (_) => BuyReceiptProvider()),
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
    final languageProvider = Provider.of<LanguageProvider>(context);
    final bool hasActiveSession = AuthenticationService().isAuthenticated;

    return MaterialApp(
      title: 'NobleCards',
      debugShowCheckedModeBanner: false,

      // Internationalization & Localization
      locale: languageProvider.locale,
      supportedLocales: LanguageData.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,

      // Utilizing themes from lib/theme/app_theme.dart
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,

      // Initial screen route based on the locally persisted API session.
      home: hasActiveSession ? const MainNavigationScreen() : const OnboardingScreen(),

      // <--- 2. ADDED THIS: Handles dynamic routes (/favourite-currencies, /exchange-rate)
      onGenerateRoute: AppRouter.generateRoute,

      routes: {
        '/home': (context) => const MainNavigationScreen(),
        '/signup': (context) => const SignupScreen(),

        '/login': (context) => const LoginScreen(),
        '/setup-pin': (context) => const SetupPinScreen(),
        '/biometric-setup': (context) => const BiometricSetupScreen(),

        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/create-new-password': (context) => const CreateNewPasswordScreen(),
        '/withdraw': (context) => const WithdrawScreen(),
        '/deposit': (context) => const DepositScreen(),

        '/register': (context) => Scaffold(
          appBar: AppBar(title: const Text('Create Account')),
          body: const Center(child: Text('Registration Flow')),
        ),
      },
    );
  }
}
