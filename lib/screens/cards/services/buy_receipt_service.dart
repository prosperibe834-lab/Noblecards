import '../models/purchased_gift_card.dart';
import '../../authentication/services/authentication_service.dart';

class GiftCardRedemptionFailure implements Exception {
  final String message;

  const GiftCardRedemptionFailure(this.message);

  factory GiftCardRedemptionFailure.from(Object error) {
    final text = error.toString().toLowerCase();
    if (text.contains('previous delivery method')) {
      return const GiftCardRedemptionFailure(
        'This gift card was delivered using the previous delivery method.',
      );
    }
    if (text.contains('not found')) {
      return const GiftCardRedemptionFailure(
        'This gift card could not be found.',
      );
    }
    if (text.contains('invalid or expired session') ||
        text.contains('authentication required')) {
      return const GiftCardRedemptionFailure(
        'Please sign in again to view this gift card.',
      );
    }
    if (text.contains('socketexception') ||
        text.contains('clientexception') ||
        text.contains('failed to fetch') ||
        text.contains('network') ||
        text.contains('connection refused') ||
        text.contains('timed out') ||
        text.contains('timeout')) {
      return const GiftCardRedemptionFailure(
        'Unable to connect. Please check your internet connection and try again.',
      );
    }
    return const GiftCardRedemptionFailure(
      'Gift card is temporarily unavailable. Please try again.',
    );
  }

  @override
  String toString() => message;
}

class BuyReceiptService {
  final AuthenticationService _authentication;

  BuyReceiptService({AuthenticationService? authentication})
    : _authentication = authentication ?? AuthenticationService();

  Future<PurchasedGiftCard> fetchPurchaseDetails(String transactionId) async {
    final purchase = await _authentication.authenticatedGet(
      '/gift-cards/buy/${Uri.encodeComponent(transactionId)}',
    );
    final status = (purchase['status']?.toString() ?? '').toUpperCase();

    return PurchasedGiftCard(
      referenceId: purchase['reference']?.toString() ?? transactionId,
      brandName:
          purchase['brandName']?.toString() ??
          purchase['productName']?.toString() ??
          'Gift Card',
      region: purchase['countryCode']?.toString() ?? '',
      countryFlag: _flagForCountry(purchase['countryCode']?.toString() ?? ''),
      cardType: 'Digital Code',
      quantity: int.tryParse(purchase['quantity']?.toString() ?? '1') ?? 1,
      faceValue: double.tryParse(purchase['amount']?.toString() ?? '0') ?? 0,
      amountPaid:
          double.tryParse(purchase['customerPrice']?.toString() ?? '0') ?? 0,
      paymentMethod: '${purchase['currencyCode']?.toString() ?? 'USD'} Wallet',
      currencyCode:
          purchase['cardCurrencyCode']?.toString() ??
          purchase['currencyCode']?.toString() ??
          '',
      paymentCurrencyCode: purchase['currencyCode']?.toString() ?? 'USD',
      purchaseDate: purchase['createdAt']?.toString() ?? '',
      status: _status(status),
      cardCode: purchase['voucherCode']?.toString() ?? '',
      pin: null,
      providerMessage: purchase['providerMessage']?.toString(),
    );
  }

  Future<String> requestRedemptionLink(String purchaseId) async {
    late final Map<String, dynamic> response;
    try {
      response = await _authentication.authenticatedPost(
        '/gift-cards/buy/${Uri.encodeComponent(purchaseId)}/view-link',
      );
    } catch (error) {
      throw GiftCardRedemptionFailure.from(error);
    }
    final value = response['url'];
    if (value is! String) {
      throw const FormatException('Gift-card link is unavailable.');
    }
    final uri = Uri.tryParse(value);
    if (uri == null ||
        uri.scheme != 'https' ||
      !(uri.host == 'tremendous.com' || uri.host.endsWith('.tremendous.com'))) {
      throw const FormatException('Gift-card link is invalid.');
    }
    return uri.toString();
  }

  PurchaseStatus _status(String status) {
    if (status == 'SUCCESSFUL') return PurchaseStatus.completed;
    if (status == 'FAILED' || status == 'CANCELLED' || status == 'REJECTED') {
      return PurchaseStatus.failed;
    }
    return PurchaseStatus.pending;
  }

  String _flagForCountry(String code) {
    if (code.length != 2) return '🌍';
    final normalized = code.toUpperCase();
    return String.fromCharCodes(
      normalized.codeUnits.map((unit) => 0x1F1E6 + unit - 65),
    );
  }
}
