import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noble_cards/screens/authentication/services/authentication_service.dart';
import 'package:noble_cards/screens/withraw/withdrawal_history_screen.dart';

class FakeWithdrawalHistoryAuthenticationService extends AuthenticationService {
  FakeWithdrawalHistoryAuthenticationService({
    required this.records,
    this.error,
  });

  final List<dynamic> records;
  final Object? error;
  String? requestedPath;

  @override
  Future<List<dynamic>> authenticatedGetList(String path) async {
    requestedPath = path;
    if (error != null) throw error!;
    return records;
  }
}

void main() {
  testWidgets('renders persisted withdrawal history from the API', (
    tester,
  ) async {
    final auth = FakeWithdrawalHistoryAuthenticationService(
      records: [
        {
          'sourceCurrency': 'USD',
          'destinationCurrency': 'NGN',
          'sourceAmount': '50.00',
          'destinationAmount': '75000.00',
          'destinationFee': '2250.00',
          'amountReceived': '72750.00',
          'exchangeRate': '1500.00',
          'paymentMethod': 'BANK_TRANSFER',
          'country': 'Nigeria',
          'countryCode': 'NG',
          'reference': 'WD-REAL-1',
          'createdAt': '2026-10-19T12:30:00.000Z',
          'status': 'PROCESSING',
          'beneficiary': {
            'institutionName': 'Test Bank',
            'accountLast4': '4920',
          },
        },
      ],
    );

    await tester.pumpWidget(
      MaterialApp(home: WithdrawalHistoryScreen(authService: auth)),
    );
    await tester.pump();

    expect(auth.requestedPath, '/withdrawals');
    expect(find.text('Bank Withdrawal'), findsOneWidget);
    expect(find.text('Test Bank • ****4920'), findsOneWidget);
    expect(find.text('-USD 50.00'), findsOneWidget);
    expect(find.text('Processing'), findsOneWidget);
  });

  testWidgets('renders the empty state instead of sample rows', (tester) async {
    final auth = FakeWithdrawalHistoryAuthenticationService(records: []);

    await tester.pumpWidget(
      MaterialApp(home: WithdrawalHistoryScreen(authService: auth)),
    );
    await tester.pump();

    expect(find.text('No withdrawals yet.'), findsOneWidget);
    expect(find.text('Bank Withdrawal'), findsNothing);
  });

  testWidgets('renders an API error instead of sample rows', (tester) async {
    final auth = FakeWithdrawalHistoryAuthenticationService(
      records: [],
      error: Exception('History unavailable'),
    );

    await tester.pumpWidget(
      MaterialApp(home: WithdrawalHistoryScreen(authService: auth)),
    );
    await tester.pump();

    expect(find.text('History unavailable'), findsOneWidget);
    expect(find.text('Bank Withdrawal'), findsNothing);
    expect(find.text('Try again'), findsOneWidget);
  });
}
