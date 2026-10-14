import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:noble_cards/core/config/api_config.dart';
import 'package:noble_cards/main.dart' as app;
import 'package:noble_cards/screens/BottomNavigation/main_navigation_screen.dart';
import 'package:noble_cards/screens/authentication/login/login_screen.dart';
import 'package:noble_cards/screens/authentication/services/authentication_service.dart';
import 'package:noble_cards/screens/createPin/create_pin_screen.dart';
import 'package:noble_cards/screens/onboarding/onboarding_screen.dart';
import 'package:noble_cards/screens/profile/profile_screen.dart';
import 'package:noble_cards/screens/referral/models/referral_summary.dart';
import 'package:noble_cards/screens/referral/referral_screen.dart';
import 'package:noble_cards/screens/referral/services/referral_api_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Customer A and B see their own live referral data through the app',
    (tester) async {
      final config = await _loadSmokeConfig();
      await _assertBackendDatabaseIsTest(config.databaseUrl);
      await _assertBackendIsRunning();

      await app.main();
      await tester.pumpAndSettle();
      await _clearExistingFixtureSession(
        tester,
        fixtureUserIds: {config.customerAId, config.customerBId},
      );

      final customerASummary = await _signInAndOpenReferral(
        tester,
        email: config.customerAEmail,
        password: config.password,
        expectedUserId: config.customerAId,
      );
      _expectSummaryVisible(tester, customerASummary);
      final customerACode = customerASummary.code;
      final customerAHistoryNames = customerASummary.rewardHistory
          .map((reward) => reward.referredName)
          .where((name) => name.isNotEmpty)
          .toList(growable: false);

      await _refreshReferralScreen(tester);
      _expectSummaryVisible(tester, customerASummary);

      await _signOut(tester);

      final customerBSummary = await _signInAndOpenReferral(
        tester,
        email: config.customerBEmail,
        password: config.password,
        expectedUserId: config.customerBId,
      );
      _expectSummaryVisible(tester, customerBSummary);
      expect(customerBSummary.code, isNot(customerACode));
      expect(find.text(customerACode), findsNothing);
      expect(find.text(customerASummary.link), findsNothing);
      for (final name in customerAHistoryNames) {
        expect(find.text(name), findsNothing);
      }
      if (customerBSummary.rewardHistory.isEmpty) {
        expect(
          find.text('Your referral rewards will appear here.'),
          findsOneWidget,
        );
      }
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );
}

Future<_SmokeConfig> _loadSmokeConfig() async {
  final environment = Platform.environment;
  final password = environment['REFERRAL_SMOKE_PASSWORD'];
  if (password == null || password.isEmpty) {
    throw StateError(
      'Set REFERRAL_SMOKE_PASSWORD locally before running this integration test.',
    );
  }

  final manifestPath =
      environment['REFERRAL_SMOKE_MANIFEST'] ??
      '${environment['TEMP'] ?? environment['TMP'] ?? ''}'
          r'\noblecards-referral-smoke-fixtures.json';
  if (manifestPath.startsWith(r'\noblecards')) {
    throw StateError(
      'Set REFERRAL_SMOKE_MANIFEST or provide a valid TEMP directory.',
    );
  }

  final manifestFile = File(manifestPath);
  if (!await manifestFile.exists()) {
    throw StateError('Referral smoke fixture manifest was not found.');
  }

  final decoded = jsonDecode(await manifestFile.readAsString());
  if (decoded is! Map<String, dynamic> ||
      decoded['databaseName'] != 'noble_cards_test' ||
      decoded['users'] is! Map<String, dynamic>) {
    throw StateError('Referral smoke fixture manifest is invalid.');
  }

  final users = decoded['users'] as Map<String, dynamic>;
  final customerA = users['customerA'];
  final customerB = users['customerB'];
  if (customerA is! Map<String, dynamic> ||
      customerB is! Map<String, dynamic>) {
    throw StateError('Customer fixture entries are missing from the manifest.');
  }

  final customerAEmail = customerA['email'];
  final customerAId = customerA['id'];
  final customerBEmail = customerB['email'];
  final customerBId = customerB['id'];
  if (customerAEmail is! String ||
      customerAId is! String ||
      customerBEmail is! String ||
      customerBId is! String) {
    throw StateError('Customer fixture identifiers are invalid.');
  }

  final databaseUrl = environment['NOBLECARDS_TEST_DATABASE_URL'];
  if (databaseUrl == null || databaseUrl.isEmpty) {
    throw StateError(
      'Set NOBLECARDS_TEST_DATABASE_URL explicitly before running this test.',
    );
  }

  if (ApiConfig.baseUrl != 'http://127.0.0.1:3011') {
    throw StateError(
      'Run the integration test with API_BASE_URL=http://127.0.0.1:3011.',
    );
  }

  return _SmokeConfig(
    customerAEmail: customerAEmail,
    customerAId: customerAId,
    customerBEmail: customerBEmail,
    customerBId: customerBId,
    password: password,
    databaseUrl: databaseUrl,
  );
}

