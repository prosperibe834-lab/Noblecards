import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noble_cards/screens/home_screen.dart';
import 'package:noble_cards/screens/home/widgets/home_top_bar.dart';
import 'package:noble_cards/screens/home/widgets/home_greeting.dart';
import 'package:noble_cards/screens/home/widgets/home_wallet_card.dart';
import 'package:noble_cards/screens/home/widgets/home_action_buttons.dart';
import 'package:noble_cards/screens/home/widgets/home_featured_cards.dart';
import 'package:noble_cards/screens/home/widgets/home_quick_actions.dart';
import 'package:noble_cards/screens/home/widgets/home_todays_market.dart';
import 'package:noble_cards/localization/app_localizations.dart';

void main() {
  testWidgets('HomeScreen renders all sections in Light Mode with Dollar currency', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: const HomeScreen(),
      ),
    );

    await tester.pump();

    // Verify key components exist
    expect(find.byType(HomeTopBar), findsOneWidget);
    expect(find.byType(HomeGreeting), findsOneWidget);
    expect(find.byType(HomeWalletCard), findsOneWidget);
    expect(find.byType(HomeActionButtons), findsOneWidget);
    expect(find.byType(HomeFeaturedCards), findsOneWidget);
    expect(find.byType(HomeQuickActions), findsOneWidget);
    expect(find.byType(HomeTodaysMarket), findsOneWidget);

    // Verify brand text & Dollar base currency on HomeWalletCard (no Naira ₦)
    expect(find.text('NobleCards'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(HomeWalletCard),
        matching: find.textContaining(r'$'),
      ),
      findsWidgets,
    );
    expect(
      find.descendant(
        of: find.byType(HomeWalletCard),
        matching: find.textContaining('₦'),
      ),
      findsNothing,
    );
    expect(find.text('Buy Gift Cards'), findsWidgets);
    expect(find.text('Sell Gift Cards'), findsOneWidget);
  });

  testWidgets('HomeScreen renders all sections in Dark Mode', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: const HomeScreen(),
      ),
    );

    await tester.pump();

    expect(find.byType(HomeTopBar), findsOneWidget);
    expect(find.byType(HomeWalletCard), findsOneWidget);
    expect(find.text('NobleCards'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(HomeWalletCard),
        matching: find.textContaining('₦'),
      ),
      findsNothing,
    );
  });

  testWidgets('HomeGreeting prioritizes username over fullName', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: const Scaffold(
          body: HomeGreeting(userName: 'charlie_noble'),
        ),
      ),
    );

    await tester.pump();

    expect(find.textContaining('charlie_noble'), findsOneWidget);
  });

  testWidgets('HomeWalletCard displays dollar balances for main, available, and pending', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: const Scaffold(
          body: HomeWalletCard(
            mainBalance: r'$1,500.00',
            availableBalance: r'$1,200.00',
            pendingBalance: r'$300.00',
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text(r'$1,500.00'), findsOneWidget);
    expect(find.text(r'$1,200.00'), findsOneWidget);
    expect(find.text(r'$300.00'), findsOneWidget);
    expect(find.textContaining('₦'), findsNothing);
  });
}
