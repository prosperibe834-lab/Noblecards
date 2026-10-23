library noble_cards.screens.deposit_screen;

import 'package:flutter/material.dart';
import 'deposit/deposit_screen.dart' as dep;

export 'deposit/deposit_screen.dart' hide DepositScreen;

class DepositScreen extends StatelessWidget {
  const DepositScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const dep.DepositScreen();
  }
}
