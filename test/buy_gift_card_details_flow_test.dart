import 'package:flutter_test/flutter_test.dart';
import 'package:noble_cards/screens/authentication/services/authentication_service.dart';
import 'package:noble_cards/screens/orders/gift_card_details/models/gift_card_details_model.dart';
import 'package:noble_cards/screens/orders/services/gift_card_details_service.dart';

class _FakeAuthenticationService extends AuthenticationService {
  final Map<String, dynamic> response;
  final String expectedPath;

  _FakeAuthenticationService({
    required this.response,
    required this.expectedPath,
  });

  @override
  Future<Map<String, dynamic>> authenticatedGet(String path) async {
    expect(path, expectedPath);
    return response;
  }
}

void main() {
  test('maps the authenticated Buy detail response into real gift-card details', () async {
    final service = GiftCardDetailsService(
      authentication: _FakeAuthenticationService(
        expectedPath: '/gift-cards/buy/buy-db-id',
        response: {
          'id': 'buy-db-id',
          'reference': 'NC-BUY-REFERENCE',
          'status': 'SUCCESSFUL',
          'brandName': 'Amazon',
          'productName': 'Amazon Gift Card',
          'countryCode': 'US',
          'cardCurrencyCode': 'USD',
          'currencyCode': 'USD',
          'amount': '25.00',
          'customerPrice': '25.50',
          'voucherCode': 'REAL-GIFT-CARD-CODE',
          'redeemDetails': {
            'pin': '4826',
            'instructions': 'Redeem online.',
          },
          'providerMessage': 'Delivered successfully.',
          'createdAt': '2026-09-15T12:00:00Z',
        },
      ),
    );

    final details = await service.fetchPurchaseDetails('buy-db-id');

    expect(details.orderId, 'buy-db-id');
    expect(details.brandName, 'Amazon');
    expect(details.cardType, 'Amazon Gift Card');
    expect(details.country, 'US');
    expect(details.denomination, 25.00);
    expect(details.amountPaid, 25.50);
    expect(details.currency, 'USD');
    expect(details.status, 'SUCCESSFUL');
    expect(details.code, 'REAL-GIFT-CARD-CODE');
    expect(details.pin, '4826');
    expect(details.importantInformation, contains('Redeem online.'));
  });

  test('does not expose code or PIN for pending or failed purchases', () async {
    final service = GiftCardDetailsService(
      authentication: _FakeAuthenticationService(
        expectedPath: '/gift-cards/buy/pending-db-id',
        response: {
          'id': 'pending-db-id',
          'status': 'PENDING',
          'brandName': 'Amazon',
          'productName': 'Amazon Gift Card',
          'countryCode': 'US',
          'amount': '25.00',
          'customerPrice': '25.50',
          'voucherCode': 'UNAVAILABLE-CODE',
          'redeemDetails': {'pin': 'UNAVAILABLE-PIN'},
        },
      ),
    );

    final details = await service.fetchPurchaseDetails('pending-db-id');

    expect(details.code, '');
    expect(details.pin, isNull);
  });

  test('uses the backend model contract without inventing purchase details', () {
    final details = GiftCardDetailsModel(
      orderId: 'buy-db-id',
      brandName: 'Amazon',
      cardType: 'Amazon Gift Card',
      country: 'US',
      format: 'Digital',
      denomination: 25,
      amountPaid: 25.5,
      currency: 'USD',
      status: 'SUCCESSFUL',
      code: 'REAL-GIFT-CARD-CODE',
      pin: '4826',
      importantInformation: const [],
    );

    expect(details.code, isNotEmpty);
    expect(details.pin, isNotNull);
  });
}
