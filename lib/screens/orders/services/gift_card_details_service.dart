import '../../authentication/services/authentication_service.dart';
import '../gift_card_details/models/gift_card_details_model.dart';

class GiftCardDetailsService {
  final AuthenticationService _authentication;

  GiftCardDetailsService({
    AuthenticationService? authentication,
  }) : _authentication = authentication ?? AuthenticationService();

  Future<GiftCardDetailsModel> fetchPurchaseDetails(String purchaseId) async {
    final purchase = await _authentication.authenticatedGet(
      '/gift-cards/buy/${Uri.encodeComponent(purchaseId)}',
    );

    final status = (purchase['status']?.toString() ?? '').toUpperCase();
    final isSuccessful = status == 'SUCCESSFUL';
    final redeemDetails = purchase['redeemDetails'] is Map
        ? purchase['redeemDetails'] as Map<String, dynamic>
        : <String, dynamic>{};
    final code = isSuccessful
        ? purchase['voucherCode']?.toString() ?? ''
        : '';
    final pin = isSuccessful
        ? _readString(redeemDetails, ['pin', 'voucherPin', 'pinCode'])
        : null;
    final importantInformation = <String>[
      if (purchase['providerMessage']?.toString().trim().isNotEmpty ?? false)
        purchase['providerMessage'].toString().trim(),
      ..._importantInformation(redeemDetails),
    ];

    return GiftCardDetailsModel(
      orderId: purchase['id']?.toString() ?? purchaseId,
      brandName: purchase['brandName']?.toString() ??
          purchase['productName']?.toString() ??
          'Gift Card',
      cardType: purchase['productName']?.toString() ??
          purchase['brandName']?.toString() ??
          'Digital Gift Card',
      country: purchase['countryCode']?.toString() ??
          purchase['country']?.toString() ??
          'Unknown',
      format: 'Digital',
      denomination: _decimal(purchase['amount']),
      amountPaid: _decimal(purchase['customerPrice']),
      currency: purchase['cardCurrencyCode']?.toString() ??
          purchase['currencyCode']?.toString() ??
          'USD',
      status: status,
      code: code,
      pin: pin,
      importantInformation: importantInformation,
    );
  }

  String? _readString(Map<String, dynamic> source, List<String> keys) {
    for (final key in keys) {
      final value = source[key];
      if (value is String && value.trim().isNotEmpty) return value.trim();
    }
    return null;
  }

  List<String> _importantInformation(Map<String, dynamic> redeemDetails) {
    final values = <String>[];
    for (final key in const ['instructions', 'instruction', 'redemptionInstructions', 'redeemInstruction']) {
      final value = redeemDetails[key];
      if (value is String && value.trim().isNotEmpty) {
        values.add(value.trim());
      }
    }
    return values;
  }

  double _decimal(dynamic value) {
    return double.tryParse(value.toString()) ?? 0;
  }
}
