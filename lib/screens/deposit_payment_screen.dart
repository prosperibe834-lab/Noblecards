library noble_cards.screens.deposit_payment_screen;

import 'package:flutter/material.dart';
import 'deposit/payment_method_screen.dart' as dep;

export 'deposit/payment_method_screen.dart' hide PaymentMethodScreen;

class DepositPaymentScreen extends StatelessWidget {
  final double amount;
  final String currency;
  final double amountInUsd;

  const DepositPaymentScreen({
    super.key,
    this.amount = 0.0,
    this.currency = 'NGN',
    this.amountInUsd = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return const dep.PaymentMethodScreen();
  }
}
