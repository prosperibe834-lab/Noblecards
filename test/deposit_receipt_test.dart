import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noble_cards/screens/deposit_receipt_screen.dart';

void main() {
  for (final brightness in [Brightness.light, Brightness.dark]) {
    testWidgets('deposit receipt shows exact deposit data in $brightness mode', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: brightness),
          home: Builder(
            builder: (context) => Scaffold(
              body: Column(
                children: [
                  const Text('Transaction History'),
                  TextButton(
                    onPressed: () => Navigator.of(context).push<void>(
                      MaterialPageRoute(
                        builder: (_) => DepositReceiptScreen(
                          amount: 1500,
                          currency: 'NGN',
                          convertedUsd: 1,
                          depositId: 'deposit-selected',
                          transactionId: 'transaction-selected',
                          transactionReference: 'DPT-SELECTED',
                          status: 'PENDING',
                          fee: 15,
                          paymentMethod: 'CARD',
                          provider: 'FLUTTERWAVE',
                          providerReference: 'provider-reference',
                          providerTransactionId: 'provider-transaction',
                          transactionDate: DateTime(2026, 10, 2, 10),
                        ),
                      ),
                    ),
                    child: const Text('Open receipt'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open receipt'));
      await tester.pumpAndSettle();

      expect(find.text('Deposit Receipt'), findsOneWidget);
      expect(find.text('Pending'), findsWidgets);
      expect(find.text('Card'), findsOneWidget);
      expect(find.text('Flutterwave'), findsOneWidget);
      expect(find.text('deposit-selected'), findsOneWidget);
      expect(find.text('transaction-selected'), findsOneWidget);
      expect(find.text('DPT-SELECTED'), findsOneWidget);
      expect(find.text('provider-reference'), findsOneWidget);
      expect(find.text('provider-transaction'), findsOneWidget);
      expect(find.text('₦1,500.00'), findsNWidgets(2));
      expect(find.text('Share Receipt'), findsOneWidget);
      expect(find.text('Download Receipt'), findsOneWidget);

      await tester.tap(find.byIcon(Boxicons.bx_chevron_left));
      await tester.pumpAndSettle();
      expect(find.text('Transaction History'), findsOneWidget);
    });
  }
}