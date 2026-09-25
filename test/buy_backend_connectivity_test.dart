import 'package:flutter_test/flutter_test.dart';
import 'package:noble_cards/screens/cards/services/cards_service.dart';
import 'package:noble_cards/screens/cards/services/region_service.dart';

void main() {
  group('buy catalog integration', () {
    test('cards service maps back-end buy catalog product rows into the existing model', () {
      const payload = {
        'provider': 'TREMENDOUS',
        'products': [
          {
            'providerProductId': 'amazon-usa-100',
            'brandName': 'Amazon',
            'productName': 'Amazon USA',
            'countryCode': 'US',
            'currency': 'USD',
            'denominations': [100, 250],
            'price': 92.4,
            'customerRatePercent': '92.4',
            'customerPrice': '92.40',
          }
        ]
      };

      final cards = CardsService().parseCatalogResponse(payload);

      expect(cards, isNotEmpty);
      expect(cards.first.id, 'amazon-usa-100');
      expect(cards.first.name, 'Amazon USA');
      expect(cards.first.country, 'United States');
      expect(cards.first.buyRate, 92.4);
    });

    test('region service derives a country list from the buy catalog payload', () {
      const payload = {
        'products': [
          {
            'brandName': 'Amazon',
            'productName': 'Amazon USA',
            'countryCode': 'US',
            'currency': 'USD',
            'customerRatePercent': '92.40',
            'denominations': [50, 100],
          },
          {
            'brandName': 'Amazon',
            'productName': 'Amazon UK',
            'countryCode': 'GB',
            'currency': 'GBP',
            'customerRatePercent': '91.20',
            'denominations': [50, 100],
          },
        ]
      };

      final regions = RegionService().buildRegionsFromCatalog(payload);

      expect(regions.length, 2);
      expect(regions.first.countryCode, 'US');
      expect(regions.first.countryName, 'United States');
      expect(regions.last.countryCode, 'GB');
      expect(regions.last.countryName, 'United Kingdom');
    });
  });
}
