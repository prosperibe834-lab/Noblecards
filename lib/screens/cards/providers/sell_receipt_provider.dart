import 'package:flutter/material.dart';
import '../models/sell_receipt_model.dart';
import '../services/sell_receipt_service.dart';

enum ReceiptState { loading, success, error, offline, empty }

class SellReceiptProvider extends ChangeNotifier {
  final SellReceiptService _service = SellReceiptService();
  
  ReceiptState _state = ReceiptState.loading;
  SellReceiptModel? _receipt;
  String _errorMessage = '';

  ReceiptState get state => _state;
  SellReceiptModel? get receipt => _receipt;
  String get errorMessage => _errorMessage;

  void loadReceipt(String transactionId) async {
    _state = ReceiptState.loading;
    notifyListeners();

    try {
      _receipt = await _service.fetchReceipt(transactionId);
      _state = _receipt != null ? ReceiptState.success : ReceiptState.empty;
    } catch (e) {
      _errorMessage = 'Failed to load receipt. Please try again.';
      _state = ReceiptState.error;
    }
    notifyListeners();
  }
}