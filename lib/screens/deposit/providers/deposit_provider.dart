// Location: lib/deposit/providers/deposit_provider.dart
import 'package:flutter/material.dart';
import '../models/deposit_currency.dart';

class DepositProvider extends ChangeNotifier {
  bool _isBalanceVisible = true;
  DepositCurrency _selectedCurrency = supportedCurrencies[0]; // Default NGN
  double _manualAmount = 10.0;
  double? _selectedQuickAmount = 10.0;

  // Wallet balance in USD (synced from backend/wallet provider)
  double _baseWalletBalanceUsd = 0.0;

  DepositProvider({double initialWalletBalanceUsd = 0.0}) {
    _baseWalletBalanceUsd = initialWalletBalanceUsd;
    _manualAmount = 10.0;
    _selectedQuickAmount = 10.0;
  }

  void updateWalletBalance(double balanceUsd) {
    _baseWalletBalanceUsd = balanceUsd;
    notifyListeners();
  }

  bool get isBalanceVisible => _isBalanceVisible;
  DepositCurrency get selectedCurrency => _selectedCurrency;
  double get manualAmount => _manualAmount;
  double? get selectedQuickAmount => _selectedQuickAmount;
  double get baseWalletBalanceUsd => _baseWalletBalanceUsd;

  // Calculate wallet balance in selected currency
  double get convertedWalletBalance =>
      _baseWalletBalanceUsd * _selectedCurrency.exchangeRateToBase;

  // Calculate equivalent of entered deposit amount (to base USD, or local if base is NGN)
  double get equivalentDepositAmount {
    if (_selectedCurrency.code == 'NGN') return _manualAmount;
    // Just for demo display - shows how much it is in NGN equivalent
    return _manualAmount * (1650.0 / _selectedCurrency.exchangeRateToBase);
  }

  // Calculate USD value of entered deposit amount
  double get amountInUsd {
    if (_manualAmount <= 0) return 0.0;
    if (_selectedCurrency.code == 'USD') return _manualAmount;
    if (_selectedCurrency.exchangeRateToBase > 0) {
      return _manualAmount / _selectedCurrency.exchangeRateToBase;
    }
    return _manualAmount;
  }

  void toggleBalanceVisibility() {
    _isBalanceVisible = !_isBalanceVisible;
    notifyListeners();
  }

  void setCurrency(DepositCurrency currency) {
    _selectedCurrency = currency;
    _manualAmount = 0.0; // Reset amount on currency change
    _selectedQuickAmount = null;
    notifyListeners();
  }

  void setManualAmount(double amount) {
    _manualAmount = amount;
    _selectedQuickAmount = null; // Unselect quick amount if typing manually
    notifyListeners();
  }

  void setQuickAmount(double amount) {
    _manualAmount = amount;
    _selectedQuickAmount = amount;
    notifyListeners();
  }

  bool get isValidAmount => _manualAmount > 0;
}
