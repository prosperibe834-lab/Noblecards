import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthUser {
  final String id;
  final String email;
  final String firstName;
  final String lastName;

  const AuthUser({required this.id, required this.email, required this.firstName, required this.lastName});

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        id: json['id'] as String,
        email: json['email'] as String,
        firstName: json['firstName'] as String? ?? '',
        lastName: json['lastName'] as String? ?? '',
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
  static const _baseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:3000');
  static const _accessKey = 'noble_cards_access_token';
  static const _refreshKey = 'noble_cards_refresh_token';
  static const _recoveryEmailKey = 'noble_cards_recovery_email';
  static const _recoveryCodeKey = 'noble_cards_recovery_code';

  static SharedPreferences? _sharedPreferences;
  final SharedPreferences? _preferences;
  AuthUser? _currentUser;

  AuthenticationService({SharedPreferences? preferences}) : _preferences = preferences ?? _sharedPreferences;

  static Future<void> initialize() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  bool get isAuthenticated => _preferences?.getString(_accessKey)?.isNotEmpty == true;
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
    await _request('POST', '/auth/register', body: {
      'email': email.trim(),
      'password': password,
      'firstName': firstName ?? '',
      'lastName': lastName ?? '',
      if (phone != null) 'phone': phone,
      if (country != null) 'country': country,
      if (countryCode != null) 'countryCode': countryCode,
      if (gender != null) 'gender': gender,
    });
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
    _currentUser = null;
  }

  Future<void> saveUserProfile({required String userId, required Map<String, dynamic> profileData}) async {}
  Future<Map<String, dynamic>?> getUserProfile(String userId) async => null;

  Future<Map<String, dynamic>> _request(String method, String path, {Map<String, dynamic>? body, bool authenticated = false}) async {
    final headers = {'Content-Type': 'application/json'};
    if (authenticated) headers['Authorization'] = 'Bearer ${_preferences?.getString(_accessKey)}';
    final response = method == 'POST'
        ? await http.post(Uri.parse('$_baseUrl$path'), headers: headers, body: jsonEncode(body ?? {}))
        : await http.get(Uri.parse('$_baseUrl$path'), headers: headers);
    final data = response.body.isEmpty ? <String, dynamic>{} : jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode < 200 || response.statusCode >= 300) throw Exception(_friendlyMessage(data['message'] ?? 'Something went wrong. Please try again.'));
    return data;
  }

  Future<AuthResponse> _storeSession(Map<String, dynamic> data) async {
    final user = AuthUser.fromJson(data['user'] as Map<String, dynamic>);
    final access = data['accessToken'] as String;
    await _save(_accessKey, access);
    if (data['refreshToken'] != null) await _save(_refreshKey, data['refreshToken'] as String);
    _currentUser = user;
    return AuthResponse(user: user, session: AuthSession(access));
  }

  Future<void> _save(String key, String value) async { await _preferences?.setString(key, value); }
  Future<void> _remove(String key) async { await _preferences?.remove(key); }

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
