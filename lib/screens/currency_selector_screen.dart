library noble_cards.screens.currency_selector_screen;

import 'package:flutter/material.dart';
import 'deposit/select_deposit_currency_screen.dart' as dep;

export 'deposit/select_deposit_currency_screen.dart' hide SelectDepositCurrencyScreen;

class CurrencySelectorScreen extends StatelessWidget {
  const CurrencySelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const dep.SelectDepositCurrencyScreen();
  }
}
