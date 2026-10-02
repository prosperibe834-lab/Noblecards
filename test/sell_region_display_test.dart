import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noble_cards/screens/authentication/services/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:noble_cards/screens/cards/services/gift_card_sell_service.dart';
import 'package:noble_cards/screens/cards/models/gift_card_region_model.dart';
import 'package:noble_cards/screens/cards/providers/region_provider.dart';
import 'package:noble_cards/screens/cards/widgets/region_bottom_sheet.dart';

class _CatalogAuthenticationService extends AuthenticationService {
  @override
  Future<Map<String, dynamic>> authenticatedGet(String path) async {
    if (path == '/gift-cards/sell/catalog') {
      return {
        'data': [
          {
            'slug': 'amazon',
            'name': 'Amazon',
            'countries': [
              {'code': 'US', 'currency': 'USD', 'label': 'United States'},
              {'code': 'NG', 'currency': 'NGN', 'label': 'Nigeria'},
            ],
            'card_types': ['ecode', 'physical'],
            'min_amount': 25,
            'max_amount': 500,
          },
          {
            'slug': 'amazon-uk',
            'name': 'Amazon UK',
            'countries': [
              {'code': 'GB', 'currency': 'GBP', 'label': 'United Kingdom'},
            ],
            'card_types': ['ecode'],
            'min_amount': 10,
            'max_amount': 250,
          },
        ],
      };
    }
    if (path == '/gift-cards/sell/rates') {
      return {
        'data': [
          {'slug': 'amazon', 'rates': {}},
          {'slug': 'amazon-uk', 'rates': {}},
        ],
      };
    }
    throw StateError('Unexpected catalog request: $path');
  }
}

void main() {
  test(
    'Sell card model retains its own supported countries and slug identity',
    () async {
      final service = GiftCardSellService(
        authentication: _CatalogAuthenticationService(),
      );

      final cards = await service.getCatalogCards();
      final selected = cards.firstWhere((card) => card.id == 'amazon');
      final selectedRegions = await service.getRegionsForCard(
        'Amazon UK',
        cardSlug: selected.id,
      );

      expect(selected.name, 'Amazon');
      expect(selected.cardTypes, ['ecode', 'physical']);
      expect(selected.minDenomination, '25');
      expect(selected.maxDenomination, '500');
      expect(selected.supportedRegions.map((region) => region.countryCode), [
        'US',
        'NG',
      ]);
      expect(selectedRegions.map((region) => region.countryCode), ['US', 'NG']);
    },
  );

  testWidgets('Sell region cards display Sale and the real non-zero rate', (
    tester,
  ) async {
    final provider = RegionProvider(loadInitialRegions: false);
    provider.replaceRegions([
      const GiftCardRegionModel(
        id: 'au',
        countryName: 'Australia (AUD)',
        countryCode: 'AU',
        flag: '🇦🇺',
        currencyCode: 'AUD',
        currencySymbol: r'A$',
        buyRate: 0,
        sellRate: 93.2,
        availableDenominations: [],
        isAvailable: true,
      ),
    ]);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: provider,
          child: const Scaffold(body: RegionBottomSheet()),
        ),
      ),
    );

    expect(find.text('🇦🇺'), findsOneWidget);
    expect(find.text('Sale 93.20%'), findsOneWidget);
    expect(find.textContaining('Buy '), findsNothing);
  });
}
