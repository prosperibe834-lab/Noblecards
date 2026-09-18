import 'package:flutter_test/flutter_test.dart';
import 'package:noble_cards/providers/exchange_rate_provider.dart';

void main() {
  test('converts provider payout currency to USD using loaded exchange rates', () {
    ExchangeRateProvider.setRates({'NGN': 1500, 'USD': 1});

    expect(ExchangeRateProvider.convertToUSD(150000, 'NGN'), 100);
  });

  test('keeps USD provider payouts unchanged', () {
    ExchangeRateProvider.setRates({'USD': 1});

    expect(ExchangeRateProvider.convertToUSD(100, 'USD'), 100);
  });
}