import '../models/submission_model.dart';
import '../../authentication/services/authentication_service.dart';
import '../../../providers/exchange_rate_provider.dart';

class SubmissionService {
  Future<SubmissionModel> fetchSubmissionDetails(String transactionId) async {
    final response = await AuthenticationService().authenticatedGet(
      '/gift-cards/sell/$transactionId',
    );
    final amount = double.tryParse(response['cardAmount']?.toString() ?? '') ?? 0;
    final rate = double.tryParse(response['quotedRate']?.toString() ?? '') ?? 0;
    final providerPayout = double.tryParse(response['quotedPayoutAmount']?.toString() ?? '') ?? 0;
    final payoutCurrency = response['payoutCurrency']?.toString() ?? 'USD';
    final payout = ExchangeRateProvider.convertToUSD(providerPayout, payoutCurrency);

    return SubmissionModel(
      referenceId: response['id']?.toString() ?? transactionId,
      status: response['status']?.toString() ?? 'SUBMITTED',
      providerMessage: response['providerMessage']?.toString(),
      cardsSubmitted: 1,
      totalFaceValue: amount,
      sellRate: rate,
      estimatedReceive: payout,
      verificationTime: '5 - 30 Minutes',
      submittedOn: response['createdAt']?.toString() ?? '',
      paymentMethod: 'USD Wallet',
    );
  }
}