Future<void> _assertBackendDatabaseIsTest(String databaseUrl) async {
  final uri = Uri.tryParse(databaseUrl);
  if (uri == null ||
      Uri.decodeComponent(
            uri.pathSegments.isEmpty ? '' : uri.pathSegments.last,
          ) !=
          'noble_cards_test') {
    throw StateError(
      'Database checks are permitted only for noble_cards_test.',
    );
  }

  final backendPath = '${Directory.current.parent.path}\\noble_cards_backend';
  const queryScript = r'''
const { Client } = require('pg');
(async () => {
  const client = new Client({ connectionString: process.env.DATABASE_URL });
  try {
    await client.connect();
    const result = await client.query('SELECT current_database() AS name');
    process.stdout.write(result.rows[0]?.name ?? '');
  } finally {
    await client.end();
  }
})().catch(() => process.exit(2));
''';
  final result = await Process.run(
    'node',
    ['-e', queryScript],
    workingDirectory: backendPath,
    environment: {...Platform.environment, 'DATABASE_URL': databaseUrl},
  );
  if (result.exitCode != 0 ||
      (result.stdout as String).trim() != 'noble_cards_test') {
    throw StateError(
      'PostgreSQL safety check failed; no app or authentication flow was started.',
    );
  }
}

Future<void> _assertBackendIsRunning() async {
  final client = HttpClient();
  try {
    final request = await client.getUrl(
      Uri.parse('${ApiConfig.baseUrl}/referrals/me'),
    );
    final response = await request.close();
    await response.drain<void>();
    if (response.statusCode != HttpStatus.unauthorized) {
      throw StateError(
        'Expected the unauthenticated referral endpoint to return 401; '
        'received ${response.statusCode}.',
      );
    }
  } on SocketException {
    throw StateError('The backend is not reachable at ${ApiConfig.baseUrl}.');
  } finally {
    client.close(force: true);
  }
}

Future<void> _clearExistingFixtureSession(
  WidgetTester tester, {
  required Set<String> fixtureUserIds,
}) async {
  if (find.byType(MainNavigationScreen).evaluate().isEmpty) return;

  final userResponse = await AuthenticationService().authenticatedGet(
    '/users/me',
  );
  final user = userResponse['user'];
  if (user is! Map<String, dynamic> || !fixtureUserIds.contains(user['id'])) {
    throw StateError(
      'Refusing to sign out a session that does not belong to a smoke-test customer.',
    );
  }

  await _signOut(tester);
}

Future<ReferralSummary> _signInAndOpenReferral(
  WidgetTester tester, {
  required String email,
  required String password,
  required String expectedUserId,
}) async {
  if (find.byType(OnboardingScreen).evaluate().isNotEmpty) {
    while (find.text('Sign In').evaluate().isEmpty) {
      final nextButton = find.text('Next');
      expect(nextButton, findsOneWidget);
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('Sign In'));
    await _pumpUntil(
      tester,
      () => find.byType(LoginScreen).evaluate().isNotEmpty,
    );
  } else {
    await _pumpUntil(
      tester,
      () => find.byType(LoginScreen).evaluate().isNotEmpty,
    );
  }

  final fields = find.byType(TextFormField);
  expect(fields, findsNWidgets(2));
  await tester.enterText(fields.first, email);
  await tester.enterText(fields.last, password);
  await tester.tap(find.text('Log In'));
  await _pumpUntil(
    tester,
    () =>
        find.byType(MainNavigationScreen).evaluate().isNotEmpty ||
        find.byType(CreatePinScreen).evaluate().isNotEmpty,
    timeout: const Duration(seconds: 45),
  );

  if (find.byType(CreatePinScreen).evaluate().isNotEmpty) {
    for (final digit in '7391'.split('')) {
      await tester.tap(find.text(digit));
      await tester.pump();
    }
    await tester.tap(find.text('Continue'));
    await _pumpUntil(
      tester,
      () => find.text('PIN Created Successfully').evaluate().isNotEmpty,
    );
    await tester.tap(find.text('Done'));
  }

  await _pumpUntil(
    tester,
    () => find.byType(MainNavigationScreen).evaluate().isNotEmpty,
    timeout: const Duration(seconds: 30),
  );

  final authService = AuthenticationService();
  final userResponse = await authService.authenticatedGet('/users/me');
  final user = userResponse['user'];
  expect(user, isA<Map<String, dynamic>>());
  expect((user as Map<String, dynamic>)['id'], expectedUserId);
  final summary = await ReferralApiService(authService).getMyReferralSummary();

  final referralAction = find.text('Referral\nProgram');
  await tester.ensureVisible(referralAction);
  await tester.tap(referralAction);
  await _pumpUntil(
    tester,
    () =>
        find.byType(ReferralScreen).evaluate().isNotEmpty &&
        find.text(summary.code).evaluate().isNotEmpty &&
        find.text(summary.link).evaluate().isNotEmpty,
    timeout: const Duration(seconds: 45),
  );
  return summary;
}

