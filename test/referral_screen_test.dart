import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noble_cards/screens/authentication/services/authentication_service.dart';
import 'package:noble_cards/screens/referral/models/referral_summary.dart';
import 'package:noble_cards/screens/referral/referral_screen.dart';

ReferralSummary _summary({List<ReferralReward> rewards = const []}) =>
    ReferralSummary(
      code: 'AB12CD34',
      link: 'https://noblecards.com/ref/AB12CD34',
      invitedCount: 2,
      qualifiedCount: 1,
      pendingRewardUsd: 1.5,
      heldRewardUsd: 2,
      availableRewardUsd: 3,
      pendingRewardCount: 1,
      heldRewardCount: 1,
      rewardHistory: rewards,
    );

void main() {
  testWidgets('shows loading state until the referral request completes', (
    tester,
  ) async {
    final completer = Completer<ReferralSummary>();
    await tester.pumpWidget(
      MaterialApp(
        home: ReferralScreen(loadReferralSummary: () => completer.future),
      ),
    );

    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('AB12CD34'), findsNothing);

    completer.complete(_summary());
    await tester.pumpAndSettle();

    expect(find.text('AB12CD34'), findsOneWidget);
  });

  testWidgets('shows an API error and retries successfully', (tester) async {
    var attempts = 0;
    Future<ReferralSummary> load() async {
      attempts++;
      if (attempts == 1) throw Exception('Temporary network failure');
      return _summary();
    }

    await tester.pumpWidget(
      MaterialApp(home: ReferralScreen(loadReferralSummary: load)),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Failed to load referral data'), findsOneWidget);
    await tester.tap(find.text('Try Again'));
    await tester.pumpAndSettle();

    expect(attempts, 2);
    expect(find.text('AB12CD34'), findsOneWidget);
  });

  testWidgets('renders available, pending, and held reward states distinctly', (
    tester,
  ) async {
    final rewards = [
      ReferralReward(
        id: 'pending-1',
        referredName: 'Pending Friend',
        amountUsd: 1.5,
        status: 'PENDING',
      ),
      ReferralReward(
        id: 'held-1',
        referredName: 'Held Friend',
        amountUsd: 2,
        status: 'HELD',
      ),
      ReferralReward(
        id: 'available-1',
        referredName: 'Available Friend',
        amountUsd: 3,
        status: 'AVAILABLE',
      ),
    ];
    await tester.pumpWidget(
      MaterialApp(
        home: ReferralScreen(
          loadReferralSummary: () async => _summary(rewards: rewards),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(r'$3.00'), findsWidgets);
    expect(find.textContaining(r'Pending: $1.50'), findsOneWidget);
    expect(find.textContaining(r'Held: $2.00'), findsOneWidget);
    expect(find.text('pending'), findsOneWidget);
    expect(find.text('held'), findsOneWidget);
    expect(find.text('available'), findsOneWidget);
    expect(find.text('Pending Friend'), findsOneWidget);
    expect(find.text('Held Friend'), findsOneWidget);
    expect(find.text('Available Friend'), findsOneWidget);
  });

  testWidgets('shows a distinct message for an expired authenticated session', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ReferralScreen(
          loadReferralSummary: () async =>
              throw const AuthenticationExpiredException(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('session has expired'), findsOneWidget);
  });
}
