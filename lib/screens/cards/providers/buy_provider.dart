import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/buy_order_model.dart';
import '../services/buy_service.dart';

class BuyProvider extends ChangeNotifier {
  final BuyService _service = BuyService();

  double _amount = 100.0;
  int _quantity = 1;
  double _currentRate = 93.20;
  bool _isLoadingRate = false;

  double get amount => _amount;
  int get quantity => _quantity;
  double get currentRate => _currentRate;
  bool get isLoadingRate => _isLoadingRate;

  double get totalToPay => _amount * _quantity * (_currentRate / 100);

  void setAmount(double newAmount) {
    _amount = newAmount;
    HapticFeedback.lightImpact();
    notifyListeners();
  }

  void incrementQuantity() {
    _quantity++;
    HapticFeedback.lightImpact();
    notifyListeners();
  }

  void decrementQuantity() {
    if (_quantity > 1) {
      _quantity--;
      HapticFeedback.lightImpact();
      notifyListeners();
    }
  }

  Future<void> refreshRate() async {
    _isLoadingRate = true;
    notifyListeners();

    _currentRate = await _service.fetchCurrentRate();

    _isLoadingRate = false;
    notifyListeners();
  }
}
