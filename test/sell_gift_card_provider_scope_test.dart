import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noble_cards/screens/cards/models/gift_card_model.dart';
import 'package:noble_cards/screens/cards/models/gift_card_region_model.dart';
import 'package:noble_cards/screens/cards/sell_gift_card_screen.dart';
import 'package:noble_cards/screens/cards/services/gift_card_sell_service.dart';
import 'package:noble_cards/screens/cards/widgets/gift_card_catalog_shimmer.dart';

class _NoNetworkSellService extends GiftCardSellService {
  @override
  Future<List<GiftCardRegionModel>> getRegionsForCard(
    String cardName, {
    String? cardSlug,
    String cardType = 'ecode',
    double cardAmount = 100,
  }) async => const [];
}

void main() {
  testWidgets('Sell screen and its State context are under RegionProvider', (
    tester,
  ) async {
    const region = GiftCardRegionModel(
      id: 'us',
      countryName: 'United States',
      countryCode: 'US',
      flag: '🇺🇸',
      currencyCode: 'USD',
      currencySymbol: r'$',
      buyRate: 0,
      sellRate: 0,
      availableDenominations: [],
      isAvailable: true,
    );
    const card = GiftCardModel(
      id: 'amazon',
      name: 'Amazon',
      logoUrl: '',
      country: 'United States',
      countryFlag: '🇺🇸',
      category: 'Shopping',
      description: '',
      buyRate: 0,
      sellRate: 0,
      currency: 'USD',
      minDenomination: '10',
      maxDenomination: '500',
      countryCode: 'US',
      cardTypes: ['ecode'],
      supportedRegions: [region],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: SellGiftCardScreen(
          card: card,
          sellService: _NoNetworkSellService(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Sell Gift Card'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('opening Sell with a desktop mouse does not throw', (
    tester,
  ) async {
    const region = GiftCardRegionModel(
      id: 'us',
      countryName: 'United States',
      countryCode: 'US',
      flag: '🇺🇸',
      currencyCode: 'USD',
      currencySymbol: r'$',
      buyRate: 0,
      sellRate: 0,
      availableDenominations: [],
      isAvailable: true,
    );
    const card = GiftCardModel(
      id: 'amazon',
      name: 'Amazon',
      logoUrl: '',
      country: 'United States',
      countryFlag: '🇺🇸',
      category: 'Shopping',
      description: '',
      buyRate: 0,
      sellRate: 0,
      currency: 'USD',
      minDenomination: '10',
      maxDenomination: '500',
      countryCode: 'US',
      cardTypes: ['ecode'],
      supportedRegions: [region],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => SellGiftCardScreen(
                        card: card,
                        sellService: _NoNetworkSellService(),
                      ),
                    ),
                  );
                },
                child: const Text('Open sale'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final target = tester.getCenter(find.text('Open sale'));
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: target);
    await mouse.moveTo(target);
    await tester.pump();
    await mouse.down(target);
    await tester.pump();
    await mouse.up();
    await tester.pumpAndSettle();

    expect(find.text('Sell Gift Card'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await mouse.removePointer();
  });

  testWidgets('Sell catalog loading shimmer works in its sliver host', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: GiftCardCatalogShimmer(isDark: false),
              ),
            ],
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
