// Location: lib/deposit/providers/payment_method_provider.dart
import 'package:flutter/material.dart';
import '../models/payment_method.dart';

class PaymentMethodProvider extends ChangeNotifier {
  PaymentMethod? _selectedMethod;
  bool _isLoading = true;
  List<PaymentMethod> _methods = [];

  PaymentMethodProvider() {
    _loadMethods();
  }

  PaymentMethod? get selectedMethod => _selectedMethod;
  bool get isLoading => _isLoading;
  List<PaymentMethod> get methods => _methods;

  bool get hasValidSelection => _selectedMethod != null;

  void selectMethod(PaymentMethod method) {
    _selectedMethod = method;
    notifyListeners();
  }

  Future<void> _loadMethods() async {
    _isLoading = true;
    notifyListeners();

    // Brief simulation or instant load of supported methods
    await Future.delayed(const Duration(milliseconds: 300));

    _methods = supportedPaymentMethods;
    _isLoading = false;
    notifyListeners();
  }
}
