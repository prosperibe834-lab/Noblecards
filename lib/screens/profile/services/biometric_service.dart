import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/biometric_option.dart';
import '../../authentication/services/authentication_service.dart';

class BiometricService {
  static final LocalAuthentication _auth = LocalAuthentication();
  static const String _faceIdKey = 'biometric_face_id';
  static const String _fingerprintKey = 'biometric_fingerprint';
  static const String _rememberDeviceKey = 'biometric_remember_device';
  static const String _transactionsKey = 'biometric_require_transactions';
  static const String _autoLockKey = 'biometric_auto_lock_time';

  Future<BiometricSettingsModel> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final available = await availableTypes();
    final hasSession = await AuthenticationService().hasSecureSession();

    return BiometricSettingsModel(
      isFaceIdAvailable: available.contains(BiometricType.face),
      isFingerprintAvailable: available.contains(BiometricType.fingerprint),
      isFaceIdEnabled: hasSession && (prefs.getBool(_faceIdKey) ?? false),
      isFingerprintEnabled: hasSession && (prefs.getBool(_fingerprintKey) ?? false),
      isRememberDeviceEnabled: hasSession && (prefs.getBool(_rememberDeviceKey) ?? false),
      isRequireForTransactionsEnabled: prefs.getBool(_transactionsKey) ?? true,
      autoLockTime: prefs.getString(_autoLockKey) ?? '5 Minutes',
    );
  }

  Future<List<BiometricType>> availableTypes() async {
    try {
      if (!await _auth.canCheckBiometrics) return const [];
      return await _auth.getAvailableBiometrics();
    } on PlatformException {
      return const [];
    }
  }

  Future<bool> authenticate({required String reason}) async {
    try {
      final authenticated = await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
      if (authenticated) await _recordAuthentication();
      return authenticated;
    } on Object {
      return false;
    }
  }

  Future<bool> authenticateForSensitiveAction() => authenticate(
        reason: 'Verify your identity to continue securely.',
      );

  Future<bool> hasSecureSession() => AuthenticationService().hasSecureSession();

  Future<bool> shouldRequireAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    final lastAuthenticated = prefs.getInt('biometric_last_authenticated_at');
    if (lastAuthenticated == null) return true;
    final setting = prefs.getString(_autoLockKey) ?? '5 Minutes';
    final timeout = _autoLockDuration(setting);
    return timeout != null &&
        DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(lastAuthenticated)) >= timeout;
  }

  Future<void> saveBiometricSession() => AuthenticationService().saveBiometricSession();

  Future<void> clearBiometricSession() => AuthenticationService().clearBiometricSession();

  Future<void> _recordAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('biometric_last_authenticated_at', DateTime.now().millisecondsSinceEpoch);
  }

  Duration? _autoLockDuration(String setting) {
    switch (setting) {
      case 'Immediately':
        return Duration.zero;
      case '1 Minute':
        return const Duration(minutes: 1);
      case '5 Minutes':
        return const Duration(minutes: 5);
      case '15 Minutes':
        return const Duration(minutes: 15);
      case '30 Minutes':
        return const Duration(minutes: 30);
      case 'Never':
        return null;
      default:
        return const Duration(minutes: 5);
    }
  }

  Future<void> saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }
}

class BiometricProvider extends ChangeNotifier {
  final BiometricService _service = BiometricService();

  BiometricSettingsModel _settings = BiometricSettingsModel.initial();
  bool _isLoading = true;
  String? _errorMessage;

  BiometricSettingsModel get settings => _settings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadBiometricSettings() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _settings = await _service.loadSettings();
    } catch (e) {
      _errorMessage = 'Failed to load biometric settings.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFaceId(bool value) async {
    HapticFeedback.lightImpact();
    await _toggleBiometric(value, _settings.isFaceIdEnabled, 'biometric_face_id', true, 'Face ID');
  }

  Future<void> toggleFingerprint(bool value) async {
    HapticFeedback.lightImpact();
    await _toggleBiometric(value, _settings.isFingerprintEnabled, 'biometric_fingerprint', false, 'Fingerprint');
  }

  Future<void> toggleRememberDevice(bool value) async {
    HapticFeedback.lightImpact();
    if (value && !await _service.hasSecureSession()) {
      _errorMessage = 'Log in before choosing to remember this device.';
      notifyListeners();
      return;
    }
    _settings = _settings.copyWith(isRememberDeviceEnabled: value);
    notifyListeners();
    await _service.saveSetting('biometric_remember_device', value);
  }

  Future<void> toggleRequireForTransactions(bool value) async {
    HapticFeedback.lightImpact();
    _settings = _settings.copyWith(isRequireForTransactionsEnabled: value);
    notifyListeners();
    await _service.saveSetting('biometric_require_transactions', value);
  }

  Future<void> updateAutoLockTime(String time) async {
    HapticFeedback.mediumImpact();
    _settings = _settings.copyWith(autoLockTime: time);
    notifyListeners();
    await _service.saveSetting('biometric_auto_lock_time', time);
  }

  Future<void> _toggleBiometric(
    bool value,
    bool previousValue,
    String key,
    bool isFaceId,
    String label,
  ) async {
    if (value) {
      if (!await _service.hasSecureSession()) {
        _errorMessage = 'Log in before enabling $label.';
        notifyListeners();
        return;
      }
      if (!await _service.authenticate(reason: 'Authenticate to enable $label.')) {
        _errorMessage = '$label authentication was canceled or failed.';
        notifyListeners();
        return;
      }
    }
    _settings = _settings.copyWith(
      isFaceIdEnabled: isFaceId ? value : null,
      isFingerprintEnabled: isFaceId ? null : value,
    );
    notifyListeners();
    try {
      await _service.saveSetting(key, value);
      if (value) {
        await _service.saveBiometricSession();
      } else if (!_settings.isFaceIdEnabled && !_settings.isFingerprintEnabled) {
        await _service.clearBiometricSession();
      }
    } catch (_) {
      _settings = _settings.copyWith(
        isFaceIdEnabled: isFaceId ? previousValue : null,
        isFingerprintEnabled: isFaceId ? null : previousValue,
      );
      _errorMessage = 'Unable to save biometric settings.';
      notifyListeners();
    }
  }
}