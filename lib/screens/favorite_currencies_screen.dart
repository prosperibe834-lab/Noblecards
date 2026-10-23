library noble_cards.screens.favorite_currencies_screen;

import 'package:flutter/material.dart';
import 'deposit/favourite_currencies_screen.dart' as dep;

export 'deposit/favourite_currencies_screen.dart' hide FavouriteCurrenciesScreen;

class FavoriteCurrenciesScreen extends StatelessWidget {
  const FavoriteCurrenciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const dep.FavouriteCurrenciesScreen();
  }
}
