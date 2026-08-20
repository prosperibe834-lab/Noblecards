import '../../services/authentication_service.dart';

abstract class BasePasswordResetService {
  Future<void> sendPasswordResetOtp(String email);
}

class PasswordResetService implements BasePasswordResetService {
  final AuthenticationService _authenticationService = AuthenticationService();

  @override
  Future<void> sendPasswordResetOtp(String email) async {
    await _authenticationService.sendPasswordResetOtp(email: email);
  }
}