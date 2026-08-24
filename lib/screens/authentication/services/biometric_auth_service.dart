import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'authentication_service.dart';

enum BiometricSupportType { face, fingerprint, none }

class BiometricAuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  /// Checks if the device has biometric hardware and is enrolled
  Future<bool> canUseBiometrics() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      return canAuthenticateWithBiometrics && (await _auth.getAvailableBiometrics()).isNotEmpty;
    } on Object {
      return false;
    }
  }

  /// Determines the specific type of biometric available (Face vs Fingerprint)
  Future<BiometricSupportType> getAvailableBiometricType() async {
    try {
      final List<BiometricType> availableBiometrics =
          await _auth.getAvailableBiometrics();

      if (availableBiometrics.contains(BiometricType.face)) {
        return BiometricSupportType.face;
      } else if (availableBiometrics.contains(BiometricType.fingerprint) ||
                 availableBiometrics.contains(BiometricType.strong)) {
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
      return await _auth.authenticate(
        localizedReason: 'Authenticate to log in to NobleCards',
      );
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

  Future<bool> restoreSession() => AuthenticationService().restoreBiometricSession();

  Future<void> recordAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('biometric_last_authenticated_at', DateTime.now().millisecondsSinceEpoch);
  }
}