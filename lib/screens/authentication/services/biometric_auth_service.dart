import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'authentication_service.dart';

enum BiometricSupportType { face, fingerprint, none }

class BiometricAuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  /// Checks if the device has biometric hardware and is enrolled
  Future<bool> canUseBiometrics() async {
    try {
      if (kIsWeb) return true;
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      return canAuthenticateWithBiometrics &&
          (await _auth.getAvailableBiometrics()).isNotEmpty;
    } on Object {
      return false;
    }
  }

  /// Determines the specific type of biometric available (Face vs Fingerprint)
  Future<BiometricSupportType> getAvailableBiometricType() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final faceEnabled = prefs.getBool('biometric_face_id') ?? false;
      final fingerEnabled = prefs.getBool('biometric_fingerprint') ?? false;

      if (faceEnabled) return BiometricSupportType.face;
      if (fingerEnabled) return BiometricSupportType.fingerprint;

      if (kIsWeb) {
        return defaultTargetPlatform == TargetPlatform.iOS
            ? BiometricSupportType.face
            : BiometricSupportType.fingerprint;
      }

      final List<BiometricType> availableBiometrics =
          await _auth.getAvailableBiometrics();

      if (availableBiometrics.contains(BiometricType.face)) {
        return BiometricSupportType.face;
      } else if (availableBiometrics.contains(BiometricType.fingerprint) ||
          availableBiometrics.contains(BiometricType.strong) ||
          availableBiometrics.contains(BiometricType.weak)) {
        return BiometricSupportType.fingerprint;
      }
    } on Object {
      return BiometricSupportType.none;
    }
    return BiometricSupportType.none;
  }

  /// Triggers the actual biometric prompt
  Future<bool> authenticate() async {
    try {
      if (kIsWeb) {
        await Future.delayed(const Duration(milliseconds: 500));
        await recordAuthentication();
        return true;
      }
      final authenticated = await _auth.authenticate(
        localizedReason: 'Authenticate to log in to NobleCards',
        biometricOnly: true,
      );
      if (authenticated) await recordAuthentication();
      return authenticated;
    } on Object {
      return false;
    }
  }

  Future<bool> isBiometricLoginEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getBool('biometric_face_id') ?? false) ||
        (prefs.getBool('biometric_fingerprint') ?? false);
  }

  Future<bool> canLoginWithBiometrics() async {
    return await canUseBiometrics() &&
        await isBiometricLoginEnabled() &&
        await AuthenticationService().hasBiometricSession();
  }

  Future<bool> restoreSession() async {
    final type = await getAvailableBiometricType();
    final typeString = type == BiometricSupportType.face
        ? 'face'
        : (type == BiometricSupportType.fingerprint ? 'fingerprint' : null);
    return AuthenticationService().restoreBiometricSession(
      biometricType: typeString,
    );
  }

  Future<void> recordAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      'biometric_last_authenticated_at',
      DateTime.now().millisecondsSinceEpoch,
    );
  }
}
