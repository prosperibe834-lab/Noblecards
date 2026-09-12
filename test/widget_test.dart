import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noble_cards/providers/exchange_rate_provider.dart';
import 'package:noble_cards/screens/currency_selector_screen.dart';
import 'package:noble_cards/screens/deposit_screen.dart';
import 'package:noble_cards/screens/withraw/models/withdraw_bank_models.dart';
import 'package:noble_cards/screens/withraw/models/withdrawal_transaction_model.dart';
import 'package:noble_cards/screens/withraw/providers/withdraw_bank_provider.dart';
import 'package:noble_cards/screens/withraw/providers/withdraw_provider.dart';
import 'package:noble_cards/screens/withraw/withdraw_success_screen.dart';
import 'package:noble_cards/screens/withraw/withdrawal_receipt_screen.dart';
import 'package:noble_cards/screens/authentication/services/authentication_service.dart';

class FakeAuthService extends AuthenticationService {
  @override
  Future<Map<String, dynamic>> authenticatedGet(String path) async {
    if (path == '/withdrawals/banks?countryCode=NG&currencyCode=NGN') {
      return {
        'banks': [
          {'id': '1', 'code': '044', 'name': 'Access Bank'},
          {'id': '2', 'code': '056', 'name': 'GTBank'},
        ],
      };
    }
    throw Exception('Unexpected bank path: $path');
  }
}

