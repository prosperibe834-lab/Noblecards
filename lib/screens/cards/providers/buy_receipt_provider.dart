import 'package:flutter/material.dart';
import '../models/purchased_gift_card.dart';
import '../services/buy_receipt_service.dart';

enum BuyReceiptState { loading, success, error }

class BuyReceiptProvider extends ChangeNotifier {
  final BuyReceiptService _service = BuyReceiptService();
  
  BuyReceiptState _state = BuyReceiptState.loading;
  PurchasedGiftCard? _receipt;
  String _errorMessage = '';

  BuyReceiptState get state => _state;
  PurchasedGiftCard? get receipt => _receipt;
  String get errorMessage => _errorMessage;

  void loadReceipt(String transactionId) async {
    _state = BuyReceiptState.loading;
    notifyListeners();

    try {
      _receipt = await _service.fetchPurchaseDetails(transactionId);
      _state = BuyReceiptState.success;
    } catch (e) {
      _errorMessage = 'Failed to load receipt.';
      _state = BuyReceiptState.error;
    }
    notifyListeners();
  }
}