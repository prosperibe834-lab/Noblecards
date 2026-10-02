import 'package:flutter_test/flutter_test.dart';
import 'package:noble_cards/screens/TransactionHistory/models/transaction_history_model.dart';
import 'package:noble_cards/screens/TransactionHistory/services/transaction_history_service.dart';

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
}
