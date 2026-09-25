import 'package:noble_cards/screens/authentication/services/authentication_service.dart';

import '../models/gift_card_region_model.dart';

class RegionService {
  final AuthenticationService _authentication;

  RegionService({AuthenticationService? authentication})
    : _authentication = authentication ?? AuthenticationService();

  Future<List<GiftCardRegionModel>> loadRegions() async {
    final response = await _authentication.authenticatedGet(
      '/gift-cards/buy/catalog',
    );
    return buildRegionsFromCatalog(response);
  }

  List<GiftCardRegionModel> buildRegionsFromCatalog(
    Map<String, dynamic> response,
  ) {
    final products = response['products'];
    if (products is! List) return const [];

    final byCountry = <String, GiftCardRegionModel>{};

    for (final product in products.whereType<Map>()) {
      final countryCode = (product['countryCode'] ?? product['country'] ?? 'US')
          .toString()
          .toUpperCase();
      final currencyCode = (product['currency'] ?? 'USD')
          .toString()
          .toUpperCase();
      final countryName = _countryName(countryCode);
      final denominations = product['denominations'] is List
          ? List<String>.from(
              (product['denominations'] as List).map(
                (value) => value.toString(),
              ),
            )
          : const <String>[];
      final rate =
          double.tryParse(
            product['customerRatePercent']?.toString() ??
                product['baseBuyRatePercent']?.toString() ??
                '0',
          ) ??
          0;

      byCountry.putIfAbsent(
        countryCode,
        () => GiftCardRegionModel(
          id: countryCode.toLowerCase(),
          countryName: countryName,
          countryCode: countryCode,
          flag: _flagForCountry(countryCode),
          currencyCode: currencyCode,
          currencySymbol: _currencySymbol(currencyCode),
          buyRate: rate,
          sellRate: rate,
          availableDenominations: denominations.isEmpty
              ? const ['50', '100', '250', '500']
              : denominations,
          isAvailable: true,
        ),
      );
    }

    return byCountry.values.toList();
  }

  String _countryName(String code) {
    const values = {
      'US': 'United States',
      'GB': 'United Kingdom',
      'CA': 'Canada',
      'NG': 'Nigeria',
      'GH': 'Ghana',
      'AU': 'Australia',
      'FR': 'France',
      'DE': 'Germany',
      'ZA': 'South Africa',
      'KE': 'Kenya',
    };
    return values[code] ?? code;
  }

  String _flagForCountry(String code) =>
      {
        'US': '🇺🇸',
        'GB': '🇬🇧',
        'CA': '🇨🇦',
        'NG': '🇳🇬',
        'GH': '🇬🇭',
        'AU': '🇦🇺',
        'FR': '🇫🇷',
        'DE': '🇩🇪',
        'ZA': '🇿🇦',
        'KE': '🇰🇪',
      }[code] ??
      '🌍';

  String _currencySymbol(String currency) =>
      {
        'USD': '\$',
        'GBP': '£',
        'CAD': 'C\$',
        'AUD': 'A\$',
        'EUR': '€',
        'NGN': '₦',
        'GHS': '₵',
        'CHF': 'CHF',
        'SEK': 'kr',
        'NOK': 'kr',
        'DKK': 'kr',
        'PLN': 'zł',
        'ZAR': 'R',
      }[currency] ??
      currency;
}
