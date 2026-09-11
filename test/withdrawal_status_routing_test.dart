import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noble_cards/screens/withraw/models/withdrawal_transaction_model.dart';
import 'package:noble_cards/screens/withraw/withdraw_processing_screen.dart';
import 'package:noble_cards/screens/withraw/withdraw_success_screen.dart';

WithdrawalTransactionModel makeTransaction(String status) {
  return WithdrawalTransactionModel(
    amount: 50,
    sourceAmount: 50,
    sourceCurrency: 'USD',
    destinationAmount: 49.5,
    destinationCurrency: 'USD',
    currency: 'USD',
    method: 'Bank Transfer',
    destinationCountry: 'United Kingdom',
    countryFlag: '🇬🇧',
    destinationBank: 'Barclays',
    destinationAccountMasked: '1234',
    referenceId: 'REF-123',
    timestamp: DateTime.now(),
    status: status,
  );
}

Future<void> pumpScreen(WidgetTester tester, String status) async {
  await tester.pumpWidget(
    MaterialApp(
      home: WithdrawSuccessScreen(transaction: makeTransaction(status)),
    ),
  );
}

void main() {
  test('successful withdrawal uses the success screen route', () {
    expect(
      routeForWithdrawalStatus('SUCCESSFUL'),
      WithdrawalStatusRoute.success,
    );
    expect(routeForWithdrawalStatus('COMPLETED'), WithdrawalStatusRoute.success);
  });

  test('processing states use the pending route', () {
    for (final status in ['PROCESSING', 'PENDING', 'NEW', 'UNDER_REVIEW']) {
      expect(routeForWithdrawalStatus(status), WithdrawalStatusRoute.pending);
    }
  });

  test('failed withdrawal uses the failure screen route', () {
    expect(routeForWithdrawalStatus('FAILED'), WithdrawalStatusRoute.failed);
  });

  testWidgets('successful status shows the successful title', (tester) async {
    await pumpScreen(tester, 'SUCCESSFUL');

    expect(find.text('Withdrawal Successful!'), findsOneWidget);
    expect(find.textContaining('successfully completed'), findsOneWidget);
  });

  testWidgets('processing status shows pending title and not successful', (tester) async {
    await pumpScreen(tester, 'PROCESSING');

    expect(find.text('Withdrawal Pending'), findsOneWidget);
    expect(find.text('Withdrawal Successful!'), findsNothing);
    expect(find.text('Your withdrawal request has been received and is being processed. Your funds remain protected while we confirm the provider result.'), findsOneWidget);
  });

  testWidgets('pending status shows pending title', (tester) async {
    await pumpScreen(tester, 'PENDING');

    expect(find.text('Withdrawal Pending'), findsOneWidget);
  });

  testWidgets('new status shows pending title', (tester) async {
    await pumpScreen(tester, 'NEW');

    expect(find.text('Withdrawal Pending'), findsOneWidget);
  });

  testWidgets('under review status shows review title', (tester) async {
    await pumpScreen(tester, 'UNDER_REVIEW');

    expect(find.text('Withdrawal Under Review'), findsOneWidget);
  });

  testWidgets('failed status keeps existing failure behavior', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: WithdrawSuccessScreen(
          transaction: makeTransaction('FAILED'),
          hasError: true,
          errorMessage: 'Your withdrawal could not be completed.',
        ),
      ),
    );

    expect(find.text('Your withdrawal could not be completed.'), findsOneWidget);
  });

  testWidgets('non-terminal states still use the success screen and disable receipt', (tester) async {
    for (final status in ['PROCESSING', 'PENDING', 'NEW', 'UNDER_REVIEW']) {
      await pumpScreen(tester, status);
      expect(find.byType(WithdrawSuccessScreen), findsOneWidget);

      final receiptButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'View Receipt'),
      );
      expect(receiptButton.onPressed, isNull);
      await tester.pump();
    }
  });
}
