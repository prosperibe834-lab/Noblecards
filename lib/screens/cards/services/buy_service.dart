import 'package:noble_cards/screens/authentication/services/authentication_service.dart';

class BuyService {
  final AuthenticationService _authentication;

  BuyService({AuthenticationService? authentication})
    : _authentication = authentication ?? AuthenticationService();

  Future<double> fetchCurrentRate() async {
    final response = await _authentication.authenticatedGet('/gift-cards/buy/catalog');
    final products = response['products'];
    if (products is! List || products.isEmpty) return 93.20;

    final first = products.firstWhere(
      (item) => item is Map,
      orElse: () => <String, dynamic>{},
    );
    if (first is! Map) return 93.20;
    final value = first['customerRatePercent']?.toString() ??
        first['baseBuyRatePercent']?.toString() ??
        '93.20';
    return double.tryParse(value) ?? 93.20;
  }
}
