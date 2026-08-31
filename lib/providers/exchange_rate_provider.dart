import 'dart:async';

/// Exchange rate provider for currency conversion
/// Currently uses placeholder rates; can be replaced with backend API
class ExchangeRateProvider {
  static const Map<String, double> _defaultRates = {
    'NGN': 1640.00, // 1 USD = 1640 NGN
    'GBP': 0.79,    // 1 USD = 0.79 GBP
    'EUR': 0.92,    // 1 USD = 0.92 EUR
    'CAD': 1.36,    // 1 USD = 1.36 CAD
  };

  /// Get exchange rate for currency to USD
  /// TODO: Fetch from backend API endpoint when available
  /// Expected endpoint: GET /exchange-rates/{currencyCode}
  static double getRate(String currencyCode) {
    return _defaultRates[currencyCode] ?? 1.0;
  }

  /// Convert amount from specified currency to USD
  /// Returns 0 if amount is invalid
  static double convertToUSD(double amount, String currencyCode) {
    if (amount <= 0 || !_defaultRates.containsKey(currencyCode)) {
      return 0.0;
    }
    return amount / getRate(currencyCode);
  }

  /// Convert amount from USD to specified currency
  static double convertFromUSD(double amountUSD, String currencyCode) {
    if (amountUSD <= 0 || !_defaultRates.containsKey(currencyCode)) {
      return 0.0;
    }
    return amountUSD * getRate(currencyCode);
  }
}
