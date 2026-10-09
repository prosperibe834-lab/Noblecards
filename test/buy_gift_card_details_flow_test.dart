import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noble_cards/screens/authentication/services/authentication_service.dart';
import 'package:noble_cards/screens/cards/gift_card_redemption_web_view.dart';
import 'package:noble_cards/screens/orders/gift_card_details/models/gift_card_details_model.dart';
import 'package:noble_cards/screens/orders/services/gift_card_details_service.dart';
import 'package:noble_cards/screens/cards/services/buy_receipt_service.dart';
import 'package:noble_cards/screens/orders/gift_card_details/widgets/gift_card_components.dart';
import 'package:noble_cards/screens/orders/gift_card_details/gift_card_details_screen.dart';
import 'package:noble_cards/screens/orders/services/gift_card_receipt_pdf_service.dart';
import 'package:noble_cards/widgets/gift_card_brand_logo.dart';

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

  test('maps only the purchase product logo for FlixTrain DE', () async {
    final details = await GiftCardDetailsService(
      authentication: _FakeAuthenticationService(
        expectedPath: '/gift-cards/buy/flixtrain-id',
        response: {
          'id': 'flixtrain-id',
          'reference': 'NC-BUY-FLIXTRAIN',
          'status': 'SUCCESSFUL',
          'brandName': 'FlixTrain DE',
          'productName': 'FlixTrain DE',
          'brandLogoUrl': 'https://cdn.example.test/flixtrain-de.png',
          'countryCode': 'DE',
          'currencyCode': 'EUR',
          'amount': '25',
        },
      ),
    ).fetchPurchaseDetails('flixtrain-id');

    expect(details.brandName, 'FlixTrain DE');
    expect(details.brandLogoUrl, 'https://cdn.example.test/flixtrain-de.png');
    expect(details.brandLogoUrl, isNot(contains('amazon')));
  });

  test(
    'uses the generic logo when no verified product logo is returned',
    () async {
      final details = await GiftCardDetailsService(
        authentication: _FakeAuthenticationService(
          expectedPath: '/gift-cards/buy/flixtrain-id',
          response: {
            'id': 'flixtrain-id',
            'status': 'SUCCESSFUL',
            'brandName': 'FlixTrain DE',
            'productName': 'FlixTrain DE',
            'brandLogoUrl': 'http://untrusted.example.test/amazon.png',
          },
        ),
      ).fetchPurchaseDetails('flixtrain-id');

      expect(details.brandLogoUrl, isNull);
    },
  );

  testWidgets(
    'FlixTrain hero never renders Amazon branding without its own logo',
    (tester) async {
      final details = GiftCardDetailsModel(
        orderId: 'flixtrain-id',
        brandName: 'FlixTrain DE',
        cardType: 'FlixTrain DE',
        country: 'DE',
        format: 'Digital',
        denomination: 25,
        amountPaid: 25,
        currency: 'EUR',
        status: 'SUCCESSFUL',
        code: '',
        importantInformation: const [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: GiftCardHero(data: details, isDark: false)),
        ),
      );

      expect(find.byIcon(Boxicons.bx_credit_card_front), findsOneWidget);
      expect(find.byIcon(Boxicons.bxl_amazon), findsNothing);
    },
  );

  testWidgets(
    'a failed product-logo image falls back to the generic card icon',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GiftCardBrandLogo(
              imageUrl: 'https://invalid.example.test/flixtrain.png',
              size: 32,
              fallbackColor: Colors.white,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('gift-card-brand-fallback')),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'renders the exact product logo URL supplied by purchase details',
    (tester) async {
      const logoUrl = 'https://cdn.example.test/flixtrain-de.png';
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GiftCardBrandLogo(
              imageUrl: logoUrl,
              size: 32,
              fallbackColor: Colors.white,
            ),
          ),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));
      expect((image.image as NetworkImage).url, logoUrl);
    },
  );

  test('copy and download text include only available code and PIN', () {
    const code = 'FLIXTRAIN-VERY-LONG-REAL-CODE-0123456789';
    final details = GiftCardDetailsModel(
      orderId: 'internal-id',
      orderReference: 'NC-BUY-PUBLIC-REF',
      brandName: 'FlixTrain DE',
      cardType: 'FlixTrain DE',
      country: 'DE',
      format: 'Digital',
      denomination: 25,
      amountPaid: 25.5,
      currency: 'EUR',
      status: 'SUCCESSFUL',
      code: code,
      pin: '4826',
      importantInformation: const [],
    );

    for (final output in [details.copyAllDetailsText, details.downloadText]) {
      expect(output, contains('Brand: FlixTrain DE'));
      expect(output, contains('Product: FlixTrain DE'));
      expect(output, contains('Amount: 25.00'));
      expect(output, contains('Currency: EUR'));
      expect(output, contains('Country: DE'));
      expect(output, contains('Status: SUCCESSFUL'));
      expect(output, contains('Order Reference: NC-BUY-PUBLIC-REF'));
      expect(output, contains('Gift Card Code: $code'));
      expect(output, contains('Gift Card PIN: 4826'));
      expect(output, isNot(contains('internal-id')));
      expect(output, isNot(contains('Amount Paid')));
    }
  });

  test('copy and download do not invent missing code or PIN', () {
    final details = GiftCardDetailsModel(
      orderId: 'internal-id',
      brandName: 'FlixTrain DE',
      cardType: 'FlixTrain DE',
      country: 'Unknown',
      format: 'Digital',
      denomination: 25,
      amountPaid: 25,
      currency: 'EUR',
      status: 'SUCCESSFUL',
      code: '',
      importantInformation: const [],
    );

    for (final output in [details.copyAllDetailsText, details.downloadText]) {
      expect(output, isNot(contains('Gift Card Code:')));
      expect(output, isNot(contains('Gift Card PIN:')));
      expect(output, isNot(contains('Country:')));
      expect(output, isNot(contains('placeholder')));
      expect(output, isNot(contains('Unknown')));
    }
  });

  test('generates a real PDF containing available receipt fields', () async {
    final details = GiftCardDetailsModel(
      orderId: 'internal-id',
      orderReference: 'NC-BUY-FLIXTRAIN',
      brandName: 'FlixTrain DE',
      cardType: 'FlixTrain DE',
      country: 'DE',
      format: 'Digital',
      denomination: 20,
      amountPaid: 20,
      currency: 'EUR',
      status: 'SUCCESSFUL',
      code: 'REAL-FLIXTRAIN-CODE-01234567890123456789',
      pin: '4826',
      importantInformation: const [],
    );

    final pdf = await GiftCardReceiptPdfService.generatePdf(details);
    final receiptLines = GiftCardReceiptPdfService.receiptLines(details);

    expect(String.fromCharCodes(pdf.take(5)), '%PDF-');
    expect(pdf.length, greaterThan(1000));
    expect(receiptLines, contains('Brand: FlixTrain DE'));
    expect(receiptLines, contains('Amount: 20.00'));
    expect(receiptLines, contains('Currency: EUR'));
    expect(receiptLines, contains('Country: DE'));
    expect(receiptLines, contains('Status: SUCCESSFUL'));
    expect(receiptLines, contains('Order Reference: NC-BUY-FLIXTRAIN'));
    expect(receiptLines, contains('Gift Card Code: ${details.code}'));
    expect(receiptLines, contains('Gift Card PIN: 4826'));
    expect(receiptLines, isNot(contains('internal-id')));
  });

  test('PDF falls back to View Gift Card guidance without credentials', () async {
    final details = GiftCardDetailsModel(
      orderId: 'internal-id',
      brandName: 'FlixTrain DE',
      cardType: 'FlixTrain DE',
      country: 'DE',
      format: 'Digital',
      denomination: 20,
      amountPaid: 20,
      currency: 'EUR',
      status: 'SUCCESSFUL',
      code: '',
      importantInformation: const [],
    );

    final pdf = await GiftCardReceiptPdfService.generatePdf(details);
    final receiptLines = GiftCardReceiptPdfService.receiptLines(details);

    expect(String.fromCharCodes(pdf.take(5)), '%PDF-');
    expect(receiptLines, isNot(contains(startsWith('Gift Card Code:'))));
    expect(receiptLines, isNot(contains(startsWith('Gift Card PIN:'))));
    expect(details.code, isEmpty);
  });

  test('long credential wrapping preserves every character without clipping', () {
    const code = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    final wrapped = GiftCardReceiptPdfService.wrapCredentialForPdf(code);

    expect(wrapped.replaceAll('\n', ''), code);
    expect(wrapped.split('\n').every((line) => line.length <= 24), isTrue);
  });

  testWidgets('Copy All Details copies the actual available code and PIN', (
    tester,
  ) async {
    String? copiedText;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copiedText = (call.arguments as Map)['text'] as String?;
        }
        return null;
      },
    );
    final details = GiftCardDetailsModel(
      orderId: 'private-database-id',
      orderReference: 'NC-BUY-FLIXTRAIN',
      brandName: 'FlixTrain DE',
      cardType: 'FlixTrain DE',
      country: 'DE',
      format: 'Digital',
      denomination: 25,
      amountPaid: 25,
      currency: 'EUR',
      status: 'SUCCESSFUL',
      code: 'REAL-FLIXTRAIN-CODE',
      pin: '4826',
      importantInformation: const [],
    );

    await tester.pumpWidget(
      MaterialApp(home: GiftCardDetailsScreen(giftCardData: details)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Copy All Details'));
    await tester.pump();

    expect(copiedText, contains('Gift Card Code: REAL-FLIXTRAIN-CODE'));
    expect(copiedText, contains('Gift Card PIN: 4826'));
    expect(copiedText, isNot(contains('private-database-id')));

    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      null,
    );
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
      uri: Uri.parse(
        'https://testflight.tremendous.com/rewards/payout/secret-token',
      ),
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
