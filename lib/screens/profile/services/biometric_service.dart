import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/biometric_option.dart';

class BiometricService {
  static const String _faceIdKey = 'biometric_face_id';
  static const String _fingerprintKey = 'biometric_fingerprint';
  static const String _rememberDeviceKey = 'biometric_remember_device';
  static const String _transactionsKey = 'biometric_require_transactions';
  static const String _autoLockKey = 'biometric_auto_lock_time';

  Future<BiometricSettingsModel> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Hardware availability detection (Simulated hardware check)
    final isFaceIdAvailable = true;
    final isFingerprintAvailable = true;

    return BiometricSettingsModel(
      isFaceIdAvailable: isFaceIdAvailable,
      isFingerprintAvailable: isFingerprintAvailable,
      isFaceIdEnabled: prefs.getBool(_faceIdKey) ?? true,
      isFingerprintEnabled: prefs.getBool(_fingerprintKey) ?? true,
      isRememberDeviceEnabled: prefs.getBool(_rememberDeviceKey) ?? true,
      isRequireForTransactionsEnabled: prefs.getBool(_transactionsKey) ?? true,
      autoLockTime: prefs.getString(_autoLockKey) ?? '5 Minutes',
    );
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
    _settings = _settings.copyWith(isFaceIdEnabled: value);
    notifyListeners();
    await _service.saveSetting('biometric_face_id', value);
  }

  Future<void> toggleFingerprint(bool value) async {
    HapticFeedback.lightImpact();
    _settings = _settings.copyWith(isFingerprintEnabled: value);
    notifyListeners();
    await _service.saveSetting('biometric_fingerprint', value);
  }

  Future<void> toggleRememberDevice(bool value) async {
    HapticFeedback.lightImpact();
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
}