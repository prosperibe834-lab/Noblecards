import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import '../../../core/config/api_config.dart';

class AuthUser {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? username;
  final String? displayName;
  final String? phone;
  final String? country;
  final String? countryCode;
  final String? gender;
  final String? dateOfBirth;
  final String? bio;
  final String? address;
  final String? profileImageUrl;
  final bool isEmailVerified;
  final bool isProfileComplete;
  final bool isVerified;

  const AuthUser({required this.id, required this.email, required this.firstName, required this.lastName, this.username, this.displayName, this.phone, this.country, this.countryCode, this.gender, this.dateOfBirth, this.bio, this.address, this.profileImageUrl, this.isEmailVerified = false, this.isProfileComplete = false, this.isVerified = false});

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        id: json['id'] as String,
        email: json['email'] as String,
        firstName: json['firstName'] as String? ?? '',
        lastName: json['lastName'] as String? ?? '',
        username: json['username'] as String?, displayName: json['displayName'] as String?, phone: json['phone'] as String?, country: json['country'] as String?, countryCode: json['countryCode'] as String?, gender: json['gender'] as String?, dateOfBirth: json['dateOfBirth'] as String?, bio: json['bio'] as String?, address: json['address'] as String?, profileImageUrl: json['profileImageUrl'] as String?, isEmailVerified: json['isEmailVerified'] as bool? ?? false, isProfileComplete: json['isProfileComplete'] as bool? ?? false, isVerified: json['isVerified'] as bool? ?? false,
      );
}

class AuthSession {
  final String accessToken;
  const AuthSession(this.accessToken);
}

class AuthResponse {
  final AuthUser? user;
  final AuthSession? session;
  const AuthResponse({this.user, this.session});
}

class AuthenticationService {
  static String get apiBaseUrl => ApiConfig.baseUrl;
  static String get _baseUrl => apiBaseUrl;
  static const _accessKey = 'noble_cards_access_token';
  static const _refreshKey = 'noble_cards_refresh_token';
  static const biometricAccessKey = 'noble_cards_biometric_access_token';
  static const biometricRefreshKey = 'noble_cards_biometric_refresh_token';
  static const _recoveryEmailKey = 'noble_cards_recovery_email';
  static const _recoveryCodeKey = 'noble_cards_recovery_code';

  static SharedPreferences? _sharedPreferences;
  static FlutterSecureStorage? _secureStorage;
  static bool _hasPersistedSession = false;
  final SharedPreferences? _preferences;
  final FlutterSecureStorage? _storage;
  AuthUser? _currentUser;

  AuthenticationService({SharedPreferences? preferences, FlutterSecureStorage? storage})
      : _preferences = preferences ?? _sharedPreferences,
        _storage = storage ?? _secureStorage;

