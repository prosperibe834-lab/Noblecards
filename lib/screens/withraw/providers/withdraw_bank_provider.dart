import 'package:flutter/material.dart';
import '../../authentication/services/authentication_service.dart';
import '../models/withdraw_bank_models.dart';

class WithdrawBankProvider extends ChangeNotifier {
  final AuthenticationService _authService;
  AuthenticationService get authService => _authService;
  String _paymentMethod;

  WithdrawBankProvider({
    AuthenticationService? authService,
    WithdrawalDestination? destination,
    double sourceAmount = 100.00,
    String paymentMethod = 'BANK_TRANSFER',
  })  : _authService = authService ?? AuthenticationService(),
        _destination = destination ?? WithdrawalDestination(
          countryCode: 'NG',
          countryName: 'Nigeria',
          currency: 'NGN',
          flag: '🇳🇬',
        ),
        _paymentMethod = paymentMethod,
        _amountToSend = sourceAmount {
    loadBanks();
  }

  // Existing state that should come from WithdrawScreen
  WithdrawalDestination _destination;

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
  String? _quoteId;
  double? _quotedDestinationAmount;
  double? _quotedRecipientAmount;
  double? _quotedExchangeRate;
  double? _quotedFee;
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
  String? get quoteId => _quoteId;

  double get amountToSend => _amountToSend;
    double get convertedAmount => _quotedDestinationAmount ?? (_destination.countryCode == 'US'
      ? _amountToSend
      : _amountToSend * _exchangeRate);
    double get amountToReceive => _quotedRecipientAmount ?? (convertedAmount - _fee);
    double get exchangeRate => _quotedExchangeRate ?? _exchangeRate;
    double get fee => _quotedFee ?? _fee;

  // Setters
  void setDestination(WithdrawalDestination dest, {String paymentMethod = 'BANK_TRANSFER'}) {
    _destination = dest;
    _paymentMethod = paymentMethod;
    _clearIncompatibleState();
    _resetVerification();
    _isLoadingBanks = true;
    notifyListeners();
    loadBanks();
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

  void _clearIncompatibleState() {
    _selectedBank = null;
    _banks = [];
    _accountNumber = '';
    _accountName = '';
    _sortCode = '';
    _routingNumber = '';
    _institutionNumber = '';
    _transitNumber = '';
    _isVerified = false;
    _verificationError = null;
    _beneficiaryId = null;
    _quoteId = null;
    _quotedDestinationAmount = null;
    _quotedRecipientAmount = null;
    _quotedExchangeRate = null;
    _quotedFee = null;
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
    _isLoadingBanks = true;
    _banks = [];
    _selectedBank = null;
    notifyListeners();

    try {
      final isNigeriaBankRoute = _paymentMethod == 'BANK_TRANSFER'
          && _destination.countryCode.toUpperCase() == 'NG'
          && _destination.currency.toUpperCase() == 'NGN';

      if (!isNigeriaBankRoute) {
        _banks = [];
        _selectedBank = null;
        return;
      }

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
      final accountName = data['accountHolderName']?.toString() ?? '';
      if (accountName.isEmpty) {
        throw Exception('Account holder name was not returned.');
      }

      _accountName = accountName;
      _isVerified = true;
      _verificationError = null;
    } catch (e) {
      _isVerified = false;
      _verificationError = e.toString().replaceFirst('Exception: ', '').replaceFirst('BadRequestException: ', '').trim();
      if (_verificationError == null || _verificationError!.isEmpty) {
        _verificationError = 'Unable to verify account details. Please check and try again.';
      }
      _isVerifying = false;
      notifyListeners();
      throw Exception(_verificationError);
    } finally {
      _isVerifying = false;
      notifyListeners();
    }
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

  Future<void> createQuote() async {
    if (!_isVerified || _beneficiaryId == null) {
      throw Exception('Verify and save the withdrawal account first.');
    }

    final quote = await _authService.authenticatedPost(
      '/withdrawals/quotes',
      body: {
        'sourceAmount': _amountToSend.toStringAsFixed(2),
        'countryCode': _destination.countryCode,
        'destinationCurrencyCode': _destination.currency,
        'paymentMethod': 'BANK_TRANSFER',
        'idempotencyKey': 'quote-${DateTime.now().millisecondsSinceEpoch}',
      },
    );
    final id = quote['id']?.toString();
    if (id == null || id.isEmpty || quote['status']?.toString() != 'ACTIVE' || quote['usable'] != true) {
      throw Exception('A usable withdrawal quote was not created.');
    }

    _quoteId = id;
    _quotedDestinationAmount = double.tryParse(quote['grossDestinationAmount']?.toString() ?? '');
    _quotedRecipientAmount = double.tryParse(quote['recipientAmount']?.toString() ?? '');
    _quotedExchangeRate = double.tryParse(quote['fxRate']?.toString() ?? '');
    _quotedFee = double.tryParse(quote['totalFee']?.toString() ?? '');
    notifyListeners();
  }

  Future<Map<String, dynamic>> createWithdrawal(String pin) async {
    if (!_isVerified || _beneficiaryId == null || _quoteId == null) {
      throw Exception('Verify, save the withdrawal account, and create a quote first.');
    }

    return _authService.authenticatedPost(
      '/withdrawals',
      body: {
        'quoteId': _quoteId,
        'beneficiaryId': _beneficiaryId,
        'idempotencyKey': 'withdrawal-${DateTime.now().millisecondsSinceEpoch}',
        'pin': pin,
      },
    );
  }

  // Masking utility for Review Screen
  String get maskedAccountNumber {
    if (_accountNumber.length < 4) return _accountNumber;
    return '••••••${_accountNumber.substring(_accountNumber.length - 4)}';
  }
}