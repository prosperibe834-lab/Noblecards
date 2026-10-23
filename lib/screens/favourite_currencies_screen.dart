library noble_cards.screens.favourite_currencies_screen;

import 'package:flutter/material.dart';
import 'deposit/favourite_currencies_screen.dart' as dep;

export 'deposit/favourite_currencies_screen.dart' hide FavouriteCurrenciesScreen;

class FavouriteCurrenciesScreen extends StatelessWidget {
  const FavouriteCurrenciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const dep.FavouriteCurrenciesScreen();
  }
}
