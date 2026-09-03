import '../screens/authentication/services/authentication_service.dart';

class WalletService {
  final AuthenticationService authenticationService;

  WalletService({AuthenticationService? authenticationService})
      : authenticationService = authenticationService ?? AuthenticationService();

  Future<double> getUsdBalance() async {
    final data = await authenticationService.authenticatedGet('/wallet');
    final balances = data['balances'];
    if (balances is! List) return 0;

    for (final item in balances) {
      if (item is! Map) continue;
      final currency = item['currency']?.toString().toUpperCase();
      if (currency != 'USD') continue;

      final rawBalance = item['availableBalance'];
      if (rawBalance is num) return rawBalance.toDouble();
      return double.tryParse(rawBalance?.toString().replaceAll(',', '') ?? '') ?? 0;
    }

    return 0;
  }
}