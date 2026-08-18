import 'package:flutter/foundation.dart';

class AuthenticationService {
  /// Simulates an API call to send a password reset OTP code to the provided email.
  Future<bool> sendPasswordResetCode(String email) async {
    try {
      // TODO: Replace with actual Firebase or Backend API call
      // Example: await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      
      // Simulating network delay
      await Future.delayed(const Duration(seconds: 2));

      // Simulating a successful response
      return true;
    } catch (e) {
      debugPrint('Error sending OTP code: $e');
      // Throw formatted error to be caught by the UI
      throw Exception('Unable to send the verification code. Please check your internet connection and try again.');
    }
  }
}