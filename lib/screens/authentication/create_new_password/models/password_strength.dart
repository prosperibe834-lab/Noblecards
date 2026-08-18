enum PasswordStrengthLevel { empty, weak, medium, strong, veryStrong }

class PasswordValidationState {
  final bool hasMinLength;
  final bool hasUpperAndLower;
  final bool hasDigitAndSpecial;
  final bool avoidsPersonalInfo;
  final PasswordStrengthLevel strengthLevel;

  const PasswordValidationState({
    this.hasMinLength = false,
    this.hasUpperAndLower = false,
    this.hasDigitAndSpecial = false,
    this.avoidsPersonalInfo = true, // Defaults to true until we have personal info to check against
    this.strengthLevel = PasswordStrengthLevel.empty,
  });

  bool get isFullyValid => 
      hasMinLength && hasUpperAndLower && hasDigitAndSpecial && avoidsPersonalInfo;
}