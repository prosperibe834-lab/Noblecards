import '../../services/authentication_service.dart';

abstract class BasePasswordResetService {
  Future<void> sendPasswordResetEmail(String email);
}

class PasswordResetService implements BasePasswordResetService {
  final AuthenticationService _authenticationService = AuthenticationService();

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _authenticationService.resetPasswordForEmail(email);
  }
}