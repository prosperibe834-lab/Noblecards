import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/signup_screen.dart';

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
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
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

      routes: {
  '/signup': (context) => const SignupScreen(),
  // '/login': (context) => const LoginScreen(),
},
    );
  }
}