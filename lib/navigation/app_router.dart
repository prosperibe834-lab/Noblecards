import 'package:flutter/material.dart';
import '../screens/favourite_currencies_screen.dart';
import '../screens/exchange_rate_screen.dart';

/// Defines string constants for all app route names.
abstract class AppRoutes {
  static const String favouriteCurrencies = '/favourite-currencies';
  static const String exchangeRate = '/exchange-rate';
}

/// Route generator handling [RouteSettings] for main app navigation.
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.favouriteCurrencies:
        return MaterialPageRoute(
          builder: (_) => const FavouriteCurrenciesScreen(),
          settings: settings,
        );

      case AppRoutes.exchangeRate:
        return MaterialPageRoute(
          builder: (_) => const ExchangeRateScreen(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: const Text('Route Not Found'),
            ),
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
          settings: settings,
        );
    }
  }
}