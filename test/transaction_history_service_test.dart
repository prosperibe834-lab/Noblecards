import 'package:flutter_test/flutter_test.dart';
import 'package:noble_cards/screens/TransactionHistory/models/transaction_history_model.dart';
import 'package:noble_cards/screens/TransactionHistory/services/transaction_history_service.dart';
import 'package:noble_cards/screens/authentication/services/authentication_service.dart';
import 'package:noble_cards/screens/withraw/models/withdrawal_transaction_model.dart';

class _RecordingAuthenticationService extends AuthenticationService {
  final requestedPaths = <String>[];

  @override
  Future<Map<String, dynamic>> authenticatedGet(String path) async {
    requestedPaths.add(path);
    return {'id': path.split('/').last};
  }
}

void main() {
  test('maps real backend deposits and withdrawals into the existing transaction model', () {
    final items = TransactionHistoryService.mapBackendTransactions([
      {
        'id': 'dep-1',
        'status': 'SUCCESSFUL',
        'provider': 'FLUTTERWAVE',
        'currency': 'NGN',
        'amount': '2500.00',
        'fee': '50.00',
        'netAmount': '2450.00',
        'createdAt': '2025-04-28T10:24:00Z',
        'transaction': {
          'id': 'tx-dep-1',
          'status': 'SUCCESSFUL',
          'reference': 'DPT-001',
        },
      },
      {
        'id': 'wd-1',
        'status': 'PENDING',
        'reference': 'WD-001',
        'sourceCurrencyCode': 'USD',
        'destinationCurrencyCode': 'USD',
        'sourceAmount': '200.00',
        'fee': '4.00',
        'amountReceived': '196.00',
        'country': 'United States',
        'paymentMethod': 'BANK_TRANSFER',
        'createdAt': '2025-04-27T16:15:00Z',
        'transaction': {
          'id': 'tx-wd-1',
          'status': 'PENDING',
          'reference': 'TX-001',
        },
      },
    ]);

    expect(items.length, 2);
    expect(items.first.type, TransactionType.deposit);
    expect(items.first.amount, 2450.00);
    expect(items.first.currency, 'USD');
    expect(items.first.status, TransactionStatus.completed);

    expect(items.last.type, TransactionType.withdrawal);
    expect(items.last.amount, 200.00);
    expect(items.last.currency, 'USD');
    expect(items.last.status, TransactionStatus.pending);
    expect(items.last.method, 'Bank Transfer');
  });

  test('detail requests preserve each selected deposit and withdrawal record ID', () async {
    final authentication = _RecordingAuthenticationService();
    final service = TransactionHistoryService(authentication: authentication);

    final depositA = await service.fetchDepositDetails('deposit-a');
    final depositB = await service.fetchDepositDetails('deposit-b');
    final withdrawalA = await service.fetchWithdrawalDetails('withdrawal-a');
    final withdrawalB = await service.fetchWithdrawalDetails('withdrawal-b');

    expect(depositA['id'], 'deposit-a');
    expect(depositB['id'], 'deposit-b');
    expect(withdrawalA['id'], 'withdrawal-a');
    expect(withdrawalB['id'], 'withdrawal-b');
    expect(authentication.requestedPaths, [
      '/deposits/deposit-a',
      '/deposits/deposit-b',
      '/withdrawals/withdrawal-a',
      '/withdrawals/withdrawal-b',
    ]);
  });

  test('missing record IDs are not replaced by transaction IDs or references', () {
    final items = TransactionHistoryService.mapBackendTransactions([
      {
        'status': 'PENDING',
        'amount': '12.00',
        'createdAt': '2026-10-02T10:00:00.000Z',
        'transaction': {'id': 'transaction-id-not-deposit-id'},
      },
      {
        'status': 'PENDING',
        'sourceCurrencyCode': 'USD',
        'sourceAmount': '15.00',
        'createdAt': '2026-10-02T10:00:00.000Z',
        'reference': 'withdrawal-reference-not-record-id',
      },
    ]);

    expect(items.map((item) => item.id), ['', '']);
  });

  test('withdrawal receipt mapping keeps the exact backend reference and values', () {
    final withdrawal = WithdrawalTransactionModel.fromBackendJson({
      'id': 'withdrawal-2',
      'reference': 'WD-EXACT-2',
      'status': 'PENDING',
      'sourceCurrency': 'USD',
      'sourceAmount': '75.25',
      'destinationCurrency': 'NGN',
      'destinationAmount': '112875.00',
      'exchangeRate': '1500',
      'fee': '2.50',
      'amountReceived': '110000.00',
      'country': 'Nigeria',
      'countryCode': 'NG',
      'paymentMethod': 'BANK_TRANSFER',
      'createdAt': '2026-10-02T10:00:00.000Z',
    });

    expect(withdrawal.referenceId, 'WD-EXACT-2');
    expect(withdrawal.sourceAmount, 75.25);
    expect(withdrawal.destinationAmount, 112875.0);
    expect(withdrawal.amountToReceive, 110000.0);
    expect(withdrawal.status, 'PENDING');
    expect(withdrawal.timestamp, DateTime.parse('2026-10-02T10:00:00.000Z'));
  });
}
