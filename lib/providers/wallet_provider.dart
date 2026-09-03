// lib/providers/wallet_provider.dart
import 'package:flutter/material.dart';
import '../services/wallet_service.dart';

class WalletProvider extends ChangeNotifier {
  final WalletService _walletService;
  double _balance = 0.00;
  bool _isLoading = false;
  String? _errorMessage;

  WalletProvider({WalletService? walletService})
    : _walletService = walletService ?? WalletService() {
    refresh();
  }

  double get balance => _balance;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> refresh() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _balance = await _walletService.getUsdBalance();
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addFunds(double amount) {
    _balance += amount;
    notifyListeners();
  }
}
