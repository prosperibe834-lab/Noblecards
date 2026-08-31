import 'package:flutter/foundation.dart';

class ApiConfig {
  static const String _defaultWebBaseUrl = 'http://localhost:3000';
  static const String _defaultAndroidBaseUrl = 'http://10.0.2.2:3000';
  static const String _defaultSimulatorBaseUrl = 'http://localhost:3000';

  static String get baseUrl {
    const envBaseUrl = String.fromEnvironment('API_BASE_URL');
    if (envBaseUrl.isNotEmpty) {
      return envBaseUrl;
    }

    if (kIsWeb) {
      return _defaultWebBaseUrl;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _defaultAndroidBaseUrl;
      case TargetPlatform.iOS:
        return _defaultSimulatorBaseUrl;
      default:
        return _defaultWebBaseUrl;
    }
  }
}
