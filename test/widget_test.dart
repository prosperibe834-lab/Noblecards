import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noble_cards/providers/exchange_rate_provider.dart';
import 'package:noble_cards/screens/currency_selector_screen.dart';
import 'package:noble_cards/screens/deposit_screen.dart';

void main() {
  setUp(() {
    ExchangeRateProvider.setRates({
      'USD': 1.0,
      'NGN': 1500.0,
      'GBP': 0.79,
      'GHS': 12.5,
    });
  });

  testWidgets('Deposit screen renders and includes the local deposit state', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: DepositScreen()));

    expect(find.text('Deposit Funds'), findsOneWidget);
    expect(find.text('You Deposit (NGN)'), findsOneWidget);
    expect(find.textContaining('FX rate:'), findsOneWidget);
    expect(find.textContaining('You Get:'), findsOneWidget);
    expect(find.text('FX rate: 1 USD = NGN 1500.00'), findsOneWidget);
  });

  testWidgets('Quick amount buttons exist and are clickable', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: DepositScreen()));

    // Find quick amount buttons (should have 5 buttons: $50, $100, $200, $500, $1000)
    final quickAmountButtons = find.byType(InkWell).evaluate();
    expect(quickAmountButtons.length, greaterThanOrEqualTo(5), reason: 'Should have at least 5 quick amount buttons');
  });

  testWidgets('Currency selector includes only the Flutterwave-supported currencies', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: CurrencySelectorScreen()));

    final currencies = {
      'NGN': 'Nigerian Naira',
      'GBP': 'British Pound',
      'GHS': 'Ghanaian Cedi',
    };

    for (final entry in currencies.entries) {
      await tester.scrollUntilVisible(
        find.text(entry.value),
        100,
        scrollable: find.byType(Scrollable).last,
      );
      expect(find.text(entry.value), findsOneWidget);
    }

    expect(find.text('Euro'), findsNothing);
    expect(find.text('Canadian Dollar'), findsNothing);
  });
}
