import 'package:flutter_test/flutter_test.dart';
import 'package:noble_cards/screens/authentication/services/authentication_service.dart';
import 'package:noble_cards/screens/cards/models/sell_receipt_model.dart';
import 'package:noble_cards/screens/cards/services/sell_receipt_service.dart';

class _FakeAuthenticationService extends AuthenticationService {
  final Map<String, dynamic> response;
  String? requestedPath;

  _FakeAuthenticationService(this.response);

  @override
  Future<Map<String, dynamic>> authenticatedGet(String path) async {
    requestedPath = path;
    return response;
  }
}

void main() {
  test('loads safe provider details for the authenticated sale ID', () async {
    final authentication = _FakeAuthenticationService({
      'id': 'sale-123',
      'status': 'REJECTED',
      'providerStatus': 'invalid_card_code',
      'providerMessage': 'This gift card has already been redeemed.',
      'cardAmount': '100',
      'quotedRate': '0',
      'quotedPayoutAmount': '0',
      'payoutCurrency': 'USD',
      'createdAt': '2026-10-15T10:00:00.000Z',
    });
    final service = SellReceiptService(authentication: authentication);

    final receipt = await service.fetchReceipt('sale-123');

    expect(authentication.requestedPath, '/gift-cards/sell/sale-123');
    expect(receipt.referenceId, 'sale-123');
    expect(receipt.status, VerificationStatus.rejected);
    expect(receipt.providerStatus, 'INVALID_CARD_CODE');
    expect(
      receipt.providerMessage,
      'This gift card has already been redeemed.',
    );
  });

  test(
    'uses no provider message when it may contain secret card data',
    () async {
      final authentication = _FakeAuthenticationService({
        'id': 'sale-123',
        'status': 'REJECTED',
        'providerStatus': 'REJECTED',
        'providerMessage': 'Redemption code: AQ-AMZN-TEST-CODE-1234',
        'cardAmount': '100',
        'quotedRate': '0',
        'quotedPayoutAmount': '0',
        'payoutCurrency': 'USD',
      });
      final service = SellReceiptService(authentication: authentication);

      final receipt = await service.fetchReceipt('sale-123');

      expect(receipt.providerStatus, 'REJECTED');
      expect(receipt.providerMessage, isNull);
    },
  );

  test(
    'ignores malformed provider statuses and structured provider messages',
    () async {
      final authentication = _FakeAuthenticationService({
        'id': 'sale-123',
        'status': 'REJECTED',
        'providerStatus': 'REJECTED {"token":"secret"}',
        'providerMessage': '{"message":"rejected","secret":"value"}',
        'cardAmount': '100',
        'quotedRate': '0',
        'quotedPayoutAmount': '0',
        'payoutCurrency': 'USD',
      });
      final service = SellReceiptService(authentication: authentication);

      final receipt = await service.fetchReceipt('sale-123');

      expect(receipt.providerStatus, isNull);
      expect(receipt.providerMessage, isNull);
    },
  );
}
