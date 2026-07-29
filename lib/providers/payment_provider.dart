// lib/providers/payment_provider.dart
import 'package:flutter/material.dart';

class PaymentProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Verify OTP for Card/3DS transactions
  Future<bool> verifyCardOtp({
    required String otp,
    required String cardLast4,
    required double amount,
    required String currency,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate or make your backend API call here
      await Future.delayed(const Duration(seconds: 2));

      if (otp.length < 6) {
        _errorMessage = 'Invalid OTP entered. Please try again.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _isLoading = false;
      notifyListeners();
      return true; // Success
    } catch (e) {
      _errorMessage = 'Payment authorization failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> processMobileWalletPayment(
    dynamic paymentResult,
    double amount,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      if (amount <= 0) {
        _errorMessage = 'Invalid payment amount.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Mobile wallet payment failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}