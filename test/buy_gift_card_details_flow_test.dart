import 'package:flutter_test/flutter_test.dart';
import 'package:noble_cards/screens/authentication/services/authentication_service.dart';
import 'package:noble_cards/screens/cards/gift_card_redemption_web_view.dart';
import 'package:noble_cards/screens/orders/gift_card_details/models/gift_card_details_model.dart';
import 'package:noble_cards/screens/orders/services/gift_card_details_service.dart';
import 'package:noble_cards/screens/cards/services/buy_receipt_service.dart';

class _FakeAuthenticationService extends AuthenticationService {
  final Map<String, dynamic> response;
  final String expectedPath;
  final String? expectedPostPath;
  final Map<String, dynamic>? postResponse;
  final Object? postError;

  _FakeAuthenticationService({
    required this.response,
    required this.expectedPath,
    this.expectedPostPath,
    this.postResponse,
    this.postError,
  });

  @override
  Future<Map<String, dynamic>> authenticatedGet(String path) async {
    expect(path, expectedPath);
    return response;
  }

  @override
  Future<Map<String, dynamic>> authenticatedPost(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    expect(path, expectedPostPath);
    if (postError != null) throw postError!;
    return postResponse!;
  }
}

void main() {
  test(
    'maps the authenticated Buy detail response into real gift-card details',
    () async {
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
            'redeemDetails': {'pin': '4826', 'instructions': 'Redeem online.'},
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
    },
  );

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

  test(
    'reads the actual code from nested redeemDetails when the top-level voucherCode is absent',
    () async {
      final service = GiftCardDetailsService(
        authentication: _FakeAuthenticationService(
          expectedPath: '/gift-cards/buy/nested-code-id',
          response: {
            'id': 'nested-code-id',
            'status': 'SUCCESSFUL',
            'brandName': 'Amazon',
            'productName': 'Amazon Gift Card',
            'countryCode': 'US',
            'cardCurrencyCode': 'USD',
            'amount': '25.00',
            'customerPrice': '25.50',
            'redeemDetails': {
              'giftCard': {'code': 'NESTED-SECRET-CODE', 'pin': '9876'},
            },
          },
        ),
      );

      final details = await service.fetchPurchaseDetails('nested-code-id');

      expect(details.code, 'NESTED-SECRET-CODE');
      expect(details.pin, '9876');
    },
  );

  test(
    'uses the backend model contract without inventing purchase details',
    () {
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
    },
  );

  test(
    'requests the secure View Gift Card URL using the authenticated purchase ID',
    () async {
      final service = BuyReceiptService(
        authentication: _FakeAuthenticationService(
          response: const {},
          expectedPath: '',
          expectedPostPath: '/gift-cards/buy/buy-db-id/view-link',
          postResponse: {
            'url':
                'https://testflight.tremendous.com/rewards/payout/secret-token',
          },
        ),
      );

      await expectLater(
        service.requestRedemptionLink('buy-db-id'),
        completion(
          'https://testflight.tremendous.com/rewards/payout/secret-token',
        ),
      );
    },
  );

  test('web dispatch never opens the native WebView route', () async {
    var nativeOpened = false;
    var webLaunched = false;

    final opened = await openGiftCardTarget(
      isWeb: true,
      uri: Uri.parse('https://testflight.tremendous.com/rewards/payout/secret-token'),
      launchOnWeb: (uri) async {
        webLaunched = true;
        expect(uri.host, 'testflight.tremendous.com');
        return true;
      },
      openNativeWebView: () async {
        nativeOpened = true;
      },
    );

    expect(opened, isTrue);
    expect(webLaunched, isTrue);
    expect(nativeOpened, isFalse);
  });

  test('rejects redemption URLs that are not HTTPS Tremendous URLs', () async {
    final service = BuyReceiptService(
      authentication: _FakeAuthenticationService(
        response: const {},
        expectedPath: '',
        expectedPostPath: '/gift-cards/buy/buy-db-id/view-link',
        postResponse: {'url': 'https://evil.example/redeem'},
      ),
    );

    await expectLater(
      service.requestRedemptionLink('buy-db-id'),
      throwsA(isA<FormatException>()),
    );
  });

  test('maps a legacy email reward to a safe delivery message', () async {
    final service = BuyReceiptService(
      authentication: _FakeAuthenticationService(
        response: const {},
        expectedPath: '',
        expectedPostPath: '/gift-cards/buy/buy-db-id/view-link',
        postError: Exception(
          'This gift card uses the previous delivery method and cannot be opened in-app.',
        ),
      ),
    );

    await expectLater(
      service.requestRedemptionLink('buy-db-id'),
      throwsA(
        isA<GiftCardRedemptionFailure>().having(
          (error) => error.message,
          'message',
          'This gift card was delivered using the previous delivery method.',
        ),
      ),
    );
  });

  test('maps unexpected provider details to a generic safe message', () async {
    final service = BuyReceiptService(
      authentication: _FakeAuthenticationService(
        response: const {},
        expectedPath: '',
        expectedPostPath: '/gift-cards/buy/buy-db-id/view-link',
        postError: Exception(
          'private provider response containing credentials',
        ),
      ),
    );

    await expectLater(
      service.requestRedemptionLink('buy-db-id'),
      throwsA(
        isA<GiftCardRedemptionFailure>().having(
          (error) => error.message,
          'message',
          'Gift card is temporarily unavailable. Please try again.',
        ),
      ),
    );
  });

  test('maps connection failures to a network message', () async {
    final service = BuyReceiptService(
      authentication: _FakeAuthenticationService(
        response: const {},
        expectedPath: '',
        expectedPostPath: '/gift-cards/buy/buy-db-id/view-link',
        postError: Exception('SocketException: connection refused'),
      ),
    );

    await expectLater(
      service.requestRedemptionLink('buy-db-id'),
      throwsA(
        isA<GiftCardRedemptionFailure>().having(
          (error) => error.message,
          'message',
          'Unable to connect. Please check your internet connection and try again.',
        ),
      ),
    );
  });

  test(
    'web redemption opens the URL without invoking the native WebView',
    () async {
      final uri = Uri.parse(
        'https://testflight.tremendous.com/rewards/payout/id',
      );
      var webOpened = false;
      var nativeOpened = false;

      final opened = await openGiftCardTarget(
        isWeb: true,
        uri: uri,
        launchOnWeb: (value) async {
          expect(value, uri);
          webOpened = true;
          return true;
        },
        openNativeWebView: () async {
          nativeOpened = true;
        },
      );

      expect(opened, isTrue);
      expect(webOpened, isTrue);
      expect(nativeOpened, isFalse);
    },
  );

  test(
    'native redemption uses the in-app WebView instead of web launching',
    () async {
      final uri = Uri.parse(
        'https://testflight.tremendous.com/rewards/payout/id',
      );
      var webOpened = false;
      var nativeOpened = false;

      final opened = await openGiftCardTarget(
        isWeb: false,
        uri: uri,
        launchOnWeb: (_) async {
          webOpened = true;
          return false;
        },
        openNativeWebView: () async {
          nativeOpened = true;
        },
      );

      expect(opened, isTrue);
      expect(nativeOpened, isTrue);
      expect(webOpened, isFalse);
    },
  );
}
