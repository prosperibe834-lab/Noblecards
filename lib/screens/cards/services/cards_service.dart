import '../models/gift_card_model.dart';
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
      final countryCode = (product['countryCode'] ?? product['country'] ?? 'US')
          .toString();
      final countryName = _countryName(countryCode);
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

      return GiftCardModel(
        id: id,
        name: name,
        logoUrl:
            product['logoUrl']?.toString() ??
            product['brandLogo']?.toString() ??
            '',
        country: countryName,
        countryFlag: _flagForCountry(countryCode),
        category: product['brandName']?.toString() ?? 'Gift Card',
        description:
            product['description']?.toString() ?? '$currencyCode gift card',
        buyRate: rate,
        sellRate: rate,
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
}
