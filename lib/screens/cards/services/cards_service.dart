import '../models/gift_card_model.dart';
import '../../authentication/services/authentication_service.dart';

class CardsService {
  final AuthenticationService _authentication;

  CardsService({AuthenticationService? authentication})
    : _authentication = authentication ?? AuthenticationService();

  Future<List<GiftCardModel>> fetchCards() async {
    final response = await _authentication.authenticatedGet(
      '/gift-cards/sell/catalog',
    );
    final products = response['data'];
    if (products is! List) return const [];

    return products.whereType<Map>().map((product) {
      final countries = product['countries'] is List
          ? product['countries'] as List
          : const [];
      final country = countries.whereType<Map>().isEmpty
          ? <String, dynamic>{}
          : countries.whereType<Map>().first;
      final name =
          product['name']?.toString() ??
          product['slug']?.toString() ??
          'Gift Card';

      return GiftCardModel(
        id: product['slug']?.toString() ?? name,
        name: name,
        logoUrl: product['logo_url']?.toString() ?? '',
        country:
            country['label']?.toString() ?? country['code']?.toString() ?? '',
        countryFlag: _flagForCountry(country['code']?.toString() ?? ''),
        category: product['category']?.toString() ?? 'Other',
        description: product['description']?.toString() ?? '',
        buyRate: 0,
        sellRate: 0,
        isAvailable: true,
        popularityRank: 0,
      );
    }).toList();
  }

  String _flagForCountry(String code) =>
      {
        'US': '🇺🇸',
        'GB': '🇬🇧',
        'CA': '🇨🇦',
        'AU': '🇦🇺',
        'DE': '🇩🇪',
      }[code.toUpperCase()] ??
      '🌍';
}
