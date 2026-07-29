// lib/providers/wallet_provider.dart
import 'package:flutter/material.dart';

class WalletProvider extends ChangeNotifier {
  double _balance = 0.00;

  double get balance => _balance;

  void addFunds(double amount) {
    _balance += amount;
    notifyListeners();
  }
}