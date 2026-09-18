import 'package:flutter_test/flutter_test.dart';
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

  test('Sogo redemption errors containing code are preserved', () {
    const message = 'The redemption code provided does not appear to be valid.';
    expect(
      authentication.mapErrorMessage(message, path: '/gift-cards/sell'),
      message,
    );
  });
}