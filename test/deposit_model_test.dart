import 'package:flutter_test/flutter_test.dart';
import 'package:noble_cards/models/deposit_model.dart';

void main() {
  group('Deposit parsing robustness', () {
    test('accepts int, double, num, string, and null amounts in bank transfer details', () {
      final intJson = BankTransferDetails.fromJson({
        'bankName': 'Zenith Bank',
        'accountNumber': '1234567890',
        'accountName': 'Noble Wallet',
        'amount': 1100,
        'currency': 'NGN',
      });

      final doubleJson = BankTransferDetails.fromJson({
        'bankName': 'Zenith Bank',
        'accountNumber': '1234567890',
        'accountName': 'Noble Wallet',
        'amount': 1100.0,
        'currency': 'NGN',
      });

      final numJson = BankTransferDetails.fromJson({
        'bankName': 'Zenith Bank',
        'accountNumber': '1234567890',
        'accountName': 'Noble Wallet',
        'amount': 1100.00,
        'currency': 'NGN',
      });

      final stringJson = BankTransferDetails.fromJson({
        'bankName': 'Zenith Bank',
        'accountNumber': '1234567890',
        'accountName': 'Noble Wallet',
        'amount': '1100.00',
        'currency': 'NGN',
      });

      final nullJson = BankTransferDetails.fromJson({
        'bankName': 'Zenith Bank',
        'accountNumber': '1234567890',
        'accountName': 'Noble Wallet',
        'amount': null,
        'currency': 'NGN',
      });

      expect(intJson.amount, 1100);
      expect(doubleJson.amount, 1100.0);
      expect(numJson.amount, 1100.0);
      expect(stringJson.amount, 1100.0);
      expect(nullJson.amount, 0);
    });

    test('parses deposit payloads with bank transfer details and stringified numeric fields', () {
      final deposit = Deposit.fromJson({
        'id': 'dep_123',
        'status': 'PENDING',
        'provider': 'FLUTTERWAVE',
        'currency': 'NGN',
        'amount': '1100.00',
        'fee': '22.00',
        'netAmount': '1078.00',
        'paymentMethod': 'BANK_TRANSFER',
        'walletId': 'wallet_123',
        'bankTransfer': {
          'bankName': 'Access Bank',
          'accountNumber': '0067100155',
          'accountName': 'NobleCards',
          'amount': '1100.00',
          'currency': 'NGN',
          'expiresAt': '2025-04-01T00:00:00Z',
        },
      });

      expect(deposit.amount, '1100.00');
      expect(deposit.bankTransfer, isNotNull);
      expect(deposit.bankTransfer!.accountNumber, '0067100155');
      expect(deposit.bankTransfer!.amount, 1100.0);
    });
  });
}
