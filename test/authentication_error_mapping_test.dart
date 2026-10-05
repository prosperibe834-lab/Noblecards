import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:noble_cards/screens/authentication/services/authentication_service.dart';

void main() {
  final authentication = AuthenticationService();

  test('authentication verification errors use the verification message', () {
    expect(
      authentication.mapErrorMessage(
        'Invalid or expired verification code.',
        path: '/auth/verify-email',
      ),
      'The verification code is invalid or expired. Please request a new one.',
    );
  });

  test('PIN errors are not classified as email verification errors', () {
    expect(
      authentication.mapErrorMessage(
        'Invalid transaction PIN.',
        path: '/users/me/transaction-pin/verify',
      ),
      'Invalid transaction PIN.',
    );
  });

  test('transaction PIN conflicts are not classified as registration errors', () {
    expect(
      authentication.mapErrorMessage(
        'A transaction PIN already exists.',
        path: '/users/me/transaction-pin',
      ),
      'A transaction PIN already exists.',
    );
  });

  test('registration conflicts keep the account-specific message', () {
    expect(
      authentication.mapErrorMessage(
        'An account with this email already exists.',
        path: '/auth/register',
      ),
      'An account with this email already exists. Please log in or use a different email.',
    );
  });

  for (final pins in [
    ('1234', '5678'),
    ('0123', '0456'),
  ]) {
    test('PIN update serializes ${pins.$1} and ${pins.$2} as JSON strings', () async {
      final requests = <http.Request>[];
      final client = MockClient((request) async {
        requests.add(request);
        return http.Response(
          '{"updated":true,"hasTransactionPin":true}',
          200,
          headers: {'content-type': 'application/json'},
        );
      });
      final service = AuthenticationService(httpClient: client);

      await service.updateTransactionPin(
        currentPin: pins.$1,
        newPin: pins.$2,
      );

      expect(requests, hasLength(1));
      expect(requests.single.method, 'POST');
      expect(requests.single.url.path, '/users/me/transaction-pin');
      expect(requests.single.body, jsonEncode({
        'currentPin': pins.$1,
        'newPin': pins.$2,
      }));
      final body = jsonDecode(requests.single.body) as Map<String, dynamic>;
      expect(body['currentPin'], isA<String>());
      expect(body['newPin'], isA<String>());
      expect(body, {
        'currentPin': pins.$1,
        'newPin': pins.$2,
      });
      expect(requests.single.url.path, isNot('/auth/register'));
      client.close();
    });
  }

  test('authenticated password change posts current and new passwords', () async {
    final requests = <http.Request>[];
    final client = MockClient((request) async {
      requests.add(request);
      return http.Response(
        '{"updated":true}',
        200,
        headers: {'content-type': 'application/json'},
      );
    });
    final service = AuthenticationService(httpClient: client);

    await service.changeAuthenticatedPassword(
      currentPassword: 'Current@123',
      newPassword: 'Updated@456',
    );

    expect(requests, hasLength(1));
    expect(requests.single.method, 'POST');
    expect(requests.single.url.path, '/auth/change-password');
    expect(jsonDecode(requests.single.body), {
      'currentPassword': 'Current@123',
      'newPassword': 'Updated@456',
    });
    client.close();
  });

  test('Sogo redemption errors containing code are preserved', () {
    const message = 'The redemption code provided does not appear to be valid.';
    expect(
      authentication.mapErrorMessage(message, path: '/gift-cards/sell'),
      message,
    );
  });
}