import '../screens/authentication/services/authentication_service.dart';

class WalletService {
  final AuthenticationService authenticationService;

  WalletService({AuthenticationService? authenticationService})
    : authenticationService = authenticationService ?? AuthenticationService();

  Future<double> getUsdBalance() async {
    final data = await authenticationService.authenticatedGet('/wallet');
    final payload = data;
    final balances = payload['balances'];
    final resolvedBalances = balances is List ? balances : const <dynamic>[];

    for (final item in resolvedBalances) {
      if (item is! Map) {
        continue;
      }
      final currency = item['currency']?.toString().toUpperCase();
      if (currency != 'USD') {
        continue;
      }

      final rawBalance = item['availableBalance'];
      if (rawBalance is num) {
        return rawBalance.toDouble();
      }
      final parsed = double.tryParse(rawBalance?.toString().replaceAll(',', '') ?? '');
      if (parsed != null) {
        return parsed;
      }
      throw FormatException('Wallet USD balance exists but is not numeric: $rawBalance');
    }

    throw StateError('Wallet response did not contain a USD balance. Response keys: ${payload.keys.toList()}');
  }
}
