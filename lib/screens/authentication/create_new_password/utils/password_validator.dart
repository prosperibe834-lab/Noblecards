import '../models/password_strength.dart';

class PasswordValidator {
  PasswordValidator._();

  static PasswordValidationState evaluate(String password) {
    if (password.isEmpty) {
      return const PasswordValidationState();
    }

    final bool hasMinLength = password.length >= 8;
    final bool hasUpper = password.contains(RegExp(r'[A-Z]'));
    final bool hasLower = password.contains(RegExp(r'[a-z]'));
    final bool hasDigit = password.contains(RegExp(r'[0-9]'));
    final bool hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    
    final bool hasUpperAndLower = hasUpper && hasLower;
    final bool hasDigitAndSpecial = hasDigit && hasSpecial;

    int score = 0;
    if (hasMinLength) score++;
    if (hasUpperAndLower) score++;
    if (hasDigitAndSpecial) score++;
    if (password.length > 12) score++;

    PasswordStrengthLevel level;
    if (score == 0) {
      level = PasswordStrengthLevel.weak;
    } else if (score == 1 || score == 2) {
      level = PasswordStrengthLevel.medium;
    } else if (score == 3) {
      level = PasswordStrengthLevel.strong;
    } else {
      level = PasswordStrengthLevel.veryStrong;
    }

    // Edge case: Short passwords are automatically weak regardless of content
    if (!hasMinLength) level = PasswordStrengthLevel.weak;

    return PasswordValidationState(
      hasMinLength: hasMinLength,
      hasUpperAndLower: hasUpperAndLower,
      hasDigitAndSpecial: hasDigitAndSpecial,
      avoidsPersonalInfo: true, // Placeholder for backend check
      strengthLevel: level,
    );
  }
}