import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/config/api_config.dart';

class ExchangeRateProvider {
  static final Map<String, double> _rates = {};
  static bool _hasLoaded = false;

  static void setRates(Map<String, double> rates) {
    _rates.clear();
    _rates.addAll({
      for (final entry in rates.entries)
        entry.key.toUpperCase(): entry.value,
    });
    _hasLoaded = _rates.isNotEmpty;
  }

  static Future<void> loadRates() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/exchange-rates'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load exchange rates: ${response.statusCode}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final rawRates = data['rates'];
      if (rawRates is! Map) {
        throw Exception('Exchange rate payload is malformed.');
      }

      final normalized = <String, double>{};
      for (final entry in rawRates.entries) {
        final value = entry.value;
        if (value is num && value > 0) {
          normalized[entry.key.toString().toUpperCase()] = value.toDouble();
        }
      }

      if (normalized.isEmpty) {
        throw Exception('No valid exchange rates were returned by the backend.');
      }

      setRates(normalized);
    } catch (_) {
      _rates.clear();
      _hasLoaded = false;
    }
  }

  static double getRate(String currencyCode) {
    final normalized = currencyCode.toUpperCase();
    if (_rates.containsKey(normalized)) {
      return _rates[normalized]!;
    }
    return normalized == 'USD' ? 1.0 : 0.0;
  }

  static double getEffectiveRate(String currencyCode) {
    return getRate(currencyCode);
  }

  static double convertToUSD(double amount, String currencyCode) {
    if (amount <= 0) {
      return 0.0;
    }
    final rate = getRate(currencyCode);
    if (rate <= 0) {
      return 0.0;
    }
    return amount / rate;
  }

  static double convertFromUSD(double amountUSD, String currencyCode) {
    if (amountUSD <= 0) {
      return 0.0;
    }
    final rate = getRate(currencyCode);
    if (rate <= 0) {
      return 0.0;
    }
    return amountUSD * rate;
  }

  static double convertFromUSDWithDepositFees(
    double amountUSD,
    String currencyCode,
  ) {
    final baseAmount = convertFromUSD(amountUSD, currencyCode);
    if (baseAmount <= 0) {
      return 0.0;
    }

    final providerFee = double.parse((baseAmount * 0.02).toStringAsFixed(2));
    final nobleCardsFee = double.parse((baseAmount * 0.01).toStringAsFixed(2));
    return double.parse(
      (baseAmount + providerFee + nobleCardsFee).toStringAsFixed(2),
    );
  }

  static bool get hasLoaded => _hasLoaded;
}
