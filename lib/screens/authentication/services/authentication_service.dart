import 'package:flutter/foundation.dart';
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
          message.contains('invalid email or password')) {
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
  ///
  /// `signUp()` creates the auth user and triggers the "Confirm signup" email.
  /// For the email to contain a 6-digit OTP (instead of a confirmation link),
  /// the Supabase "Confirm signup" email template must use `{{ .Token }}`.
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('SIGNUP DEBUG: starting');
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
      debugPrint('SIGNUP DEBUG: email = ${email.trim()}');
      debugPrint('SIGNUP DEBUG: signup completed');
      debugPrint('SIGNUP DEBUG: user = ${response.user?.id}');
      debugPrint('SIGNUP DEBUG: session = ${response.session != null}');
      debugPrint(
        'SIGNUP DEBUG: email confirmation required = ${response.user != null && response.session == null}',
      );

      if (response.user == null) {
        throw Exception('Signup did not return a user. Please try again.');
      }

      if (response.session != null) {
        throw Exception(
          'Signup completed without email verification. Enable Supabase email confirmation to receive a signup OTP.',
        );
      }

      // A successful signup with email confirmation enabled already sends the
      // signup OTP. Resends are handled from VerifyOtpScreen after expiry.
      debugPrint('SIGNUP DEBUG: waiting for email verification');
      return response;
    } on AuthException catch (error) {
      debugPrint(
        'SIGNUP DEBUG: AuthException: ${error.message} '
        '(statusCode: ${error.statusCode})',
      );
      debugPrint(
        'signUpWithEmail AuthException: ${error.message} (status: ${error.statusCode})',
      );
      throw Exception(_friendlyMessage(error));
    } on PostgrestException catch (error) {
      debugPrint('signUpWithEmail PostgrestException: ${error.message}');
      throw Exception(_friendlyMessage(error));
    } catch (error) {
      debugPrint('signUpWithEmail Error: $error');
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
      debugPrint(
        'signInWithEmail AuthException: ${error.message} (status: ${error.statusCode})',
      );
      throw Exception(_friendlyMessage(error));
    } on PostgrestException catch (error) {
      debugPrint('signInWithEmail PostgrestException: ${error.message}');
      throw Exception(_friendlyMessage(error));
    } catch (error) {
      debugPrint('signInWithEmail Error: $error');
      throw Exception(_friendlyMessage(error));
    }
  }

  /// Sign in with a password, sending an email OTP when the email is not
  /// confirmed yet. Returns true when the OTP screen should be shown.
  Future<bool> signInWithEmailAndOtp({
    required String email,
    required String password,
  }) async {
    try {
      if (email.trim().isEmpty || password.isEmpty) {
        throw Exception('Please enter both email and password.');
      }

      await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
      return false;
    } on AuthException catch (error) {
      final message = error.message.toLowerCase();
      if (message.contains('email not confirmed') ||
          message.contains('confirm your email') ||
          message.contains('email confirmation')) {
        await sendSignInOtp(email: email);
        return true;
      }

      debugPrint(
        'signInWithEmailAndOtp AuthException: ${error.message} '
        '(status: ${error.statusCode})',
      );
      throw Exception(_friendlyMessage(error));
    } on PostgrestException catch (error) {
      debugPrint('signInWithEmailAndOtp PostgrestException: ${error.message}');
      throw Exception(_friendlyMessage(error));
    } catch (error) {
      debugPrint('signInWithEmailAndOtp Error: $error');
      throw Exception(_friendlyMessage(error));
    }
  }

  /// Send the sign-in email OTP without creating a new user.
  Future<void> sendSignInOtp({required String email}) async {
    try {
      if (email.trim().isEmpty) {
        throw Exception('Please enter your email address.');
      }

      await _client.auth.signInWithOtp(
        email: email.trim(),
        shouldCreateUser: false,
      );
    } on AuthException catch (error) {
      debugPrint(
        'sendSignInOtp AuthException: ${error.message} (status: ${error.statusCode})',
      );
      throw Exception(_friendlyMessage(error));
    } on PostgrestException catch (error) {
      debugPrint('sendSignInOtp PostgrestException: ${error.message}');
      throw Exception(_friendlyMessage(error));
    } catch (error) {
      debugPrint('sendSignInOtp Error: $error');
      throw Exception(_friendlyMessage(error));
    }
  }

  /// Resend a new sign-in email OTP.
  Future<void> resendSignInOtp({required String email}) async {
    await sendSignInOtp(email: email);
  }

  /// Verify the sign-in email OTP.
  Future<AuthResponse> verifySignInOtp({
    required String email,
    required String token,
  }) async {
    try {
      if (email.trim().isEmpty || token.trim().isEmpty) {
        throw Exception('Email and OTP are required.');
      }

      if (!RegExp(r'^\d{6}$').hasMatch(token.trim())) {
        throw Exception('Please enter a valid 6-digit code.');
      }

      return await _client.auth.verifyOTP(
        email: email.trim(),
        token: token.trim(),
        type: OtpType.email,
      );
    } on AuthException catch (error) {
      debugPrint(
        'verifySignInOtp AuthException: ${error.message} (status: ${error.statusCode})',
      );
      throw Exception(_friendlyMessage(error));
    } on PostgrestException catch (error) {
      debugPrint('verifySignInOtp PostgrestException: ${error.message}');
      throw Exception(_friendlyMessage(error));
    } catch (error) {
      debugPrint('verifySignInOtp Error: $error');
      throw Exception(_friendlyMessage(error));
    }
  }

  /// Verify the email signup OTP issued by signUp().
  Future<AuthResponse> verifyEmailOtp({
    required String email,
    required String token,
  }) async {
    try {
      if (email.trim().isEmpty || token.trim().isEmpty) {
        throw Exception('Email and OTP are required.');
      }

      if (!RegExp(r'^\d{6}$').hasMatch(token.trim())) {
        throw Exception('Please enter a valid 6-digit code.');
      }

      debugPrint('VERIFY SIGNUP OTP: email = ${email.trim()}');
      debugPrint('VERIFY SIGNUP OTP: token length = ${token.trim().length}');
      debugPrint('VERIFY SIGNUP OTP: type = OtpType.signup');

      return await _client.auth.verifyOTP(
        email: email.trim(),
        token: token.trim(),
        type: OtpType.signup,
      );
    } on AuthException catch (error) {
      debugPrint(
        'verifyEmailOtp AuthException: ${error.message} (status: ${error.statusCode})',
      );
      throw Exception(_friendlyMessage(error));
    } on PostgrestException catch (error) {
      debugPrint('verifyEmailOtp PostgrestException: ${error.message}');
      throw Exception(_friendlyMessage(error));
    } catch (error) {
      debugPrint('verifyEmailOtp Error: $error');
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
        type: OtpType.signup,
        email: email.trim(),
      );
    } on AuthException catch (error) {
      debugPrint(
        'resendEmailOtp AuthException: ${error.message} (status: ${error.statusCode})',
      );
      throw Exception(_friendlyMessage(error));
    } on PostgrestException catch (error) {
      debugPrint('resendEmailOtp PostgrestException: ${error.message}');
      throw Exception(_friendlyMessage(error));
    } catch (error) {
      debugPrint('resendEmailOtp Error: $error');
      throw Exception(_friendlyMessage(error));
    }
  }

  /// Send a 6-digit OTP for password recovery (no reset link).
  ///
  /// Uses the email OTP endpoint with account creation disabled. The
  /// recovery OTP is verified with [OtpType.recovery].
  Future<void> sendPasswordResetOtp({required String email}) async {
    try {
      if (email.trim().isEmpty) {
        throw Exception('Please enter your email address.');
      }

      await _client.auth.signInWithOtp(
        email: email.trim(),
        shouldCreateUser: false,
      );
    } on AuthException catch (error) {
      debugPrint(
        'sendPasswordResetOtp AuthException: ${error.message} (status: ${error.statusCode})',
      );
      throw Exception(_friendlyMessage(error));
    } on PostgrestException catch (error) {
      debugPrint('sendPasswordResetOtp PostgrestException: ${error.message}');
      throw Exception(_friendlyMessage(error));
    } catch (error) {
      debugPrint('sendPasswordResetOtp Error: $error');
      throw Exception(_friendlyMessage(error));
    }
  }

  /// Resend a password recovery email OTP without creating a user.
  Future<void> resendPasswordResetOtp({required String email}) async {
    try {
      if (email.trim().isEmpty) {
        throw Exception('Please enter your email address.');
      }

      await _client.auth.signInWithOtp(
        email: email.trim(),
        shouldCreateUser: false,
      );
    } on AuthException catch (error) {
      debugPrint(
        'resendPasswordResetOtp AuthException: ${error.message} '
        '(status: ${error.statusCode})',
      );
      throw Exception(_friendlyMessage(error));
    } on PostgrestException catch (error) {
      debugPrint('resendPasswordResetOtp PostgrestException: ${error.message}');
      throw Exception(_friendlyMessage(error));
    } catch (error) {
      debugPrint('resendPasswordResetOtp Error: $error');
      throw Exception(_friendlyMessage(error));
    }
  }

  /// Verify the password recovery OTP.
  Future<AuthResponse> verifyPasswordResetOtp({
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
        type: OtpType.recovery,
      );
    } on AuthException catch (error) {
      debugPrint(
        'verifyPasswordResetOtp AuthException: ${error.message} (status: ${error.statusCode})',
      );
      throw Exception(_friendlyMessage(error));
    } on PostgrestException catch (error) {
      debugPrint('verifyPasswordResetOtp PostgrestException: ${error.message}');
      throw Exception(_friendlyMessage(error));
    } catch (error) {
      debugPrint('verifyPasswordResetOtp Error: $error');
      throw Exception(_friendlyMessage(error));
    }
  }

  /// Update the current user's password.
  /// Requires an active session (e.g. after a successful recovery OTP verify).
  Future<void> updatePassword(String newPassword) async {
    try {
      if (newPassword.isEmpty || newPassword.length < 8) {
        throw Exception('Password must be at least 8 characters long.');
      }

      await _client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } on AuthException catch (error) {
      debugPrint(
        'updatePassword AuthException: ${error.message} (status: ${error.statusCode})',
      );
      throw Exception(_friendlyMessage(error));
    } on PostgrestException catch (error) {
      debugPrint('updatePassword PostgrestException: ${error.message}');
      throw Exception(_friendlyMessage(error));
    } catch (error) {
      debugPrint('updatePassword Error: $error');
      throw Exception(_friendlyMessage(error));
    }
  }

  /// Send password reset email (legacy reset-link flow).
  /// NOTE: Not used by the OTP-based forgot-password flow.
  Future<void> resetPasswordForEmail(String email) async {
    try {
      if (email.trim().isEmpty) {
        throw Exception('Please enter your email address.');
      }

      await _client.auth.resetPasswordForEmail(email.trim());
    } on AuthException catch (error) {
      debugPrint(
        'resetPasswordForEmail AuthException: ${error.message} (status: ${error.statusCode})',
      );
      throw Exception(_friendlyMessage(error));
    } on PostgrestException catch (error) {
      debugPrint('resetPasswordForEmail PostgrestException: ${error.message}');
      throw Exception(_friendlyMessage(error));
    } catch (error) {
      debugPrint('resetPasswordForEmail Error: $error');
      throw Exception(_friendlyMessage(error));
    }
  }

  /// Sign out user
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } on AuthException catch (error) {
      debugPrint(
        'signOut AuthException: ${error.message} (status: ${error.statusCode})',
      );
      throw Exception(_friendlyMessage(error));
    } on PostgrestException catch (error) {
      debugPrint('signOut PostgrestException: ${error.message}');
      throw Exception(_friendlyMessage(error));
    } catch (error) {
      debugPrint('signOut Error: $error');
      throw Exception(_friendlyMessage(error));
    }
  }

  /// Save user profile data to profiles table.
  /// Call this after successful OTP verification.
  /// Uses upsert so repeated verification does not create duplicate rows.
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

      await _client.from('profiles').upsert(dataToInsert);
    } on PostgrestException catch (error) {
      if (error.code != 'PGRST116') {
        throw Exception('Failed to save profile: ${error.message}');
      }
    } catch (error) {
      debugPrint('saveUserProfile Error: $error');
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
      debugPrint('getUserProfile Error: $error');
      throw Exception(_friendlyMessage(error));
    }
  }
}