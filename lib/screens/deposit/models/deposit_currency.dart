// Location: lib/deposit/models/deposit_currency.dart
class DepositCurrency {
  final String code;
  final String symbol;
  final String name;
  final String flagAsset;
  final double exchangeRateToBase;
  final bool isPopular;
  final String country;
  final String region;

  const DepositCurrency({
    required this.code,
    required this.symbol,
    required this.name,
    required this.flagAsset,
    required this.exchangeRateToBase,
    this.isPopular = false,
    required this.country,
    required this.region,
  });
}

// Expanded list matching the reference image and requirements
final List<DepositCurrency> supportedCurrencies = [
  const DepositCurrency(
      code: 'NGN', symbol: '₦', name: 'Nigerian Naira', flagAsset: '🇳🇬', exchangeRateToBase: 1650.0, isPopular: true, country: 'Nigeria', region: 'Africa'),
  const DepositCurrency(
      code: 'USD', symbol: '\$', name: 'United States Dollar', flagAsset: '🇺🇸', exchangeRateToBase: 1.0, isPopular: true, country: 'United States', region: 'North America'),
  const DepositCurrency(
      code: 'GBP', symbol: '£', name: 'British Pound Sterling', flagAsset: '🇬🇧', exchangeRateToBase: 0.79, isPopular: true, country: 'United Kingdom', region: 'Europe'),
  const DepositCurrency(
      code: 'CAD', symbol: 'C\$', name: 'Canadian Dollar', flagAsset: '🇨🇦', exchangeRateToBase: 1.36, isPopular: true, country: 'Canada', region: 'North America'),
  const DepositCurrency(
      code: 'AUD', symbol: 'A\$', name: 'Australian Dollar', flagAsset: '🇦🇺', exchangeRateToBase: 1.52, isPopular: false, country: 'Australia', region: 'Asia-Pacific'),
  const DepositCurrency(
      code: 'GHS', symbol: 'GH₵', name: 'Ghanaian Cedi', flagAsset: '🇬🇭', exchangeRateToBase: 12.5, isPopular: false, country: 'Ghana', region: 'Africa'),
];
