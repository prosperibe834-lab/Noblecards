import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:noble_cards/screens/authentication/services/authentication_service.dart';
import 'package:noble_cards/screens/referral/services/referral_api_service.dart';

class _FakeAuthenticationService extends AuthenticationService {
  final Map<String, dynamic> response;
  String? requestedPath;

  _FakeAuthenticationService(this.response);

  @override
  Future<Map<String, dynamic>> authenticatedGet(String path) async {
    requestedPath = path;
    return response;
  }
}

Map<String, dynamic> _summaryJson({
  int invitedCount = 2,
  int qualifiedCount = 1,
  String pendingRewardUsd = '1.50',
  String heldRewardUsd = '2.00',
  String availableRewardUsd = '3.00',
  List<Map<String, dynamic>> rewardHistory = const [],
}) => {
  'code': 'AB12CD34',
  'link': 'https://noblecards.com/ref/AB12CD34',
  'invitedCount': invitedCount,
  'qualifiedCount': qualifiedCount,
  'pendingRewardUsd': pendingRewardUsd,
  'heldRewardUsd': heldRewardUsd,
  'availableRewardUsd': availableRewardUsd,
  'pendingRewardCount': 1,
  'heldRewardCount': 1,
  'rewardHistory': rewardHistory,
};

void main() {
  test(
    'loads and parses the authenticated referral summary endpoint',
    () async {
      final authentication = _FakeAuthenticationService(_summaryJson());
      final service = ReferralApiService(authentication);

      final summary = await service.getMyReferralSummary();

      expect(authentication.requestedPath, '/referrals/me');
      expect(summary.code, 'AB12CD34');
      expect(summary.link, 'https://noblecards.com/ref/AB12CD34');
      expect(summary.invitedCount, 2);
      expect(summary.qualifiedCount, 1);
      expect(summary.pendingRewardUsd, 1.5);
      expect(summary.heldRewardUsd, 2);
      expect(summary.availableRewardUsd, 3);
    },
  );

  test(
    'accepts a valid empty referral summary without inventing values',
    () async {
      final authentication = _FakeAuthenticationService(
        _summaryJson(
          invitedCount: 0,
          qualifiedCount: 0,
          pendingRewardUsd: '0',
          heldRewardUsd: '0',
          availableRewardUsd: '0',
          rewardHistory: const [],
        ),
      );
      final summary = await ReferralApiService(
        authentication,
      ).getMyReferralSummary();

      expect(summary.invitedCount, 0);
      expect(summary.qualifiedCount, 0);
      expect(summary.availableRewardUsd, 0);
      expect(summary.rewardHistory, isEmpty);
      expect(summary.totalEarnedUsd, 0);
    },
  );

  test('maps a rejected session to a typed authentication error', () async {
    final client = MockClient((request) async {
      expect(request.method, 'GET');
      expect(request.url.path, '/referrals/me');
      return http.Response(
        jsonEncode({'message': 'Unauthorized'}),
        401,
        headers: {'content-type': 'application/json'},
      );
    });
    final service = ReferralApiService(
      AuthenticationService(httpClient: client),
    );

    await expectLater(
      service.getMyReferralSummary(),
      throwsA(isA<AuthenticationExpiredException>()),
    );
    client.close();
  });
}
