import 'package:flutter/foundation.dart';

class ApiConfig {
  static const String _defaultWebBaseUrl = 'http://localhost:3000';
  static const String _defaultLiveBaseUrl = 'https://gloater-departure-stitch.ngrok-free.dev';

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
        return _defaultLiveBaseUrl;
      case TargetPlatform.iOS:
        return _defaultLiveBaseUrl;
      default:
        return _defaultWebBaseUrl;
    }
  }
}
