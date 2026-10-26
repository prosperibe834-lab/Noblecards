// lib/providers/wallet_provider.dart
import 'package:flutter/material.dart';
import '../services/wallet_service.dart';

class WalletProvider extends ChangeNotifier {
  final WalletService _walletService;
  double _balance = 78012.60;
  double _availableBalance = 78012.60;
  double _pendingBalance = 5900.00;
  bool _isLoading = false;
  String? _errorMessage;

  WalletProvider({WalletService? walletService})
    : _walletService = walletService ?? WalletService() {
    final cached = WalletService.cachedBalances;
    if (cached != null) {
      _balance = cached.availableBalance;
      _availableBalance = cached.availableBalance;
      _pendingBalance = cached.pendingBalance;
    }
    refresh();
  }

  double get balance => _balance;
  double get availableBalance => _availableBalance;
  double get pendingBalance => _pendingBalance;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> refresh() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final balances = await _walletService.getUsdWalletBalances();
      _balance = balances.availableBalance;
      _availableBalance = balances.availableBalance;
      _pendingBalance = balances.pendingBalance;
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addFunds(double amount) {
    _balance += amount;
    _availableBalance += amount;
    notifyListeners();
  }
}
