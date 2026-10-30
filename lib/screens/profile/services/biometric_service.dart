import 'package:flutter/foundation.dart';
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

    Map<String, dynamic>? backendSettings;
    bool hasTransactionPin = false;

    if (hasSession) {
      try {
        backendSettings = await AuthenticationService().authenticatedGet(
          '/users/me/biometrics',
        );
        if (backendSettings.isNotEmpty) {
          final bioLogin = backendSettings['biometricLoginEnabled'] == true;
          final bioType =
              backendSettings['biometricType']?.toString().toLowerCase();
          final isFace = bioType == 'face';
          final isFinger = bioType == 'fingerprint' ||
              bioType == 'touch_id' ||
              bioType == null;

          await prefs.setBool(_faceIdKey, bioLogin && isFace);
          await prefs.setBool(_fingerprintKey, bioLogin && isFinger);
          await prefs.setBool(
            _rememberDeviceKey,
            backendSettings['rememberDevice'] == true,
          );
          await prefs.setBool(
            _transactionsKey,
            backendSettings['biometricTransactionEnabled'] == true,
          );
          if (backendSettings['autoLockTime'] != null) {
            await prefs.setString(
              _autoLockKey,
              backendSettings['autoLockTime'].toString(),
            );
          }
          hasTransactionPin = backendSettings['hasTransactionPin'] == true;
        }
      } catch (_) {
        // Fallback to locally cached settings
      }
    }

    final bool isFaceAvailable =
        kIsWeb || available.contains(BiometricType.face);
    final bool isFingerprintAvailable = kIsWeb ||
        available.contains(BiometricType.fingerprint) ||
        available.contains(BiometricType.strong) ||
        available.contains(BiometricType.weak);

    final bool isFaceEnabled = backendSettings != null
        ? (backendSettings['biometricLoginEnabled'] == true &&
            backendSettings['biometricType']?.toString().toLowerCase() ==
                'face')
        : (prefs.getBool(_faceIdKey) ?? false);

    final bool isFingerEnabled = backendSettings != null
        ? (backendSettings['biometricLoginEnabled'] == true &&
            (backendSettings['biometricType']?.toString().toLowerCase() ==
                    'fingerprint' ||
                backendSettings['biometricType']?.toString().toLowerCase() ==
                    'touch_id'))
        : (prefs.getBool(_fingerprintKey) ?? false);

    final bool isRememberEnabled = backendSettings != null
        ? (backendSettings['rememberDevice'] == true)
        : (prefs.getBool(_rememberDeviceKey) ?? false);

    final bool isTxEnabled = backendSettings != null
        ? (backendSettings['biometricTransactionEnabled'] == true)
        : (prefs.getBool(_transactionsKey) ?? true);

    final String autoLock = backendSettings != null &&
            backendSettings['autoLockTime'] != null
        ? backendSettings['autoLockTime'].toString()
        : (prefs.getString(_autoLockKey) ?? '5 Minutes');

    return BiometricSettingsModel(
      isFaceIdAvailable: isFaceAvailable,
      isFingerprintAvailable: isFingerprintAvailable,
      isFaceIdEnabled: hasSession && isFaceEnabled,
      isFingerprintEnabled: hasSession && isFingerEnabled,
      isRememberDeviceEnabled: hasSession && isRememberEnabled,
      isRequireForTransactionsEnabled: isTxEnabled,
      autoLockTime: autoLock,
      hasTransactionPin: hasTransactionPin,
    );
  }

  Future<List<BiometricType>> availableTypes() async {
    try {
      if (!await _auth.canCheckBiometrics) return const [];
      return await _auth.getAvailableBiometrics();
    } on Object {
      return const [];
    }
  }

  Future<bool> authenticate({required String reason}) async {
    try {
      if (kIsWeb) {
        await Future.delayed(const Duration(milliseconds: 500));
        await _recordAuthentication();
        return true;
      }
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
    reason: 'Verify your identity to authorize transaction securely.',
  );

  Future<bool> hasSecureSession() => AuthenticationService().hasSecureSession();

  Future<bool> shouldRequireAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    final lastAuthenticated = prefs.getInt('biometric_last_authenticated_at');
    if (lastAuthenticated == null) return true;
    final setting = prefs.getString(_autoLockKey) ?? '5 Minutes';
    final timeout = _autoLockDuration(setting);
    return timeout != null &&
        DateTime.now().difference(
              DateTime.fromMillisecondsSinceEpoch(lastAuthenticated),
            ) >=
            timeout;
  }

  Future<void> saveBiometricSession() =>
      AuthenticationService().saveBiometricSession();

  Future<void> clearBiometricSession() =>
      AuthenticationService().clearBiometricSession();

  Future<void> _recordAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      'biometric_last_authenticated_at',
      DateTime.now().millisecondsSinceEpoch,
    );
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
  final AuthenticationService _authService = AuthenticationService();

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
    await _toggleBiometric(
      value: value,
      isFaceId: true,
      label: 'Face ID',
      biometricType: 'face',
    );
  }

  Future<void> toggleFingerprint(bool value) async {
    HapticFeedback.lightImpact();
    final type = defaultTargetPlatform == TargetPlatform.iOS
        ? 'touch_id'
        : 'fingerprint';
    final label = defaultTargetPlatform == TargetPlatform.iOS
        ? 'Touch ID'
        : 'Fingerprint';
    await _toggleBiometric(
      value: value,
      isFaceId: false,
      label: label,
      biometricType: type,
    );
  }

  Future<void> _toggleBiometric({
    required bool value,
    required bool isFaceId,
    required String label,
    required String biometricType,
  }) async {
    _errorMessage = null;
    if (value) {
      if (!await _service.hasSecureSession()) {
        _errorMessage = 'Please log in before enabling $label.';
        notifyListeners();
        return;
      }
      final bool authSuccess = await _service.authenticate(
        reason: 'Authenticate to enable $label for your account.',
      );
      if (!authSuccess) {
        _errorMessage = '$label authentication was canceled or failed.';
        notifyListeners();
        return;
      }
    }

    final prevFace = _settings.isFaceIdEnabled;
    final prevFinger = _settings.isFingerprintEnabled;

    _settings = _settings.copyWith(
      isFaceIdEnabled: isFaceId
          ? value
          : (value ? false : _settings.isFaceIdEnabled),
      isFingerprintEnabled: isFaceId
          ? (value ? false : _settings.isFingerprintEnabled)
          : value,
    );
    notifyListeners();

    try {
      // Sync with backend
      await _authService.authenticatedPatch(
        '/users/me/biometrics',
        body: {
          'biometricLoginEnabled': value,
          if (value) 'biometricType': biometricType,
        },
      );

      // Local storage sync
      await _service.saveSetting(
        'biometric_face_id',
        _settings.isFaceIdEnabled,
      );
      await _service.saveSetting(
        'biometric_fingerprint',
        _settings.isFingerprintEnabled,
      );

      if (value) {
        await _service.saveBiometricSession();
      } else if (!_settings.isFaceIdEnabled &&
          !_settings.isFingerprintEnabled) {
        await _service.clearBiometricSession();
      }
    } catch (e) {
      _settings = _settings.copyWith(
        isFaceIdEnabled: prevFace,
        isFingerprintEnabled: prevFinger,
      );
      _errorMessage = 'Unable to save biometric setting to server.';
      notifyListeners();
    }
  }

  Future<void> toggleRememberDevice(bool value) async {
    HapticFeedback.lightImpact();
    if (value && !await _service.hasSecureSession()) {
      _errorMessage = 'Log in before choosing to remember this device.';
      notifyListeners();
      return;
    }
    final prev = _settings.isRememberDeviceEnabled;
    _settings = _settings.copyWith(isRememberDeviceEnabled: value);
    notifyListeners();

    try {
      await _authService.authenticatedPatch(
        '/users/me/biometrics',
        body: {'rememberDevice': value},
      );
      await _service.saveSetting('biometric_remember_device', value);
    } catch (_) {
      _settings = _settings.copyWith(isRememberDeviceEnabled: prev);
      _errorMessage = 'Failed to update remember device setting.';
      notifyListeners();
    }
  }

  Future<void> toggleRequireForTransactions(bool value) async {
    HapticFeedback.lightImpact();
    _errorMessage = null;

    if (value) {
      final bool authSuccess = await _service.authenticateForSensitiveAction();
      if (!authSuccess) {
        _errorMessage = 'Authentication canceled or failed.';
        notifyListeners();
        return;
      }
    }

    final prev = _settings.isRequireForTransactionsEnabled;
    _settings = _settings.copyWith(isRequireForTransactionsEnabled: value);
    notifyListeners();

    try {
      await _authService.authenticatedPatch(
        '/users/me/biometrics',
        body: {'biometricTransactionEnabled': value},
      );
      await _service.saveSetting('biometric_require_transactions', value);
    } catch (e) {
      _settings = _settings.copyWith(isRequireForTransactionsEnabled: prev);
      final msg = e.toString().replaceFirst('Exception: ', '');
      _errorMessage = msg.contains('configure a transaction PIN')
          ? 'Please set up a Transaction PIN in Security & PIN first.'
          : 'Failed to update transaction biometric setting.';
      notifyListeners();
    }
  }

  Future<void> updateAutoLockTime(String time) async {
    HapticFeedback.mediumImpact();
    final prev = _settings.autoLockTime;
    _settings = _settings.copyWith(autoLockTime: time);
    notifyListeners();

    try {
      await _authService.authenticatedPatch(
        '/users/me/biometrics',
        body: {'autoLockTime': time},
      );
      await _service.saveSetting('biometric_auto_lock_time', time);
    } catch (_) {
      _settings = _settings.copyWith(autoLockTime: prev);
      _errorMessage = 'Failed to update auto lock time.';
      notifyListeners();
    }
  }
}
