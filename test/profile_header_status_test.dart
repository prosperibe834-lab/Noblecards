import 'package:flutter_test/flutter_test.dart';
import 'package:noble_cards/screens/authentication/services/authentication_service.dart';
import 'package:noble_cards/screens/profile/widgets/profile_header.dart';

void main() {
  AuthUser user({required bool complete, required bool verified}) =>
      AuthUser.fromJson({
        'id': 'test-user',
        'email': 'test@example.com',
        'firstName': 'Test',
        'lastName': 'User',
        'isProfileComplete': complete,
        'isVerified': verified,
      });

  test(
    'complete but unverified profile is not labelled incomplete or verified',
    () {
      final profile = user(complete: true, verified: false);

      expect(profileHeaderStatusText(profile), 'Profile complete');
      expect(profileHeaderShowsVerifiedBadge(profile), isFalse);
    },
  );

  test(
    'verified badge and label follow only the backend verification flag',
    () {
      final profile = user(complete: true, verified: true);

      expect(profileHeaderStatusText(profile), 'Noble Verified');
      expect(profileHeaderShowsVerifiedBadge(profile), isTrue);
    },
  );

  test('incomplete profile remains incomplete when unverified', () {
    final profile = user(complete: false, verified: false);

    expect(profileHeaderStatusText(profile), 'Profile incomplete');
    expect(profileHeaderShowsVerifiedBadge(profile), isFalse);
  });
}
