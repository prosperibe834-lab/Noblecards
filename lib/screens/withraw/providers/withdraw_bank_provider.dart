import 'package:flutter/material.dart';
import '../models/withdraw_bank_models.dart';

class WithdrawBankProvider extends ChangeNotifier {
  // Existing state that should come from WithdrawScreen
  WithdrawalDestination _destination = WithdrawalDestination(
    countryCode: 'NG',
    countryName: 'Nigeria',
    currency: 'NGN',
    flag: '🇳🇬',
  );

  double _amountToSend = 100.00;
  double _exchangeRate = 1650.00;
  double _fee = 1650.00;

  // Form State
  WithdrawalBank? _selectedBank;
  String _accountNumber = '';
  String _accountName = '';
  String _sortCode = '';
  String _routingNumber = '';
  String _institutionNumber = '';
  String _transitNumber = '';
  String _accountType = 'Checking';
  
  bool _isVerifying = false;
  bool _isVerified = false;
  bool _saveAccount = true;
  String? _verificationError;

  // Getters
  WithdrawalDestination get destination => _destination;
  WithdrawalBank? get selectedBank => _selectedBank;
  String get accountNumber => _accountNumber;
  String get accountName => _accountName;
  String get sortCode => _sortCode;
  String get routingNumber => _routingNumber;
  String get institutionNumber => _institutionNumber;
  String get transitNumber => _transitNumber;
  String get accountType => _accountType;
  
  bool get isVerifying => _isVerifying;
  bool get isVerified => _isVerified;
  bool get saveAccount => _saveAccount;
  String? get verificationError => _verificationError;

  double get amountToSend => _amountToSend;
  double get convertedAmount => _destination.countryCode == 'US' 
      ? _amountToSend 
      : _amountToSend * _exchangeRate;
  double get amountToReceive => convertedAmount - _fee;
  double get exchangeRate => _exchangeRate;
  double get fee => _fee;

  // Setters
  void setDestination(WithdrawalDestination dest) {
    _destination = dest;
    _resetVerification();
    notifyListeners();
  }

  void selectBank(WithdrawalBank bank) {
    _selectedBank = bank;
    _resetVerification();
    notifyListeners();
  }

  void updateAccountNumber(String val) {
    _accountNumber = val;
    _resetVerification();
    notifyListeners();
  }

  void updateSortCode(String val) {
    _sortCode = val;
    _resetVerification();
    notifyListeners();
  }

  void updateRoutingNumber(String val) {
    _routingNumber = val;
    _resetVerification();
    notifyListeners();
  }

  void updateInstitutionNumber(String val) {
    _institutionNumber = val;
    _resetVerification();
    notifyListeners();
  }

  void updateTransitNumber(String val) {
    _transitNumber = val;
    _resetVerification();
    notifyListeners();
  }

  void updateAccountName(String val) {
    _accountName = val;
    _resetVerification();
    notifyListeners();
  }

  void toggleSaveAccount(bool val) {
    _saveAccount = val;
    notifyListeners();
  }

  void _resetVerification() {
    _isVerified = false;
    _verificationError = null;
  }

  bool get isFormValid {
    if (_destination.countryCode == 'NG' || _destination.countryCode == 'GH') {
      return _selectedBank != null && _accountNumber.length >= 10;
    } else if (_destination.countryCode == 'GB') {
      return _selectedBank != null && _accountName.isNotEmpty && _sortCode.isNotEmpty && _accountNumber.isNotEmpty;
    } else if (_destination.countryCode == 'US') {
      return _accountName.isNotEmpty && _routingNumber.isNotEmpty && _accountNumber.isNotEmpty;
    } else if (_destination.countryCode == 'CA') {
      return _selectedBank != null && _accountName.isNotEmpty && _institutionNumber.isNotEmpty && _transitNumber.isNotEmpty && _accountNumber.isNotEmpty;
    }
    return false;
  }

  // Verification Mock Service Interface
  Future<void> verifyAccount() async {
    if (!isFormValid) return;
    
    _isVerifying = true;
    _verificationError = null;
    notifyListeners();

    // Simulate API Network call to your resolution endpoint
    await Future.delayed(const Duration(seconds: 2));

    try {
      // Mocking successful verification using actual context data
      _accountName = "Prosper Ibe"; // Replace with actual API response
      _isVerified = true;
      _isVerifying = false;
    } catch (e) {
      _isVerified = false;
      _isVerifying = false;
      _verificationError = "Unable to verify account details. Please check and try again.";
    }
    
    notifyListeners();
  }

  // Masking utility for Review Screen
  String get maskedAccountNumber {
    if (_accountNumber.length < 4) return _accountNumber;
    return '••••••${_accountNumber.substring(_accountNumber.length - 4)}';
  }
}