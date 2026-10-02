import 'package:noble_cards/screens/authentication/services/authentication_service.dart';

class BuyService {
  final AuthenticationService _authentication;

  BuyService({AuthenticationService? authentication})
    : _authentication = authentication ?? AuthenticationService();

  Future<Map<String, dynamic>> fetchQuote({
    required String productId,
    required String countryCode,
    required String currencyCode,
    required double amount,
    required int quantity,
  }) {
    return _authentication.authenticatedPost(
      '/gift-cards/buy/quote',
      body: {
        'productId': productId,
        'countryCode': countryCode,
        'currencyCode': currencyCode,
        'amount': amount,
        'quantity': quantity,
      },
    );
  }
}
