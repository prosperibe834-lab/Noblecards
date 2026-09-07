import 'package:flutter/material.dart';
import '../../authentication/services/authentication_service.dart';

class CreatePinProvider extends ChangeNotifier {
  final AuthenticationService _authService;
  String _pin = '';
  bool _isLoading = false;
  String? _errorMessage;

  CreatePinProvider({AuthenticationService? authService})
    : _authService = authService ?? AuthenticationService();

  String get pin => _pin;
  bool get isLoading => _isLoading;
  bool get isComplete => _pin.length == 4;
  String? get errorMessage => _errorMessage;

  void addDigit(String digit) {
    if (_pin.length < 4 && !_isLoading) {
      _pin += digit;
      notifyListeners();
    }
  }

  void removeDigit() {
    if (_pin.isNotEmpty && !_isLoading) {
      _pin = _pin.substring(0, _pin.length - 1);
      notifyListeners();
    }
  }

  void clearPin() {
    _pin = '';
    notifyListeners();
  }

  Future<bool> submitPin() async {
    if (!isComplete) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.createTransactionPin(_pin);
      return true;
    } catch (error) {
      _errorMessage = error.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
