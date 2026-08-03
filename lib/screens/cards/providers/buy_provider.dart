import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/buy_order_model.dart';
import '../models/gift_card_region_model.dart';
import '../services/buy_service.dart';

class BuyProvider extends ChangeNotifier {
  final BuyService _service = BuyService();

  double _amount = 100.0;
  int _quantity = 1;
  double _currentRate = 93.20;
  bool _isLoadingRate = false;
  GiftCardRegionModel? _selectedRegion;
  String _currencyCode = 'USD';
  String _currencySymbol = '\$';
  List<String> _availableDenominations = const ['10', '25', '50', '100', '200'];

  double get amount => _amount;
  int get quantity => _quantity;
  double get currentRate => _currentRate;
  bool get isLoadingRate => _isLoadingRate;
  GiftCardRegionModel? get selectedRegion => _selectedRegion;
  String get currencyCode => _currencyCode;
  String get currencySymbol => _currencySymbol;
  List<String> get availableDenominations => _availableDenominations;

  double get totalToPay => _amount * _quantity * (_currentRate / 100);

  void setAmount(double newAmount) {
    _amount = newAmount;
    HapticFeedback.lightImpact();
    notifyListeners();
  }

  void setRegion(GiftCardRegionModel region) {
    _selectedRegion = region;
    _currentRate = region.buyRate;
    _currencyCode = region.currencyCode;
    _currencySymbol = region.currencySymbol;
    _availableDenominations = List<String>.from(region.availableDenominations);
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
