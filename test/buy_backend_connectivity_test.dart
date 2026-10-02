import 'package:flutter_test/flutter_test.dart';
import 'package:noble_cards/screens/cards/models/gift_card_model.dart';
import 'package:noble_cards/screens/cards/models/gift_card_region_model.dart';
import 'package:noble_cards/screens/cards/providers/buy_provider.dart';
import 'package:noble_cards/screens/cards/services/buy_service.dart';
import 'package:noble_cards/screens/cards/services/cards_service.dart';
import 'package:noble_cards/screens/cards/services/region_service.dart';

class _RecordingBuyService extends BuyService {
  final requests = <Map<String, Object>>[];

  @override
  Future<Map<String, dynamic>> fetchQuote({
    required String productId,
    required String countryCode,
    required String currencyCode,
    required double amount,
    required int quantity,
  }) async {
    requests.add({
      'productId': productId,
      'countryCode': countryCode,
      'currencyCode': currencyCode,
      'amount': amount,
      'quantity': quantity,
    });
    return {
      'customerRatePercent': '83',
      'customerPrice': (amount * quantity * 0.83).toStringAsFixed(2),
    };
  }
}

void main() {
  group('buy catalog integration', () {
    test(
      'cards service maps back-end buy catalog product rows into the existing model',
      () {
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
            },
          ],
        };

        final cards = CardsService().parseCatalogResponse(payload);

        expect(cards, isNotEmpty);
        expect(cards.first.id, 'amazon-usa-100');
        expect(cards.first.name, 'Amazon USA');
        expect(cards.first.country, 'United States');
        expect(cards.first.buyRate, 92.4);
      },
    );

    test(
      'region service derives a country list from the buy catalog payload',
      () {
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
          ],
        };

        final regions = RegionService().buildRegionsFromCatalog(payload);

        expect(regions.length, 2);
        expect(regions.first.countryCode, 'US');
        expect(regions.first.countryName, 'United States');
        expect(regions.last.countryCode, 'GB');
        expect(regions.last.countryName, 'United Kingdom');
      },
    );

    test('selected Buy product retains its own country variants and data', () {
      const payload = {
        'provider': 'TREMENDOUS',
        'products': [
          {
            'productId': 'shared-amazon-id',
            'productName': 'Amazon US',
            'provider': 'TREMENDOUS',
            'countryCode': 'US',
            'country': 'US',
            'currency': 'USD',
            'denominationType': 'FIXED',
            'minimumAmount': '25',
            'maximumAmount': '250',
            'denominations': [50, 100],
            'customerRatePercent': '92.4',
            'supportedCountries': [
              {
                'countryCode': 'US',
                'country': 'US',
                'currency': 'USD',
                'denominations': [50, 100],
                'minimumAmount': '25',
                'maximumAmount': '250',
                'customerRatePercent': '92.4',
              },
              {
                'countryCode': 'GB',
                'country': 'GB',
                'currency': 'GBP',
                'denominations': [20, 50],
                'minimumAmount': '10',
                'maximumAmount': '200',
                'customerRatePercent': '91.2',
              },
            ],
          },
          {
            'productId': 'shared-amazon-id',
            'productName': 'Amazon GB',
            'provider': 'TREMENDOUS',
            'countryCode': 'GB',
            'country': 'GB',
            'currency': 'GBP',
            'denominations': [20, 50],
            'customerRatePercent': '91.2',
            'supportedCountries': [
              {
                'countryCode': 'US',
                'country': 'US',
                'currency': 'USD',
                'denominations': [50, 100],
                'minimumAmount': '25',
                'maximumAmount': '250',
                'customerRatePercent': '92.4',
              },
              {
                'countryCode': 'GB',
                'country': 'GB',
                'currency': 'GBP',
                'denominations': [20, 50],
                'minimumAmount': '10',
                'maximumAmount': '200',
                'customerRatePercent': '91.2',
              },
            ],
          },
        ],
      };

      final cards = CardsService().parseCatalogResponse(payload);
      final selected = cards.firstWhere((card) => card.countryCode == 'GB');
      final provider = BuyProvider(card: selected, loadQuote: false);

      expect(cards, hasLength(2));
      expect(cards[0].id, cards[1].id);
      expect(cards[0].catalogKey, isNot(cards[1].catalogKey));
      expect(selected.name, 'Amazon GB');
      expect(selected.provider, 'TREMENDOUS');
      expect(selected.currency, 'GBP');
      expect(selected.denominations, ['20', '50']);
      expect(selected.supportedRegions.map((region) => region.countryCode), [
        'US',
        'GB',
      ]);
      expect(provider.selectedRegion?.countryCode, 'GB');
      expect(provider.currencyCode, 'GBP');
      expect(provider.currentRate, 91.2);
      expect(provider.amount, 20);
    });

    test(
      'Buy quotes use the selected product and country currency variant',
      () async {
        const germany = GiftCardRegionModel(
          id: 'de-eur',
          countryName: 'Germany',
          countryCode: 'DE',
          flag: '🇩🇪',
          currencyCode: 'EUR',
          currencySymbol: '€',
          buyRate: 80,
          sellRate: 0,
          availableDenominations: ['15', '25'],
          minimumAmount: '15',
          maximumAmount: '100',
          isAvailable: true,
        );
        final card = GiftCardModel(
          id: 'google-play-de',
          name: 'Google Play Germany',
          logoUrl: '',
          country: 'Germany',
          countryFlag: '🇩🇪',
          category: 'Gaming',
          description: 'EUR gift card',
          buyRate: 80,
          sellRate: 0,
          currency: 'EUR',
          minDenomination: '15',
          maxDenomination: '100',
          countryCode: 'DE',
          denominations: const ['15', '25'],
          supportedRegions: const [germany],
        );
        final service = _RecordingBuyService();
        final provider = BuyProvider(
          card: card,
          service: service,
          loadQuote: false,
        );

        await provider.refreshQuote();

        expect(service.requests, [
          {
            'productId': 'google-play-de',
            'countryCode': 'DE',
            'currencyCode': 'EUR',
            'amount': 15,
            'quantity': 1,
          },
        ]);
        expect(provider.currencyCode, 'EUR');
        expect(provider.availableDenominations, ['15', '25']);
        expect(provider.totalToPay, 12.45);

        const unitedKingdom = GiftCardRegionModel(
          id: 'gb-gbp',
          countryName: 'United Kingdom',
          countryCode: 'GB',
          flag: '🇬🇧',
          currencyCode: 'GBP',
          currencySymbol: '£',
          buyRate: 82,
          sellRate: 0,
          availableDenominations: ['25', '40'],
          minimumAmount: '25',
          maximumAmount: '100',
          isAvailable: true,
        );
        final secondProduct = GiftCardModel(
          id: 'amazon-uk',
          name: 'Amazon United Kingdom',
          logoUrl: '',
          country: 'United Kingdom',
          countryFlag: '🇬🇧',
          category: 'Shopping',
          description: 'GBP gift card',
          buyRate: 82,
          sellRate: 0,
          currency: 'GBP',
          minDenomination: '25',
          maxDenomination: '100',
          countryCode: 'GB',
          denominations: const ['25', '40'],
          supportedRegions: const [unitedKingdom],
        );
        final secondProvider = BuyProvider(
          card: secondProduct,
          service: service,
          loadQuote: false,
        );
        await secondProvider.refreshQuote();

        expect(service.requests.last, {
          'productId': 'amazon-uk',
          'countryCode': 'GB',
          'currencyCode': 'GBP',
          'amount': 25,
          'quantity': 1,
        });
        expect(secondProvider.currencyCode, 'GBP');
        expect(secondProvider.currencySymbol, '£');
        expect(secondProvider.availableDenominations, ['25', '40']);
        expect(secondProvider.totalToPay, 20.75);
      },
    );
  });
}
