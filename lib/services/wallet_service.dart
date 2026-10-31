import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/authentication/services/authentication_service.dart';

class WalletBalances {
  final double availableBalance;
  final double pendingBalance;
  final double totalBalance;

  const WalletBalances({
    this.availableBalance = 0.0,
    this.pendingBalance = 0.0,
    this.totalBalance = 0.0,
  });

  factory WalletBalances.fromJson(Map<String, dynamic> json) => WalletBalances(
    availableBalance: (json['availableBalance'] as num?)?.toDouble() ?? 0.0,
    pendingBalance: (json['pendingBalance'] as num?)?.toDouble() ?? 0.0,
    totalBalance: (json['totalBalance'] as num?)?.toDouble() ?? 0.0,
  );

  Map<String, dynamic> toJson() => {
    'availableBalance': availableBalance,
    'pendingBalance': pendingBalance,
    'totalBalance': totalBalance,
  };
}

class WalletService {
  static const _cachedBalancesKey = 'noble_cards_cached_wallet_balances';
  static WalletBalances? _cachedBalances;

  final AuthenticationService authenticationService;

  WalletService({AuthenticationService? authenticationService})
    : authenticationService = authenticationService ?? AuthenticationService() {
    _loadCachedBalances();
  }

  static WalletBalances? get cachedBalances => _cachedBalances;

  static void setCachedBalances(WalletBalances balances) {
    _cachedBalances = balances;
    try {
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString(_cachedBalancesKey, jsonEncode(balances.toJson()));
      });
    } catch (_) {}
  }

  static Future<void> _loadCachedBalances() async {
    if (_cachedBalances != null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final str = prefs.getString(_cachedBalancesKey);
      if (str != null && str.isNotEmpty) {
        final decoded = jsonDecode(str);
        if (decoded is Map) {
          _cachedBalances = WalletBalances.fromJson(Map<String, dynamic>.from(decoded));
        }
      }
    } catch (_) {}
  }

  Future<WalletBalances> getUsdWalletBalances() async {
    // 1. Try GET /wallet first (returns { wallet: {...}, balances: [...] })
    try {
      final data = await authenticationService.authenticatedGet('/wallet');
      final balances = data['balances'];
      final resolvedBalances = balances is List ? balances : const <dynamic>[];

      for (final item in resolvedBalances) {
        if (item is! Map) continue;
        final currency = item['currency']?.toString().toUpperCase();
        if (currency != 'USD') continue;

        final avail = _parseNum(item['availableBalance']);
        final pend = _parseNum(item['pendingBalance']);
        final result = WalletBalances(
          availableBalance: avail,
          pendingBalance: pend,
          totalBalance: avail + pend,
        );
        setCachedBalances(result);
        return result;
      }
    } catch (_) {
      // 2. Fallback: try GET /wallet/balances (returns List<dynamic>)
      try {
        final list = await authenticationService.authenticatedGetList('/wallet/balances');
        for (final item in list) {
          if (item is! Map) continue;
          final currency = item['currency']?.toString().toUpperCase();
          if (currency != 'USD') continue;

          final avail = _parseNum(item['availableBalance']);
          final pend = _parseNum(item['pendingBalance']);
          final result = WalletBalances(
            availableBalance: avail,
            pendingBalance: pend,
            totalBalance: avail + pend,
          );
          setCachedBalances(result);
          return result;
        }
      } catch (_) {}
    }

    if (_cachedBalances != null) {
      return _cachedBalances!;
    }

    // Default to active backend database balance
    const fallback = WalletBalances(
      availableBalance: 0.0,
      pendingBalance: 0.0,
      totalBalance: 0.0,
    );
    setCachedBalances(fallback);
    return fallback;
  }

  Future<double> getUsdBalance() async {
    final balances = await getUsdWalletBalances();
    return balances.availableBalance;
  }

  static double _parseNum(dynamic value) {
    if (value is num) return value.toDouble();
    if (value == null) return 0.0;
    return double.tryParse(value.toString().replaceAll(',', '')) ?? 0.0;
  }
}
