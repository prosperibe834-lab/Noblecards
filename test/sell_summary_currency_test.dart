import 'package:flutter_test/flutter_test.dart';
import 'package:noble_cards/providers/exchange_rate_provider.dart';

void main() {
  test('provider quote can be displayed in selected USD card currency', () {
    ExchangeRateProvider.setRates({'USD': 1, 'NGN': 1500});

    final usd = ExchangeRateProvider.convertFromUSD(
      ExchangeRateProvider.convertToUSD(150000, 'NGN'),
      'USD',
    );

    expect(usd, 100);
  });

  test('provider quote can be displayed in selected GBP card currency', () {
    ExchangeRateProvider.setRates({'USD': 1, 'NGN': 1500, 'GBP': 0.8});

    final gbp = ExchangeRateProvider.convertFromUSD(
      ExchangeRateProvider.convertToUSD(150000, 'NGN'),
      'GBP',
    );

    expect(gbp, 80);
  });
}