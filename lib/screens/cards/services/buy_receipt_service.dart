import '../models/purchased_gift_card.dart';
import '../../authentication/services/authentication_service.dart';

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
