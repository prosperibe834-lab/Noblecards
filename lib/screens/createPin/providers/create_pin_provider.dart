import 'package:flutter/material.dart';

class CreatePinProvider extends ChangeNotifier {
  String _pin = '';
  bool _isLoading = false;

  String get pin => _pin;
  bool get isLoading => _isLoading;
  bool get isComplete => _pin.length == 4;

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
    notifyListeners();

    // Simulate network/security processing delay
    // DO NOT print or log the PIN here in production.
    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();

    return true; // Return true on success to trigger the modal
  }
}