import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationService {
  final SupabaseClient _client = Supabase.instance.client;

  bool get isAuthenticated => _client.auth.currentSession != null;

  User? get currentUser => _client.auth.currentUser;

  /// Maps Supabase errors to user-friendly messages
  String _friendlyMessage(Object error) {
    if (error is AuthException) {
      final message = error.message.toLowerCase();

      // Invalid login credentials
      if (message.contains('invalid login credentials') ||
          message.contains('user not found') ||
          message.contains('invalid email or password') ||
          message.contains('email or password')) {
        return 'Invalid email or password. Please try again.';
      }

      // Email not confirmed
      if (message.contains('email not confirmed') ||
          message.contains('confirm your email') ||
          message.contains('email confirmation')) {
        return 'Please verify your email before signing in.';
      }

      // Email already registered
      if (message.contains('already registered') ||
          message.contains('already exists') ||
          message.contains('user already') ||
          message.contains('duplicate key value')) {
        return 'An account with this email already exists. Please log in or use a different email.';
      }

      // Weak password
      if (message.contains('weak password') ||
          message.contains('password is too weak') ||
          message.contains('at least 6 characters')) {
        return 'Your password is too weak. Use at least 8 characters with uppercase, lowercase, numbers, and special characters.';
      }

      // Network errors
      if (message.contains('network') ||
          message.contains('timeout') ||
          message.contains('failed to connect') ||
          message.contains('no internet')) {
        return 'Network error. Please check your internet connection and try again.';
      }

      // Rate limiting
      if (message.contains('rate limit') ||
          message.contains('too many requests')) {
        return 'Too many attempts. Please wait a few minutes and try again.';
      }

      // OTP errors
      if (message.contains('otp') || message.contains('invalid code')) {
        return 'The verification code is invalid or expired. Please request a new one.';
      }

      if (message.contains('expired')) {
        return 'Your verification code has expired. Please request a new one.';
      }

      // Invalid email format
      if (message.contains('invalid email')) {
        return 'Please enter a valid email address.';
      }

      return error.message;
    }

    if (error is PostgrestException) {
      final message = error.message.toLowerCase();
      if (message.contains('network') || message.contains('timeout')) {
        return 'Network error. Please check your internet connection and try again.';
      }
      return 'Database error: ${error.message}';
    }

    return 'Something went wrong. Please try again. If the problem persists, contact support.';
  }

  /// Sign up with email and password.
  /// Profile fields are deliberately not sent as auth metadata before verification.
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      // Validate inputs
      if (email.trim().isEmpty) {
        throw Exception('Please enter your email address.');
      }
      if (password.isEmpty || password.length < 8) {
        throw Exception('Password must be at least 8 characters long.');
      }
      final response = await _client.auth.signUp(
        email: email.trim(),
        password: password,
      );

      if (response.user != null) {
        await _client.auth.signInWithOtp(
          email: email.trim(),
          shouldCreateUser: false,
        );
      }

      return response;
    } on AuthException catch (error) {
      throw Exception(_friendlyMessage(error));
    } on PostgrestException catch (error) {
      throw Exception(_friendlyMessage(error));
    } catch (error) {
      throw Exception(_friendlyMessage(error));
    }
  }

  /// Sign in with email and password
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      if (email.trim().isEmpty || password.isEmpty) {
        throw Exception('Please enter both email and password.');
      }

      return await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
    } on AuthException catch (error) {
      throw Exception(_friendlyMessage(error));
    } on PostgrestException catch (error) {
      throw Exception(_friendlyMessage(error));
    } catch (error) {
      throw Exception(_friendlyMessage(error));
    }
  }

  /// Verify the email OTP issued by signUp().
  Future<AuthResponse> verifyEmailOtp({
    required String email,
    required String token,
  }) async {
    try {
      if (email.trim().isEmpty || token.trim().isEmpty) {
        throw Exception('Email and OTP are required.');
      }

      if (token.trim().length != 6) {
        throw Exception('Please enter a valid 6-digit code.');
      }

      return await _client.auth.verifyOTP(
        email: email.trim(),
        token: token.trim(),
        type: OtpType.email,
      );
    } on AuthException catch (error) {
      throw Exception(_friendlyMessage(error));
    } on PostgrestException catch (error) {
      throw Exception(_friendlyMessage(error));
    } catch (error) {
      throw Exception(_friendlyMessage(error));
    }
  }

  /// Resend the email signup OTP.
  Future<void> resendEmailOtp({required String email}) async {
    try {
      if (email.trim().isEmpty) {
        throw Exception('Please enter your email address.');
      }

      await _client.auth.resend(
        type: OtpType.email,
        email: email.trim(),
      );
    } on AuthException catch (error) {
      throw Exception(_friendlyMessage(error));
    } on PostgrestException catch (error) {
      throw Exception(_friendlyMessage(error));
    } catch (error) {
      throw Exception(_friendlyMessage(error));
    }
  }

  /// Send password reset email
  Future<void> resetPasswordForEmail(String email) async {
    try {
      if (email.trim().isEmpty) {
        throw Exception('Please enter your email address.');
      }

      await _client.auth.resetPasswordForEmail(email.trim());
    } on AuthException catch (error) {
      throw Exception(_friendlyMessage(error));
    } on PostgrestException catch (error) {
      throw Exception(_friendlyMessage(error));
    } catch (error) {
      throw Exception(_friendlyMessage(error));
    }
  }

  /// Sign out user
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } on AuthException catch (error) {
      throw Exception(_friendlyMessage(error));
    } on PostgrestException catch (error) {
      throw Exception(_friendlyMessage(error));
    } catch (error) {
      throw Exception(_friendlyMessage(error));
    }
  }

  /// Optional: Save user profile data to profiles table
  /// Call this after successful OTP verification if you have a profiles table
  Future<void> saveUserProfile({
    required String userId,
    required Map<String, dynamic> profileData,
  }) async {
    try {
      if (userId.isEmpty) {
        throw Exception('User ID is required to save profile.');
      }

      final dataToInsert = {
        'id': userId,
        ...profileData,
      };

      await _client.from('profiles').insert(dataToInsert);
    } on PostgrestException catch (error) {
      if (error.code != 'PGRST116') {
        throw Exception('Failed to save profile: ${error.message}');
      }
    } catch (error) {
      throw Exception(_friendlyMessage(error));
    }
  }

  /// Get current user's profile data from profiles table
  /// Returns null if profile doesn't exist or table not set up
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      if (userId.isEmpty) {
        return null;
      }

      final response = await _client.from('profiles').select().eq('id', userId).maybeSingle();

      return response;
    } on PostgrestException catch (error) {
      if (error.code == 'PGRST116') {
        // Table doesn't exist, return null
        return null;
      }
      throw Exception('Failed to fetch profile: ${error.message}');
    } catch (error) {
      throw Exception(_friendlyMessage(error));
    }
  }
}
