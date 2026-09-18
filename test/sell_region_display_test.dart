import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:noble_cards/screens/cards/models/gift_card_region_model.dart';
import 'package:noble_cards/screens/cards/providers/region_provider.dart';
import 'package:noble_cards/screens/cards/widgets/region_bottom_sheet.dart';

void main() {
  testWidgets('Sell region cards display Sale and the real non-zero rate', (tester) async {
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