void _expectSummaryVisible(WidgetTester tester, ReferralSummary summary) {
  expect(find.text(summary.code), findsOneWidget);
  expect(find.text(summary.link), findsOneWidget);
  expect(
    find.text('\$${summary.availableRewardUsd.toStringAsFixed(2)}'),
    findsWidgets,
  );
  expect(
    find.text(
      'Pending: \$${summary.pendingRewardUsd.toStringAsFixed(2)}  |  '
      'Held: \$${summary.heldRewardUsd.toStringAsFixed(2)}',
    ),
    findsOneWidget,
  );
  _expectStatValue(tester, 'Friends Invited', summary.invitedCount.toString());
  _expectStatValue(
    tester,
    'Qualified Friends',
    summary.qualifiedCount.toString(),
  );
  _expectStatValue(
    tester,
    'Rewards Earned',
    '\$${summary.totalEarnedUsd.toStringAsFixed(2)}',
  );
  expect(find.text('Available to buy gift cards'), findsOneWidget);
  expect(find.text('Not withdrawable'), findsOneWidget);

  for (final reward in summary.rewardHistory) {
    if (reward.referredName.isNotEmpty) {
      expect(find.text(reward.referredName), findsWidgets);
    }
    expect(
      find.text(reward.status.toLowerCase().replaceAll('_', ' ')),
      findsWidgets,
    );
    expect(find.text('\$${reward.amountUsd.toStringAsFixed(2)}'), findsWidgets);
  }

  if (summary.rewardHistory.isEmpty) {
    expect(
      find.text('Your referral rewards will appear here.'),
      findsOneWidget,
    );
  }
}

Future<void> _refreshReferralScreen(WidgetTester tester) async {
  final scrollable = find
      .descendant(
        of: find.byType(ReferralScreen),
        matching: find.byType(Scrollable),
      )
      .first;
  await tester.drag(scrollable, const Offset(0, 450));
  await tester.pump();
  await _pumpUntil(
    tester,
    () => find.byType(RefreshProgressIndicator).evaluate().isNotEmpty,
    timeout: const Duration(seconds: 5),
  );
  await _pumpUntil(
    tester,
    () => find.byType(RefreshProgressIndicator).evaluate().isEmpty,
    timeout: const Duration(seconds: 45),
  );
}

void _expectStatValue(WidgetTester tester, String title, String value) {
  final stat = find
      .ancestor(of: find.text(title), matching: find.byType(Column))
      .first;
  expect(find.descendant(of: stat, matching: find.text(value)), findsOneWidget);
}

Future<void> _signOut(WidgetTester tester) async {
  await tester.tap(find.text('Profile'));
  await _pumpUntil(
    tester,
    () => find.byType(ProfileScreen).evaluate().isNotEmpty,
  );
  await tester.ensureVisible(find.text('Logout'));
  await tester.tap(find.text('Logout'));
  await _pumpUntil(
    tester,
    () => find.byType(LoginScreen).evaluate().isNotEmpty,
  );
}

Future<void> _pumpUntil(
  WidgetTester tester,
  bool Function() condition, {
  Duration timeout = const Duration(seconds: 30),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (!condition() && DateTime.now().isBefore(deadline)) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  expect(condition(), isTrue, reason: 'Timed out waiting for the app UI.');
}

class _SmokeConfig {
  final String customerAEmail;
  final String customerAId;
  final String customerBEmail;
  final String customerBId;
  final String password;
  final String databaseUrl;

  const _SmokeConfig({
    required this.customerAEmail,
    required this.customerAId,
    required this.customerBEmail,
    required this.customerBId,
    required this.password,
    required this.databaseUrl,
  });
}
