import '../models/sell_receipt_model.dart';
import 'package:noble_cards/screens/authentication/services/authentication_service.dart';
import 'package:noble_cards/providers/exchange_rate_provider.dart';

class SellReceiptService {
  final AuthenticationService _authentication;

  SellReceiptService({AuthenticationService? authentication})
    : _authentication = authentication ?? AuthenticationService();

  Future<SellReceiptModel> fetchReceipt(String transactionId) async {
    final data = await _authentication.authenticatedGet(
      '/gift-cards/sell/$transactionId',
    );
    final status = switch (data['status']?.toString().toUpperCase()) {
      'APPROVED' || 'PAID' => VerificationStatus.completed,
      'REJECTED' || 'FAILED' => VerificationStatus.rejected,
      'UNDER_REVIEW' => VerificationStatus.needsReview,
      _ => VerificationStatus.pending,
    };
    final amount = double.tryParse(data['cardAmount']?.toString() ?? '') ?? 0;
    final rate = double.tryParse(data['quotedRate']?.toString() ?? '') ?? 0;
    final providerPayout =
      double.tryParse(data['quotedPayoutAmount']?.toString() ?? '') ?? 0;
    final payoutCurrency = data['payoutCurrency']?.toString() ?? 'USD';
    final payout = ExchangeRateProvider.convertToUSD(providerPayout, payoutCurrency);

    return SellReceiptModel(
      referenceId: data['id']?.toString() ?? transactionId,
      giftCardName:
          data['brandName']?.toString() ??
          data['slug']?.toString() ??
          'Gift Card',
      region: data['cardCountry']?.toString() ?? '',
      cardsSubmitted: 1,
      totalFaceValue: amount,
      sellRate: rate,
      estimatedReceive: payout,
      status: status,
      submittedOn:
          data['createdAt']?.toString() ?? DateTime.now().toIso8601String(),
    );
  }
}
