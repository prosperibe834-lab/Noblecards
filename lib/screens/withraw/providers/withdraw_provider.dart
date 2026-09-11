import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../models/withdraw_country.dart';
import '../models/withdraw_method.dart';

class WithdrawProvider extends ChangeNotifier {
  // Mock Data mimicking a fetched state
  final double availableBalance = 2450.80;
  bool isBalanceVisible = true;
  bool isLoading = false;

  String amountText = '100.00';

  final List<WithdrawCountry> supportedCountries = [
    WithdrawCountry(
      id: 'NG',
      name: 'Nigeria',
      currency: 'NGN',
      exchangeRate: 1650.00,
      flagInitials: 'NG',
      supportedMethodIds: ['bank', 'momo'],
    ),
    WithdrawCountry(
      id: 'GH',
      name: 'Ghana',
      currency: 'GHS',
      exchangeRate: 12.50,
      flagInitials: 'GH',
      supportedMethodIds: ['bank', 'momo'],
    ),
    WithdrawCountry(
      id: 'GB',
      name: 'United Kingdom',
      currency: 'GBP',
      exchangeRate: 0.78,
      flagInitials: 'GB',
      supportedMethodIds: ['bank'],
    ),
    WithdrawCountry(
      id: 'US',
      name: 'United States',
      currency: 'USD',
      exchangeRate: 1.00,
      flagInitials: 'US',
      supportedMethodIds: ['bank'],
    ),
    WithdrawCountry(
      id: 'CA',
      name: 'Canada',
      currency: 'CAD',
      exchangeRate: 1.35,
      flagInitials: 'CA',
      supportedMethodIds: ['bank'],
    ),
  ];

  final List<WithdrawMethod> allMethods = [
    WithdrawMethod(
      id: 'bank',
      name: 'Bank Transfer',
      subtitle: 'To your bank account',
      icon: Boxicons.bxs_bank,
    ),
    WithdrawMethod(
      id: 'momo',
      name: 'Mobile Money',
      subtitle: 'To your mobile wallet',
      icon: Boxicons.bx_mobile_alt,
    ),
  ];

  late WithdrawCountry selectedCountry;
  WithdrawMethod? selectedMethod;

  WithdrawProvider() {
    selectedCountry = supportedCountries.first;
    _updateAvailableMethods();
  }

  double get parsedAmount => double.tryParse(amountText) ?? 0.0;

  double get convertedAmount => parsedAmount * selectedCountry.exchangeRate;

  // Assuming a 1% fee for demonstration based on the mockup (1650 fee on 165000)
  double get withdrawalFee => convertedAmount * 0.01;

  double get amountReceived => convertedAmount - withdrawalFee;

  void toggleBalanceVisibility() {
    isBalanceVisible = !isBalanceVisible;
    notifyListeners();
  }

  void setAmount(String amount) {
    amountText = amount;
    notifyListeners();
  }

  void setMaxAmount() {
    amountText = availableBalance.toStringAsFixed(2);
    notifyListeners();
  }

  void selectCountry(WithdrawCountry country) {
    selectedCountry = country;
    _updateAvailableMethods();
    notifyListeners();
  }

  void selectMethod(WithdrawMethod method) {
    selectedMethod = method;
    notifyListeners();
  }

  void _updateAvailableMethods() {
    final available = allMethods
        .where((m) => selectedCountry.supportedMethodIds.contains(m.id))
        .toList();

    if (available.isNotEmpty) {
      if (selectedMethod == null || !available.contains(selectedMethod)) {
        selectedMethod = available.first;
      }
    } else {
      selectedMethod = null;
    }
  }

  Future<void> reloadData() async {
    isLoading = true;
    notifyListeners();
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    isLoading = false;
    notifyListeners();
  }
}
