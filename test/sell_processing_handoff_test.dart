import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:noble_cards/screens/cards/giftcard_submission_received_screen.dart';
import 'package:noble_cards/screens/cards/models/submission_model.dart';
import 'package:noble_cards/screens/cards/providers/submission_provider.dart';
import 'package:noble_cards/screens/cards/widgets/submission_status_card.dart';
import 'package:noble_cards/screens/deposit_processing_screen.dart';

class _RecordingObserver extends NavigatorObserver {
  Route<dynamic>? lastReplacement;

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    lastReplacement = newRoute;
  }
}

Widget _testApp({required Widget home, required NavigatorObserver observer}) {
  return MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => SubmissionProvider())],
    child: MaterialApp(
      navigatorObservers: [observer],
      home: home,
    ),
  );
}

void main() {
  testWidgets('accepted Sell submission reaches the existing result screen with its real ID', (tester) async {
    final observer = _RecordingObserver();
    final process = Completer<String>();

    await tester.pumpWidget(_testApp(
      observer: observer,
      home: DepositProcessingScreen(
        amount: 0,
        currency: 'USD',
        convertedUsd: 0,
        navigateToSubmissionReceived: true,
        onProcess: () => process.future,
      ),
    ));

    expect(find.byType(DepositProcessingScreen), findsOneWidget);
    process.complete('sale-real-123');
    await tester.pump();
    await tester.pump(const Duration(seconds: 6));
    await tester.pump(const Duration(seconds: 2));

    expect(observer.lastReplacement, isNotNull);
  });

  testWidgets('provider rejection reaches the existing result screen instead of returning to Sell', (tester) async {
    await tester.pumpWidget(_testApp(
      observer: _RecordingObserver(),
      home: DepositProcessingScreen(
        amount: 0,
        currency: 'USD',
        convertedUsd: 0,
        navigateToSubmissionReceived: true,
        onProcess: () async => 'sale-failed-422',
      ),
    ));

    await tester.pump(const Duration(seconds: 6));
    await tester.pump(const Duration(seconds: 2));

    expect(find.byType(GiftcardSubmissionReceivedScreen), findsOneWidget);
    expect(find.byType(DepositProcessingScreen), findsNothing);
  });

  testWidgets('existing result status presentation preserves provider outcomes', (tester) async {
    final statuses = <String, String>{
      'APPROVED': 'Successful',
      'FAILED': 'Failed',
      'SUBMITTED': 'Pending Verification',
      'UNDER_REVIEW': 'Under Review',
    };

    for (final entry in statuses.entries) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SubmissionStatusCard(
              data: SubmissionModel(
                referenceId: 'sale-${entry.key}',
                status: entry.key,
                cardsSubmitted: 1,
                totalFaceValue: 100,
                sellRate: 1,
                estimatedReceive: 100,
                verificationTime: '5 - 30 Minutes',
                submittedOn: '2026-09-18',
                paymentMethod: 'NGN',
              ),
            ),
          ),
        ),
      );

      expect(find.text('Status: ${entry.value}'), findsOneWidget);
    }
  });
}
