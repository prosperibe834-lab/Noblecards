import 'package:flutter/material.dart';
import '../../authentication/services/authentication_service.dart';
import '../models/withdraw_bank_models.dart';

class WithdrawBankProvider extends ChangeNotifier {
  final AuthenticationService _authService;

  WithdrawBankProvider({AuthenticationService? authService})
      : _authService = authService ?? AuthenticationService() {
    loadBanks();
  }

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
  List<WithdrawalBank> _banks = [];
  String? _beneficiaryId;
  bool _isLoadingBanks = true;

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
  List<WithdrawalBank> get banks => List.unmodifiable(_banks);
  bool get isLoadingBanks => _isLoadingBanks;
  String? get beneficiaryId => _beneficiaryId;

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

  Future<void> loadBanks() async {
    try {
      final data = await _authService.authenticatedGet(
        '/withdrawals/banks?countryCode=NG&currencyCode=NGN',
      );
      final rawBanks = data['banks'] as List<dynamic>? ?? [];
      _banks = rawBanks.whereType<Map<String, dynamic>>().map((bank) {
        return WithdrawalBank(
          id: bank['id']?.toString() ?? bank['code'].toString(),
          name: bank['name']?.toString() ?? '',
          code: bank['code']?.toString() ?? '',
        );
      }).where((bank) => bank.name.isNotEmpty && bank.code.isNotEmpty).toList();
    } catch (error) {
      _verificationError = 'Unable to load banks. Please try again.';
    } finally {
      _isLoadingBanks = false;
      notifyListeners();
    }
  }

  Future<void> verifyAccount() async {
    if (!isFormValid) return;
    
    _isVerifying = true;
    _verificationError = null;
    notifyListeners();

    try {
      final data = await _authService.authenticatedPost(
        '/withdrawals/beneficiaries/verify',
        body: {
          'countryCode': _destination.countryCode,
          'currencyCode': _destination.currency,
          'method': 'BANK_TRANSFER',
          'institutionCode': _selectedBank!.code,
          'institutionName': _selectedBank!.name,
          'accountNumber': _accountNumber,
        },
      );
      _accountName = data['accountHolderName']?.toString() ?? '';
      if (_accountName.isEmpty) throw Exception('Account holder name was not returned.');
      _isVerified = true;
      _isVerifying = false;
    } catch (e) {
      _isVerified = false;
      _isVerifying = false;
      _verificationError = "Unable to verify account details. Please check and try again.";
    }
    
    notifyListeners();
  }

  Future<void> saveBeneficiary() async {
    if (!_isVerified || _selectedBank == null) {
      throw Exception('Verify the account before saving it.');
    }
    final data = await _authService.authenticatedPost(
      '/withdrawals/beneficiaries',
      body: {
        'countryCode': _destination.countryCode,
        'currencyCode': _destination.currency,
        'method': 'BANK_TRANSFER',
        'type': 'BANK_ACCOUNT',
        'institutionCode': _selectedBank!.code,
        'institutionName': _selectedBank!.name,
        'accountHolderName': _accountName,
        'accountNumber': _accountNumber,
      },
    );
    _beneficiaryId = data['id']?.toString();
  }

  // Masking utility for Review Screen
  String get maskedAccountNumber {
    if (_accountNumber.length < 4) return _accountNumber;
    return '••••••${_accountNumber.substring(_accountNumber.length - 4)}';
  }
}