void main() {
  setUp(() {
    ExchangeRateProvider.setRates({
      'USD': 1.0,
      'NGN': 1500.0,
      'GBP': 0.79,
      'GHS': 12.5,
    });
  });

  testWidgets('Deposit screen renders and includes the local deposit state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: DepositScreen()));

    expect(find.text('Deposit Funds'), findsOneWidget);
    expect(find.text('You Deposit (NGN)'), findsOneWidget);
    expect(find.textContaining('FX rate:'), findsOneWidget);
    expect(find.textContaining('You Get:'), findsOneWidget);
    expect(find.text('FX rate: 1 USD = NGN 1500.00'), findsOneWidget);
  });

  testWidgets('Quick amount buttons exist and are clickable', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: DepositScreen()));

    // Find quick amount buttons (should have 5 buttons: $50, $100, $200, $500, $1000)
    final quickAmountButtons = find.byType(InkWell).evaluate();
    expect(
      quickAmountButtons.length,
      greaterThanOrEqualTo(5),
      reason: 'Should have at least 5 quick amount buttons',
    );
  });

  test('Nigeria + Bank Transfer loads Nigerian banks only', () async {
    final provider = WithdrawBankProvider(
      authService: FakeAuthService(),
      destination: WithdrawalDestination(
        countryCode: 'NG',
        countryName: 'Nigeria',
        currency: 'NGN',
        flag: '🇳🇬',
      ),
      paymentMethod: 'BANK_TRANSFER',
    );
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(provider.banks.length, 2);
    expect(provider.banks.first.name, 'Access Bank');
  });

  test('UK + Bank Transfer never loads Nigerian banks', () async {
    final provider = WithdrawBankProvider(
      authService: FakeAuthService(),
      destination: WithdrawalDestination(
        countryCode: 'GB',
        countryName: 'United Kingdom',
        currency: 'GBP',
        flag: '🇬🇧',
      ),
      paymentMethod: 'BANK_TRANSFER',
    );
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(provider.banks, isEmpty);
    expect(provider.isLoadingBanks, isFalse);
  });

  test('USA + Bank Transfer never loads Nigerian banks', () async {
    final provider = WithdrawBankProvider(
      authService: FakeAuthService(),
      destination: WithdrawalDestination(
        countryCode: 'US',
        countryName: 'United States',
        currency: 'USD',
        flag: '🇺🇸',
      ),
      paymentMethod: 'BANK_TRANSFER',
    );
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(provider.banks, isEmpty);
  });

  test('Canada + Bank Transfer never loads Nigerian banks', () async {
    final provider = WithdrawBankProvider(
      authService: FakeAuthService(),
      destination: WithdrawalDestination(
        countryCode: 'CA',
        countryName: 'Canada',
        currency: 'CAD',
        flag: '🇨🇦',
      ),
      paymentMethod: 'BANK_TRANSFER',
    );
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(provider.banks, isEmpty);
  });

  test('Ghana flow advertises Bank Transfer and Mobile Money', () {
    final provider = WithdrawProvider();
    final ghana = provider.supportedCountries.firstWhere((c) => c.id == 'GH');
    expect(ghana.supportedMethodIds, contains('bank'));
    expect(ghana.supportedMethodIds, contains('momo'));
  });

  test('Switching Nigeria to UK clears Nigerian bank selection state', () async {
    final provider = WithdrawBankProvider(
      authService: FakeAuthService(),
      destination: WithdrawalDestination(
        countryCode: 'NG',
        countryName: 'Nigeria',
        currency: 'NGN',
        flag: '🇳🇬',
      ),
      paymentMethod: 'BANK_TRANSFER',
    );
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(provider.banks.length, 2);

    provider.setDestination(
      WithdrawalDestination(
        countryCode: 'GB',
        countryName: 'United Kingdom',
        currency: 'GBP',
        flag: '🇬🇧',
      ),
      paymentMethod: 'BANK_TRANSFER',
    );
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(provider.selectedBank, isNull);
    expect(provider.banks, isEmpty);
  });

  test('Switching country never carries incompatible bank data into a new route', () async {
    final provider = WithdrawBankProvider(
      authService: FakeAuthService(),
      destination: WithdrawalDestination(
        countryCode: 'NG',
        countryName: 'Nigeria',
        currency: 'NGN',
        flag: '🇳🇬',
      ),
      paymentMethod: 'BANK_TRANSFER',
    );
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(provider.banks.length, 2);

    provider.setDestination(
      WithdrawalDestination(
        countryCode: 'GH',
        countryName: 'Ghana',
        currency: 'GHS',
        flag: '🇬🇭',
      ),
      paymentMethod: 'BANK_TRANSFER',
    );
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(provider.selectedBank, isNull);
    expect(provider.banks, isEmpty);
  });

  testWidgets(
    'Currency selector includes only the Flutterwave-supported currencies',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: CurrencySelectorScreen()),
      );

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
    },
  );

  testWidgets('Successful withdrawal can open the real receipt screen', (
    WidgetTester tester,
  ) async {
    final transaction = WithdrawalTransactionModel(
      amount: 250,
      sourceAmount: 250,
      sourceCurrency: 'USD',
      destinationAmount: 1000,
      destinationCurrency: 'NGN',
      amountToSend: 250,
      exchangeRate: 4.0,
      convertedAmount: 1000,
      fee: 0,
      amountToReceive: 1000,
      currency: 'NGN',
      method: 'Bank Transfer',
      destinationCountry: 'Nigeria',
      countryFlag: '🇳🇬',
      destinationBank: 'Access Bank',
      destinationAccountMasked: '1234',
      referenceId: 'WD-123',
      timestamp: DateTime(2025, 1, 10, 12, 30),
      status: 'successful',
    );

    await tester.pumpWidget(
      MaterialApp(home: WithdrawSuccessScreen(transaction: transaction)),
    );

    expect(find.text('View Receipt'), findsOneWidget);

    await tester.ensureVisible(find.text('View Receipt'));
    await tester.tap(find.text('View Receipt'), warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.byType(WithdrawalReceiptScreen), findsOneWidget);
    final receipt = tester.widget<WithdrawalReceiptScreen>(
      find.byType(WithdrawalReceiptScreen),
    );
    expect(receipt.transaction.referenceId, 'WD-123');
    expect(receipt.transaction.status, 'successful');
  });

  testWidgets('Null successful withdrawal state remains safe', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: WithdrawSuccessScreen()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('View Receipt'), findsNothing);
  });
}
