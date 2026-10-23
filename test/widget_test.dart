import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:noble_cards/providers/exchange_rate_provider.dart';
import 'package:noble_cards/providers/wallet_provider.dart';
import 'package:noble_cards/theme/theme_provider.dart';
import 'package:noble_cards/screens/deposit/deposit_screen.dart';
import 'package:noble_cards/screens/deposit/select_deposit_currency_screen.dart';

void main() {
  setUp(() {
    ExchangeRateProvider.setRates({
      'USD': 1.0,
      'NGN': 1500.0,
      'GBP': 0.79,
      'GHS': 12.5,
      'CAD': 1.36,
    });
  });

  Widget buildTestApp(Widget child) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
      ],
      child: MaterialApp(home: child),
    );
  }

  testWidgets('Deposit screen renders header and wallet card', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestApp(const DepositScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Deposit Funds'), findsOneWidget);
    expect(find.text('Wallet Balance'), findsOneWidget);
    expect(find.text('Select Currency'), findsOneWidget);
    expect(find.text('Deposit Amount'), findsOneWidget);
    expect(find.text('Quick Amount'), findsOneWidget);
    expect(find.text('Continue to Payment'), findsOneWidget);
  });

  testWidgets('Select deposit currency screen renders supported currencies', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestApp(const SelectDepositCurrencyScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Select Deposit Currency'), findsOneWidget);
    expect(find.text('NGN'), findsWidgets);
    expect(find.text('USD'), findsWidgets);
    expect(find.text('GBP'), findsWidgets);
  });
}
