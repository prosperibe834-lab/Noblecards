import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

enum BiometricSupportType { face, fingerprint, none }

class BiometricAuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  /// Checks if the device has biometric hardware and is enrolled
  Future<bool> canUseBiometrics() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
      return canAuthenticate;
    } on PlatformException {
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
    } on PlatformException {
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
    } on PlatformException {
      return false;
    }
  }
}