import '../models/gift_card_model.dart';
import '../models/gift_card_region_model.dart';
import '../../authentication/services/authentication_service.dart';

class CardsService {
  final AuthenticationService _authentication;

  CardsService({AuthenticationService? authentication})
    : _authentication = authentication ?? AuthenticationService();

  Future<List<GiftCardModel>> fetchCards({String? countryCode}) async {
    final query = countryCode == null
        ? ''
        : '?country=${Uri.encodeQueryComponent(countryCode)}';
    final response = await _authentication.authenticatedGet(
      '/gift-cards/buy/catalog$query',
    );
    return parseCatalogResponse(response);
  }

  List<GiftCardModel> parseCatalogResponse(Map<String, dynamic> response) {
    final products = response['products'];
    if (products is! List) return const [];

    return products.whereType<Map>().map((product) {
      final id =
          product['productId']?.toString() ??
          product['providerProductId']?.toString() ??
          product['id']?.toString() ??
          'gift-card';
      final name =
          product['productName']?.toString() ??
          product['brandName']?.toString() ??
          'Gift Card';
      final countryCode = (product['countryCode'] ?? product['country'] ?? '')
          .toString()
          .toUpperCase();
      final countryName = countryCode.isEmpty ? '' : _countryName(countryCode);
      final currencyCode = (product['currency'] ?? 'USD')
          .toString()
          .toUpperCase();
      final rate =
          double.tryParse(
            product['customerRatePercent']?.toString() ??
                product['baseBuyRatePercent']?.toString() ??
                '0',
          ) ??
          0;
      final denominations = product['denominations'] is List
          ? (product['denominations'] as List)
                .map((value) => double.tryParse(value.toString()))
                .whereType<double>()
                .toList()
          : <double>[];
      final minimum =
          product['minimumAmount']?.toString() ??
          (denominations.isEmpty
              ? ''
              : denominations.reduce((a, b) => a < b ? a : b).toString());
      final maximum =
          product['maximumAmount']?.toString() ??
          (denominations.isEmpty
              ? ''
              : denominations.reduce((a, b) => a > b ? a : b).toString());
      final rawSupportedCountries = product['supportedCountries'] is List
          ? (product['supportedCountries'] as List).whereType<Map>().toList()
          : <Map>[];
      final supportedCountries =
          rawSupportedCountries.isEmpty && countryCode.isNotEmpty
          ? [
              {
                'countryCode': countryCode,
                'country': product['country'],
                'currency': currencyCode,
                'denominations': denominations,
                'minimumAmount': minimum,
                'maximumAmount': maximum,
                'customerRatePercent': rate,
              },
            ]
          : rawSupportedCountries;
      final supportedRegions = supportedCountries
          .map((country) {
            final code = (country['countryCode'] ?? country['code'] ?? '')
                .toString()
                .toUpperCase();
            if (code.isEmpty) return null;
            final currency = (country['currency'] ?? currencyCode)
                .toString()
                .toUpperCase();
            final countryDenominations = country['denominations'] is List
                ? (country['denominations'] as List)
                      .map((value) => value.toString())
                      .toList()
                : denominations.map((value) => value.toString()).toList();
            final countryRate =
                double.tryParse(
                  country['customerRatePercent']?.toString() ?? '',
                ) ??
                rate;
            final reportedCountryName =
                (country['countryName'] ??
                        country['label'] ??
                        country['country'])
                    ?.toString()
                    .trim();
            return GiftCardRegionModel(
              id: '$code-$currency'.toLowerCase(),
              countryName:
                  reportedCountryName != null &&
                      reportedCountryName.isNotEmpty &&
                      reportedCountryName.toUpperCase() != code
                  ? reportedCountryName
                  : _countryName(code),
              countryCode: code,
              flag: _flagForCountry(code),
              currencyCode: currency,
              currencySymbol: _currencySymbol(currency),
              buyRate: countryRate,
              sellRate: countryRate,
              availableDenominations: countryDenominations,
              isAvailable: true,
              minimumAmount: country['minimumAmount']?.toString() ?? minimum,
              maximumAmount: country['maximumAmount']?.toString() ?? maximum,
            );
          })
          .whereType<GiftCardRegionModel>()
          .toList();

      return GiftCardModel(
        id: id,
        name: name,
        logoUrl:
            product['logoUrl']?.toString() ??
            product['brandLogo']?.toString() ??
            '',
        country: countryName.isEmpty ? countryCode : countryName,
        countryFlag: _flagForCountry(countryCode),
        category:
            product['subcategory']?.toString() ??
            product['category']?.toString() ??
            product['brandName']?.toString() ??
            'Gift Card',
        description:
            product['description']?.toString() ?? '$currencyCode gift card',
        buyRate: rate,
        sellRate: rate,
        currency: currencyCode,
        minDenomination: minimum,
        maxDenomination: maximum,
        countryCode: countryCode.isEmpty ? null : countryCode,
        provider: product['provider']?.toString() ?? '',
        denominationType: product['denominationType']?.toString() ?? '',
        redemptionInstructions:
            product['redemptionInstructions']?.toString() ?? '',
        denominations: denominations.map((value) => value.toString()).toList(),
        supportedRegions: supportedRegions,
        productData: Map<String, dynamic>.from(product),
        isAvailable: true,
        isInstant: true,
        isTrending: false,
        isFavorite: false,
        popularityRank: 0,
      );
    }).toList();
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
    return values[code.toUpperCase()] ?? code.toUpperCase();
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
      }[code.toUpperCase()] ??
      '🌍';

  String _currencySymbol(String currency) =>
      {
        'USD': r'$',
        'GBP': '£',
        'CAD': r'C$',
        'AUD': r'A$',
        'EUR': '€',
        'NGN': '₦',
        'GHS': '₵',
        'ZAR': 'R',
        'JPY': '¥',
        'CHF': 'CHF',
        'SEK': 'kr',
        'NOK': 'kr',
        'DKK': 'kr',
        'NZD': r'NZ$',
        'PLN': 'zł',
        'TRY': '₺',
      }[currency] ??
      currency;
}