  static Future<void> initialize() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _secureStorage = const FlutterSecureStorage();
    await _sharedPreferences!.remove(_accessKey);
    await _sharedPreferences!.remove(_refreshKey);
    _hasPersistedSession = (await _secureStorage!.read(key: _accessKey))?.isNotEmpty == true;
  }

  bool get isAuthenticated => _hasPersistedSession;

  Future<bool> _refreshAccessTokenIfNeeded() async {
    final refreshToken = await _storage?.read(key: _refreshKey);
    if (refreshToken == null || refreshToken.isEmpty) {
      await _clearSessionQuietly();
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      final data = response.body.isEmpty ? <String, dynamic>{} : jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode >= 200 && response.statusCode < 300 && data['accessToken'] != null) {
        final accessToken = data['accessToken'] as String;
        final nextRefreshToken = data['refreshToken'] as String?;
        await _save(_accessKey, accessToken);
        if (nextRefreshToken != null && nextRefreshToken.isNotEmpty) {
          await _save(_refreshKey, nextRefreshToken);
        }
        _hasPersistedSession = true;
        return true;
      }

      await _clearSessionQuietly();
      return false;
    } catch (_) {
      await _clearSessionQuietly();
      return false;
    }
  }

  Future<void> _clearSessionQuietly() async {
    await _remove(_accessKey);
    await _remove(_refreshKey);
    _currentUser = null;
    _hasPersistedSession = false;
  }

  String? _safeTokenExpiry(String token) {
    try {
      final parts = token.split('.');
      if (parts.length < 2) return null;
      final payload = parts[1].padRight((parts[1].length + 3) ~/ 4 * 4, '=');
      final normalized = payload.replaceAll('-', '+').replaceAll('_', '/');
      final decoded = utf8.decode(base64Url.decode(normalized));
      final data = jsonDecode(decoded) as Map<String, dynamic>;
      final exp = data['exp'];
      if (exp is int) {
        final date = DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true);
        return date.toIso8601String();
      }
    } catch (_) {}
    return null;
  }

  void _debugLog(String method, String path, {required int statusCode, required bool tokenExists, String? expiry}) {
    final safeExpiry = expiry == null ? 'unknown' : expiry;
    print('[AuthDebug] $method $path status=$statusCode tokenExists=$tokenExists expiry=$safeExpiry');
  }
  AuthUser? get currentUser => _currentUser;

  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
    String? phone,
    String? country,
    String? countryCode,
    String? gender,
  }) async {
    final body = <String, dynamic>{
      'email': email.trim(),
      'password': password,
      'firstName': firstName ?? '',
      'lastName': lastName ?? '',
      if (phone != null) 'phone': phone,
      if (country != null) 'country': country,
      if (countryCode != null) 'countryCode': countryCode,
      if (gender != null) 'gender': gender,
    };
    await _request('POST', '/auth/register', body: body);
    return AuthResponse(user: null, session: null);
  }

  Future<AuthResponse> signInWithEmail({required String email, required String password}) async {
    final data = await _request('POST', '/auth/login', body: {'email': email.trim(), 'password': password});
    return _storeSession(data);
  }

  Future<bool> signInWithEmailAndOtp({required String email, required String password}) async {
    try {
      await signInWithEmail(email: email, password: password);
      return false;
    } catch (error) {
      if (error.toString().toLowerCase().contains('verify your email')) {
        await sendSignInOtp(email: email);
        return true;
      }
      rethrow;
    }
  }

  Future<void> sendSignInOtp({required String email}) async {
    await resendEmailOtp(email: email);
  }

  Future<void> resendSignInOtp({required String email}) => sendSignInOtp(email: email);

  Future<AuthResponse> verifySignInOtp({required String email, required String token}) {
    return verifyEmailOtp(email: email, token: token);
  }

  Future<AuthResponse> verifyEmailOtp({required String email, required String token}) async {
    final data = await _request('POST', '/auth/verify-email', body: {'email': email.trim(), 'code': token.trim()});
    return _storeSession(data);
  }

  Future<void> resendEmailOtp({required String email}) async {
    await _request('POST', '/auth/resend-otp', body: {'email': email.trim(), 'purpose': 'signup'});
  }

  Future<void> sendPasswordResetOtp({required String email}) async {
    await _request('POST', '/auth/forgot-password', body: {'email': email.trim()});
  }

  Future<void> resendPasswordResetOtp({required String email}) async {
    await _request('POST', '/auth/resend-otp', body: {'email': email.trim(), 'purpose': 'password-recovery'});
  }

  Future<AuthResponse> verifyPasswordResetOtp({required String email, required String token}) async {
    await _save(_recoveryEmailKey, email.trim());
    await _save(_recoveryCodeKey, token.trim());
    return const AuthResponse(session: AuthSession('recovery'));
  }

  Future<void> updatePassword(String newPassword) async {
    final email = _preferences?.getString(_recoveryEmailKey);
    final code = _preferences?.getString(_recoveryCodeKey);
    if (email == null || code == null) throw Exception('Your password reset session has expired.');
    await _request('POST', '/auth/reset-password', body: {'email': email, 'code': code, 'newPassword': newPassword});
    await _remove(_recoveryEmailKey);
    await _remove(_recoveryCodeKey);
  }

  Future<void> resetPasswordForEmail(String email) => sendPasswordResetOtp(email: email);

  Future<void> signOut() async {
    if (isAuthenticated) {
      try { await _request('POST', '/auth/logout', authenticated: true); } catch (_) {}
    }
    await _remove(_accessKey);
    await _remove(_refreshKey);
    await clearBiometricSession();
    await _preferences?.remove('biometric_face_id');
    await _preferences?.remove('biometric_fingerprint');
    await _preferences?.remove('biometric_remember_device');
    _currentUser = null;
  }

  Future<bool> restorePersistedSession() async {
    final accessToken = await _storage?.read(key: _accessKey);
    _hasPersistedSession = accessToken?.isNotEmpty == true;
    return _hasPersistedSession;
  }

  Future<bool> hasSecureSession() async =>
      (await _storage?.read(key: _accessKey))?.isNotEmpty == true;

  Future<String?> getAccessToken() async => _storage?.read(key: _accessKey);

  Future<bool> hasBiometricSession() async =>
      (await _storage?.read(key: biometricRefreshKey))?.isNotEmpty == true;

  Future<void> saveBiometricSession() async {
    final accessToken = await _storage?.read(key: _accessKey);
    final refreshToken = await _storage?.read(key: _refreshKey);
    if (accessToken == null || refreshToken == null) {
      throw Exception('Your secure session is unavailable. Please log in again.');
    }
    await _storage?.write(key: biometricAccessKey, value: accessToken);
    await _storage?.write(key: biometricRefreshKey, value: refreshToken);
  }

  Future<void> clearBiometricSession() async {
    await _storage?.delete(key: biometricAccessKey);
    await _storage?.delete(key: biometricRefreshKey);
  }

  Future<bool> restoreBiometricSession() async {
    final refreshToken = await _storage?.read(key: biometricRefreshKey);
    if (refreshToken == null || refreshToken.isEmpty) return false;
    try {
      final data = await _request('POST', '/auth/refresh', body: {'refreshToken': refreshToken});
      await _storeSession(data);
      await saveBiometricSession();
      return true;
    } catch (_) {
      await clearBiometricSession();
      return false;
    }
  }

  Future<Map<String, dynamic>> saveUserProfile({required String userId, required Map<String, dynamic> profileData, XFile? image, bool removeImage = false}) async {
    final accessToken = await _storage?.read(key: _accessKey);
    if (accessToken == null || accessToken.isEmpty) throw Exception('Your login session has expired. Please log in again.');
    if (image != null) {
      final request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/users/me/image'));
      request.headers['Authorization'] = 'Bearer $accessToken';
      final extension = image.name.split('.').last.toLowerCase();
      final subtype = extension == 'jpg' || extension == 'jpeg' ? 'jpeg' : extension;
      request.files.add(http.MultipartFile.fromBytes('image', await image.readAsBytes(), filename: image.name, contentType: MediaType('image', subtype)));
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(_friendlyMessage(_responseMessage(responseBody, 'Profile image upload failed.')));
      }
      final uploadData = jsonDecode(responseBody) as Map<String, dynamic>;
      final uploadedUser = uploadData['user'] as Map<String, dynamic>?;
      final uploadedImageUrl = uploadedUser?['profileImageUrl'] as String?;
      if (uploadedImageUrl == null || uploadedImageUrl.isEmpty) throw Exception('Profile image upload did not return a saved image.');
      profileData = {...profileData, 'profileImageUrl': uploadedImageUrl};
    } else if (removeImage) {
      await _request('DELETE', '/users/me/image', authenticated: true);
    }
    final data = await _request('PATCH', '/users/me', body: profileData, authenticated: true);
    final updatedUser = data['user'] as Map<String, dynamic>?;
    if (updatedUser == null) throw Exception('Profile update did not return the saved user.');
    final refreshedData = await _request('GET', '/users/me', authenticated: true);
    final refreshedUser = refreshedData['user'] as Map<String, dynamic>?;
    if (refreshedUser == null) throw Exception('Profile could not be refreshed after saving.');
    _currentUser = AuthUser.fromJson(refreshedUser);
    return refreshedUser;
  }

  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    final data = await _request('GET', '/users/me', authenticated: true);
    if (data['user'] is Map<String, dynamic>) _currentUser = AuthUser.fromJson(data['user'] as Map<String, dynamic>);
    return data['user'] as Map<String, dynamic>?;
  }

  Future<Map<String, dynamic>> _request(String method, String path, {Map<String, dynamic>? body, bool authenticated = false, bool retryOnUnauthorized = true}) async {
    String? accessToken = authenticated ? await _storage?.read(key: _accessKey) : null;
    if (authenticated && (accessToken == null || accessToken.isEmpty)) {
      final refreshed = await _refreshAccessTokenIfNeeded();
      if (!refreshed) {
        throw Exception('Your login session has expired. Please log in again.');
      }
      accessToken = await _storage?.read(key: _accessKey);
    }

    final headers = {'Content-Type': 'application/json'};
    if (authenticated && accessToken != null && accessToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    final response = method == 'POST'
        ? await http.post(Uri.parse('$_baseUrl$path'), headers: headers, body: jsonEncode(body ?? {}))
        : method == 'PATCH'
            ? await http.patch(Uri.parse('$_baseUrl$path'), headers: headers, body: jsonEncode(body ?? {}))
            : method == 'DELETE'
                ? await http.delete(Uri.parse('$_baseUrl$path'), headers: headers)
                : await http.get(Uri.parse('$_baseUrl$path'), headers: headers);

    _debugLog(method, path, statusCode: response.statusCode, tokenExists: accessToken != null && accessToken.isNotEmpty, expiry: accessToken == null ? null : _safeTokenExpiry(accessToken));

    if (response.statusCode == 401 && authenticated && retryOnUnauthorized) {
      final refreshed = await _refreshAccessTokenIfNeeded();
      if (refreshed) {
        return _request(method, path, body: body, authenticated: authenticated, retryOnUnauthorized: false);
      }
      await _clearSessionQuietly();
      throw Exception('Your login session has expired. Please log in again.');
    }

    final data = response.body.isEmpty ? <String, dynamic>{} : jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(_friendlyMessage(data['message'] ?? 'Something went wrong. Please try again.'));
    }
    return data;
  }

  String _responseMessage(String responseBody, String fallback) {
    try {
      final data = jsonDecode(responseBody);
      if (data is Map<String, dynamic> && data['message'] != null) return data['message'].toString();
    } catch (_) {}
    return fallback;
  }

  Future<AuthResponse> _storeSession(Map<String, dynamic> data) async {
    final user = AuthUser.fromJson(data['user'] as Map<String, dynamic>);
    final access = data['accessToken'] as String;
    await _save(_accessKey, access);
    if (data['refreshToken'] != null) await _save(_refreshKey, data['refreshToken'] as String);
    _currentUser = user;
    return AuthResponse(user: user, session: AuthSession(access));
  }

  Future<void> _save(String key, String value) async {
    if (key == _accessKey || key == _refreshKey) {
      await _storage?.write(key: key, value: value);
      if (key == _accessKey) _hasPersistedSession = true;
      return;
    }
    await _preferences?.setString(key, value);
  }

  Future<void> _remove(String key) async {
    if (key == _accessKey || key == _refreshKey) {
      await _storage?.delete(key: key);
      if (key == _accessKey) _hasPersistedSession = false;
      return;
    }
    await _preferences?.remove(key);
  }

  String _friendlyMessage(Object message) {
    final text = message.toString().toLowerCase();
    if (text.contains('already exists')) return 'An account with this email already exists. Please log in or use a different email.';
    if (text.contains('invalid email')) return 'Please enter a valid email address.';
    if (text.contains('invalid email or password')) return 'Invalid email or password. Please try again.';
    if (text.contains('verify your email')) return 'Please verify your email before signing in.';
    if (text.contains('wait') || text.contains('too many')) return 'Too many attempts. Please wait and try again.';
    if (text.contains('code')) return 'The verification code is invalid or expired. Please request a new one.';
    return message.toString();
  }
}
