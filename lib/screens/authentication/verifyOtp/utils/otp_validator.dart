class OtpValidator {
  OtpValidator._();

  static bool isValidLength(String otp) {
    return otp.length == 6;
  }

  static bool isNumericOnly(String otp) {
    return RegExp(r'^[0-9]+$').hasMatch(otp);
  }

  static bool isFullyValid(String otp) {
    return isValidLength(otp) && isNumericOnly(otp);
  }
}