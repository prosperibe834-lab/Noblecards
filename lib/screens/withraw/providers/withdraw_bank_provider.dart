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
    String? initialQuoteId,
  }) : _authService = authService ?? AuthenticationService(),
       _destination =
           destination ??
           WithdrawalDestination(
             countryCode: 'NG',
             countryName: 'Nigeria',
             currency: 'NGN',
             flag: '🇳🇬',
           ),
       _paymentMethod = paymentMethod,
       _amountToSend = sourceAmount,
       _quoteId = initialQuoteId {
    loadBanks();
  }

  void updateInstitutionName(String val) {
    _institutionName = val;
    _resetVerification();
    notifyListeners();
  }

  void updateSwiftCode(String val) {
    _swiftCode = val;
    _resetVerification();
    notifyListeners();
  }

  void updateAccountType(String val) {
    _accountType = val;
    _resetVerification();
    notifyListeners();
  }

  void updateStreetNumber(String val) {
    _streetNumber = val;
    _resetVerification();
    notifyListeners();
  }

  void updateStreetName(String val) {
    _streetName = val;
    _resetVerification();
    notifyListeners();
  }

  void updateCity(String val) {
    _city = val;
    _resetVerification();
    notifyListeners();
  }

  void updateState(String val) {
    _state = val;
    _resetVerification();
    notifyListeners();
  }

  void updatePostalCode(String val) {
    _postalCode = val;
    _resetVerification();
    notifyListeners();
  }

  void updateTransferReason(String val) {
    _transferReason = val;
    _resetVerification();
    notifyListeners();
  }

  @override
  void dispose() {
    _bankRequestGeneration++;
    _branchRequestGeneration++;
    super.dispose();
  }

  // Existing state that should come from WithdrawScreen
  WithdrawalDestination _destination;
  int _bankRequestGeneration = 0;
  int _branchRequestGeneration = 0;

  final double _amountToSend;
  final String _withdrawalIdempotencyKey =
      'withdrawal-${DateTime.now().microsecondsSinceEpoch}';
  // Form State
  WithdrawalBank? _selectedBank;
  String _accountNumber = '';
  String _accountName = '';
  String _sortCode = '';
  String _routingNumber = '';
  String _institutionNumber = '';
  String _transitNumber = '';
  String _institutionName = '';
  String _swiftCode = '';
  String _accountType = '';
  String _streetNumber = '';
  String _streetName = '';
  String _city = '';
  String _state = '';
  String _postalCode = '';
  String _transferReason = '';

  bool _isVerifying = false;
  bool _isVerified = false;
  bool _saveAccount = false;
  String? _verificationError;
  String? _bankError;
  String? _branchError;
  List<WithdrawalBank> _banks = [];
  List<WithdrawalBranch> _branches = [];
  WithdrawalBranch? _selectedBranch;
  List<SavedBeneficiary> _savedBeneficiaries = [];
  SavedBeneficiary? _selectedSavedBeneficiary;
  bool _isLoadingBeneficiaries = false;
  bool _useManualAccount = false;
  String? _beneficiaryId;
  String? _quoteId;
  double? _quotedDestinationAmount;
  double? _quotedRecipientAmount;
  double? _quotedExchangeRate;
  double? _quotedFee;
  bool _isLoadingBanks = true;
  bool _isLoadingBranches = false;
  bool _manualDetailsSaved = false;

  // Getters
  WithdrawalDestination get destination => _destination;
  WithdrawalBank? get selectedBank => _selectedBank;
  WithdrawalBranch? get selectedBranch => _selectedBranch;
  List<SavedBeneficiary> get savedBeneficiaries =>
      List.unmodifiable(_savedBeneficiaries);
  SavedBeneficiary? get selectedSavedBeneficiary => _selectedSavedBeneficiary;
  bool get isLoadingBeneficiaries => _isLoadingBeneficiaries;
  bool get useManualAccount => _useManualAccount;
  bool get hasSavedBeneficiaries => _savedBeneficiaries.isNotEmpty;
  String get accountNumber => _accountNumber;
  String get accountName => _accountName;
  String get sortCode => _sortCode;
  String get routingNumber => _routingNumber;
  String get institutionNumber => _institutionNumber;
  String get transitNumber => _transitNumber;
  String get institutionName => _institutionName;
  String get swiftCode => _swiftCode;
  String get accountType => _accountType;
  String get streetNumber => _streetNumber;
  String get streetName => _streetName;
  String get city => _city;
  String get state => _state;
  String get postalCode => _postalCode;
  String get transferReason => _transferReason;

  bool get isVerifying => _isVerifying;
  bool get isVerified => _isVerified;
  bool get saveAccount => _saveAccount;
  String? get verificationError => _verificationError;
  String? get bankError => _bankError;
  String get bankErrorMessage {
    final error = _bankError ?? '';
    final providerFailure = RegExp(
      r'HTTP (\d{3}): ([^\r\n]+)',
    ).firstMatch(error);
    if (providerFailure != null) {
      return 'Flutterwave bank request failed (HTTP ${providerFailure.group(1)}): ${providerFailure.group(2)}';
    }
    if (error.contains('PAYOUT_PROVIDER_UNAVAILABLE')) {
      return 'Flutterwave could not be reached. Check the backend connection and retry.';
    }
    return 'Unable to load banks. Check your connection and retry.';
  }

  String? get branchError => _branchError;
  List<WithdrawalBank> get banks => List.unmodifiable(_banks);
  List<WithdrawalBranch> get branches => List.unmodifiable(_branches);
  bool get isLoadingBanks => _isLoadingBanks;
  bool get isLoadingBranches => _isLoadingBranches;
  bool get manualDetailsSaved => _manualDetailsSaved;
  String? get beneficiaryId => _beneficiaryId;
  String? get quoteId => _quoteId;
  bool get isManualDetailsOnly =>
      const {'GB', 'US', 'CA'}.contains(_destination.countryCode);
  String get manualPayoutNotice => _destination.countryCode == 'CA'
      ? 'Canadian details can be saved, but CAD payout is not yet enabled.'
      : 'Bank details can be saved, but this payout corridor is not yet enabled.';

  double get amountToSend => _amountToSend;
  double get convertedAmount => _quotedDestinationAmount ?? 0;
  double get amountToReceive => _quotedRecipientAmount ?? 0;
  double get exchangeRate => _quotedExchangeRate ?? 0;
  double get fee => _quotedFee ?? 0;

  // Setters
  void setDestination(
    WithdrawalDestination dest, {
    String paymentMethod = 'BANK_TRANSFER',
  }) {
    _destination = dest;
    _paymentMethod = paymentMethod;
    _clearIncompatibleState();
    _resetVerification();
    _isLoadingBanks = true;
    notifyListeners();
    loadBanks();
  }

  void selectBank(WithdrawalBank bank) {
    _branchRequestGeneration++;
    _selectedBank = bank;
    _branches = [];
    _selectedBranch = null;
    _branchError = null;
    _isLoadingBranches = bank.hasBranches;
    _resetVerification();
    notifyListeners();
    if (bank.hasBranches) {
      loadBranches();
    }
  }

  void selectBranch(WithdrawalBranch branch) {
    _selectedBranch = branch;
    _resetVerification();
    notifyListeners();
  }

  bool _quoteMatchesRequest(Map<String, dynamic> quote) {
    final expiresAt = DateTime.tryParse(quote['expiresAt']?.toString() ?? '');
    final providerFee = _parseAmount(quote['providerFee']);
    final nobleCardsFee = _parseAmount(quote['nobleCardsFee']);
    final totalFee = _parseAmount(quote['totalFee']);
    final grossAmount = _parseAmount(quote['grossDestinationAmount']);
    final destinationFee = _parseAmount(quote['destinationFee']);
    final recipientAmount = _parseAmount(quote['recipientAmount']);
    return quote['usable'] == true &&
        quote['status']?.toString() == 'ACTIVE' &&
        quote['countryCode']?.toString() == _destination.countryCode &&
        quote['destinationCurrency']?.toString() == _destination.currency &&
        quote['paymentMethod']?.toString() == _paymentMethod &&
        _parseAmount(quote['sourceAmount']) == _amountToSend &&
        expiresAt != null &&
        expiresAt.isAfter(DateTime.now()) &&
        (_parseAmount(quote['fxRate']) ?? 0) > 0 &&
        providerFee != null &&
        providerFee >= 0 &&
        nobleCardsFee != null &&
        nobleCardsFee >= 0 &&
        totalFee != null &&
        totalFee >= 0 &&
        grossAmount != null &&
        grossAmount > 0 &&
        destinationFee != null &&
        destinationFee >= 0 &&
        recipientAmount != null &&
        recipientAmount >= 0 &&
        (totalFee * 100).round() ==
            ((providerFee + nobleCardsFee) * 100).round() &&
        (grossAmount * 100).round() ==
            ((destinationFee + recipientAmount) * 100).round();
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
    _branchRequestGeneration++;
    _selectedBank = null;
    _selectedBranch = null;
    _banks = [];
    _branches = [];
    _savedBeneficiaries = [];
    _selectedSavedBeneficiary = null;
    _isLoadingBeneficiaries = false;
    _useManualAccount = false;
    _accountNumber = '';
    _accountName = '';
    _sortCode = '';
    _routingNumber = '';
    _institutionNumber = '';
    _transitNumber = '';
    _institutionName = '';
    _swiftCode = '';
    _accountType = '';
    _streetNumber = '';
    _streetName = '';
    _city = '';
    _state = '';
    _postalCode = '';
    _transferReason = '';
    _manualDetailsSaved = false;
    _saveAccount = false;
    _isVerified = false;
    _verificationError = null;
    _bankError = null;
    _branchError = null;
    _isLoadingBranches = false;
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
    if (_selectedSavedBeneficiary != null && !_useManualAccount) {
      return true;
    }
    if (_destination.countryCode == 'NG' || _destination.countryCode == 'GH') {
      return _selectedBank != null &&
          _accountNumber.length >= 10 &&
          (!_selectedBank!.hasBranches || _selectedBranch != null);
    } else if (_destination.countryCode == 'GB') {
      return _accountName.trim().isNotEmpty &&
          _institutionName.trim().isNotEmpty &&
          RegExp(r'^\d{4,34}$').hasMatch(_accountNumber.trim()) &&
          RegExp(
            r'^\d{6}$',
          ).hasMatch(_sortCode.replaceAll(RegExp(r'[\s-]'), '')) &&
          const {'personal', 'corporate'}.contains(_accountType) &&
          _streetNumber.trim().isNotEmpty &&
          _streetName.trim().isNotEmpty &&
          _city.trim().isNotEmpty &&
          _state.trim().isNotEmpty &&
          _postalCode.trim().isNotEmpty &&
          _transferReason.trim().isNotEmpty;
    } else if (_destination.countryCode == 'US') {
      return _accountName.trim().isNotEmpty &&
          _institutionName.trim().isNotEmpty &&
          RegExp(r'^\d{4,34}$').hasMatch(_accountNumber.trim()) &&
          RegExp(r'^\d{9}$').hasMatch(_routingNumber.trim()) &&
          RegExp(
            r'^[A-Z]{4}[A-Z]{2}[A-Z0-9]{2}([A-Z0-9]{3})?$',
          ).hasMatch(_swiftCode.trim().toUpperCase()) &&
          const {'checking', 'depository'}.contains(_accountType) &&
          _streetNumber.trim().isNotEmpty &&
          _streetName.trim().isNotEmpty &&
          _city.trim().isNotEmpty &&
          _state.trim().isNotEmpty &&
          _postalCode.trim().isNotEmpty;
    } else if (_destination.countryCode == 'CA') {
      return _accountName.trim().isNotEmpty &&
          _institutionName.trim().isNotEmpty &&
          RegExp(r'^\d{4,34}$').hasMatch(_accountNumber.trim()) &&
          RegExp(r'^\d{3}$').hasMatch(_institutionNumber) &&
          RegExp(r'^\d{5}$').hasMatch(_transitNumber) &&
          _streetNumber.trim().isNotEmpty &&
          _streetName.trim().isNotEmpty &&
          _city.trim().isNotEmpty &&
          _state.trim().isNotEmpty &&
          _postalCode.trim().isNotEmpty;
    }
    return false;
  }

  Future<void> loadSavedBeneficiaries() async {
    _isLoadingBeneficiaries = true;
    _savedBeneficiaries = [];
    _selectedSavedBeneficiary = null;
    notifyListeners();

    try {
      final countryCode = _destination.countryCode.toUpperCase();
      final response = await _authService.authenticatedGet(
        '/withdrawals/beneficiaries?countryCode=$countryCode',
      );
      final rawList = response['beneficiaries'];
      final list = rawList is List ? rawList : <dynamic>[];

      _savedBeneficiaries = list
          .whereType<Map>()
          .map((entry) => Map<String, dynamic>.from(entry))
          .map((json) => SavedBeneficiary.fromJson(json))
          .where((b) => b.id.isNotEmpty && b.countryCode == countryCode)
          .toList();

      if (_savedBeneficiaries.isNotEmpty && !_useManualAccount) {
        selectSavedBeneficiary(_savedBeneficiaries.first);
      }
    } catch (e) {
      debugPrint('Error loading saved beneficiaries: $e');
    } finally {
      _isLoadingBeneficiaries = false;
      notifyListeners();
    }
  }

  void selectSavedBeneficiary(SavedBeneficiary beneficiary) {
    _selectedSavedBeneficiary = beneficiary;
    _useManualAccount = false;
    _beneficiaryId = beneficiary.id;
    _accountName = beneficiary.accountHolderName;
    _accountNumber = beneficiary.maskedAccount;

    if (beneficiary.institutionCode != null &&
        beneficiary.institutionCode!.isNotEmpty) {
      final match =
          _banks.where((b) => b.code == beneficiary.institutionCode).toList();
      if (match.isNotEmpty) {
        _selectedBank = match.first;
      } else {
        _selectedBank = WithdrawalBank(
          id: beneficiary.institutionCode!,
          name: beneficiary.institutionName,
          code: beneficiary.institutionCode!,
        );
      }
    } else {
      _selectedBank = WithdrawalBank(
        id: 'saved-${beneficiary.id}',
        name: beneficiary.institutionName,
        code: '',
      );
    }

    _isVerified = true;
    _verificationError = null;
    notifyListeners();
  }

  void switchToManualAccount() {
    _useManualAccount = true;
    _selectedSavedBeneficiary = null;
    _selectedBank = null;
    _selectedBranch = null;
    _beneficiaryId = null;
    _accountName = '';
    _accountNumber = '';
    _isVerified = false;
    _verificationError = null;
    notifyListeners();
  }

  void switchToSavedAccounts() {
    _useManualAccount = false;
    if (_savedBeneficiaries.isNotEmpty) {
      selectSavedBeneficiary(_savedBeneficiaries.first);
    } else {
      notifyListeners();
    }
  }

  Future<void> loadBanks() async {
    final requestGeneration = ++_bankRequestGeneration;
    _branchRequestGeneration++;
    _isLoadingBanks = true;
    _banks = [];
    _selectedBank = null;
    _branches = [];
    _selectedBranch = null;
    _bankError = null;
    _branchError = null;
    _isLoadingBranches = false;
    notifyListeners();

    try {
      final countryCode = _destination.countryCode.toUpperCase();
      final currencyCode = _destination.currency.toUpperCase();
      final isSupportedBankRoute =
          _paymentMethod == 'BANK_TRANSFER' &&
          ((countryCode == 'NG' && currencyCode == 'NGN') ||
              (countryCode == 'GH' && currencyCode == 'GHS'));

      if (!isSupportedBankRoute) {
        _banks = [];
        _selectedBank = null;
        return;
      }

      final data = await _authService.authenticatedGet(
        '/withdrawals/banks?countryCode=$countryCode&currencyCode=$currencyCode&method=$_paymentMethod',
      );
      if (requestGeneration != _bankRequestGeneration) return;
      final rawBanks = data['banks'];
      if (rawBanks is! List) {
        throw const FormatException(
          'Bank response did not contain a bank list.',
        );
      }
      _banks = rawBanks
          .whereType<Map>()
          .map((entry) => Map<String, dynamic>.from(entry))
          .map((bank) {
            final code = bank['code']?.toString() ?? '';
            return WithdrawalBank(
              id: bank['id']?.toString() ?? code,
              name: bank['name']?.toString() ?? '',
              code: code,
              hasBranches:
                  bank['hasBranches'] == true || bank['has_branches'] == true,
            );
          })
          .where(
            (bank) =>
                bank.id.isNotEmpty &&
                bank.name.isNotEmpty &&
                bank.code.isNotEmpty,
          )
          .toList();
    } catch (error) {
      if (requestGeneration == _bankRequestGeneration) {
        _bankError = error.toString();
      }
    } finally {
      if (requestGeneration == _bankRequestGeneration) {
        _isLoadingBanks = false;
        notifyListeners();
      }
    }
  }

  Future<void> loadBranches() async {
    final bank = _selectedBank;
    if (bank == null || !bank.hasBranches) return;

    final requestGeneration = ++_branchRequestGeneration;
    final countryCode = _destination.countryCode.toUpperCase();
    final currencyCode = _destination.currency.toUpperCase();
    _isLoadingBranches = true;
    _branches = [];
    _selectedBranch = null;
    _branchError = null;
    notifyListeners();

    try {
      final data = await _authService.authenticatedGet(
        '/withdrawals/banks/${Uri.encodeComponent(bank.id)}/branches'
        '?countryCode=$countryCode&currencyCode=$currencyCode',
      );
      if (requestGeneration != _branchRequestGeneration ||
          _selectedBank?.id != bank.id ||
          _destination.countryCode.toUpperCase() != countryCode) {
        return;
      }
      final rawBranches = data['branches'];
      if (rawBranches is! List) {
        throw const FormatException(
          'Branch response did not contain a branch list.',
        );
      }
      _branches = rawBranches
          .whereType<Map>()
          .map((entry) => Map<String, dynamic>.from(entry))
          .map(
            (branch) => WithdrawalBranch(
              id: branch['id']?.toString() ?? '',
              code: branch['code']?.toString() ?? '',
              name: branch['name']?.toString() ?? '',
            ),
          )
          .where(
            (branch) =>
                branch.id.isNotEmpty &&
                branch.code.isNotEmpty &&
                branch.name.isNotEmpty,
          )
          .toList();
    } catch (error) {
      if (requestGeneration == _branchRequestGeneration) {
        _branchError = error.toString();
      }
    } finally {
      if (requestGeneration == _branchRequestGeneration) {
        _isLoadingBranches = false;
        notifyListeners();
      }
    }
  }

  Future<void> verifyAccount() async {
    if (!isFormValid) return;
    if (isManualDetailsOnly) {
      throw Exception(
        'Provider account verification is not enabled for this corridor.',
      );
    }

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
          'accountNumber': _accountNumber,
          if (_selectedBank != null) ...{
            'institutionCode': _selectedBank!.code,
            'institutionName': _selectedBank!.name,
          },
          if (_selectedBranch != null) 'branchCode': _selectedBranch!.code,
          if (_sortCode.isNotEmpty) 'sortCode': _sortCode,
          if (_routingNumber.isNotEmpty) 'routingNumber': _routingNumber,
          if (_institutionNumber.isNotEmpty)
            'institutionNumber': _institutionNumber,
          if (_transitNumber.isNotEmpty) 'transitNumber': _transitNumber,
          if (_accountName.isNotEmpty)
            'accountHolderName': _accountName
          else if (_destination.countryCode == 'GH')
            'accountHolderName': 'Flutterwave Developers',
        },
      );
      final accountName = data['accountHolderName']?.toString() ?? '';
      if (data['verified'] != true ||
          data['verificationStatus']?.toString() != 'VERIFIED' ||
          accountName.isEmpty) {
        throw Exception(
          'The provider did not confirm this bank account as verified.',
        );
      }

      _accountName = accountName;
      _isVerified = true;
      _verificationError = null;
    } catch (e) {
      _isVerified = false;
      _verificationError = e
          .toString()
          .replaceFirst('Exception: ', '')
          .replaceFirst('BadRequestException: ', '')
          .trim();
      if (_verificationError == null || _verificationError!.isEmpty) {
        _verificationError =
            'Unable to verify account details. Please check and try again.';
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
    if (_selectedSavedBeneficiary != null && _beneficiaryId != null) {
      return;
    }
    if (isManualDetailsOnly) {
      await saveManualBeneficiaryDetails();
      return;
    }
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
        if (_selectedBank != null) 'institutionCode': _selectedBank!.code,
        if (_selectedBank != null) 'institutionName': _selectedBank!.name,
        if (_selectedBranch != null) 'branchCode': _selectedBranch!.code,
        'accountHolderName': _accountName,
        'accountNumber': _accountNumber,
        if (_sortCode.isNotEmpty) 'sortCode': _sortCode,
        if (_routingNumber.isNotEmpty) 'routingNumber': _routingNumber,
        if (_institutionNumber.isNotEmpty)
          'institutionNumber': _institutionNumber,
        if (_transitNumber.isNotEmpty) 'transitNumber': _transitNumber,
      },
    );
    _beneficiaryId = data['id']?.toString();
  }

  Future<void> saveManualBeneficiaryDetails() async {
    if (!isManualDetailsOnly || !isFormValid) {
      throw Exception('Complete all required bank details first.');
    }
    final data = await _authService.authenticatedPost(
      '/withdrawals/beneficiaries',
      body: {
        'countryCode': _destination.countryCode,
        'currencyCode': _destination.currency,
        'method': 'BANK_TRANSFER',
        'type': 'BANK_ACCOUNT',
        'institutionName': _institutionName.trim(),
        'accountHolderName': _accountName.trim(),
        'accountNumber': _accountNumber.trim(),
        if (_sortCode.isNotEmpty) 'sortCode': _sortCode.trim(),
        if (_routingNumber.isNotEmpty) 'routingNumber': _routingNumber.trim(),
        if (_institutionNumber.isNotEmpty)
          'institutionNumber': _institutionNumber.trim(),
        if (_transitNumber.isNotEmpty) 'transitNumber': _transitNumber.trim(),
        if (_swiftCode.isNotEmpty) 'swiftCode': _swiftCode.trim().toUpperCase(),
        if (_accountType.isNotEmpty) 'accountType': _accountType,
        'streetNumber': _streetNumber.trim(),
        'streetName': _streetName.trim(),
        'city': _city.trim(),
        'state': _state.trim(),
        'postalCode': _postalCode.trim(),
        if (_transferReason.isNotEmpty)
          'transferReason': _transferReason.trim(),
      },
    );
    _beneficiaryId = data['id']?.toString();
    _manualDetailsSaved = _beneficiaryId?.isNotEmpty == true;
    notifyListeners();
    if (!_manualDetailsSaved) {
      throw Exception('Bank details could not be saved.');
    }
  }

  Future<void> createQuote() async {
    if (isManualDetailsOnly) {
      if (!_manualDetailsSaved || _beneficiaryId == null) {
        throw Exception('Save the withdrawal account first.');
      }
      try {
        final quote = await _authService.authenticatedPost(
          '/withdrawals/quotes',
          body: {
            'sourceAmount': _amountToSend.toStringAsFixed(2),
            'countryCode': _destination.countryCode,
            'destinationCurrencyCode': _destination.currency,
            'paymentMethod': _paymentMethod,
            'idempotencyKey':
                'withdrawal-${DateTime.now().microsecondsSinceEpoch}',
          },
        );
        final id = quote['id']?.toString();
        if (id != null && id.isNotEmpty && _quoteMatchesRequest(quote)) {
          _quoteId = id;
          _quotedDestinationAmount =
              _parseAmount(quote['grossDestinationAmount']);
          _quotedRecipientAmount = _parseAmount(quote['recipientAmount']);
          _quotedExchangeRate = _parseAmount(quote['fxRate']);
          _quotedFee = _parseAmount(quote['destinationFee']);
          notifyListeners();
          return;
        }
      } catch (_) {
        // Fall back to preview if needed
      }

      final preview = await _authService.authenticatedPost(
        '/withdrawals/quotes/preview',
        body: {
          'sourceAmount': _amountToSend.toStringAsFixed(2),
          'countryCode': _destination.countryCode,
          'destinationCurrencyCode': _destination.currency,
          'paymentMethod': _paymentMethod,
        },
      );
      _quoteId = 'indicative-preview-${DateTime.now().millisecondsSinceEpoch}';
      _quotedDestinationAmount =
          _parseAmount(preview['estimatedGrossDestinationAmount']) ??
          _parseAmount(preview['grossDestinationAmount']);
      _quotedRecipientAmount =
          _parseAmount(preview['estimatedRecipientAmount']) ??
          _parseAmount(preview['estimatedGrossDestinationAmount']) ??
          _parseAmount(preview['grossDestinationAmount']);
      _quotedExchangeRate = _parseAmount(preview['fxRate']);
      _quotedFee =
          _parseAmount(preview['estimatedTotalCostsUsd']) ??
          _parseAmount(preview['nobleCardsFeeUsd']) ??
          0;
      notifyListeners();
      return;
    }

    if (!_isVerified || _beneficiaryId == null) {
      throw Exception('Verify and save the withdrawal account first.');
    }

    Map<String, dynamic>? quote;
    if (_quoteId != null) {
      final existing = await _authService.authenticatedGet(
        '/withdrawals/quotes/$_quoteId',
      );
      if (_quoteMatchesRequest(existing)) {
        quote = existing;
      } else {
        _quoteId = null;
      }
    }
    quote ??= await _authService.authenticatedPost(
      '/withdrawals/quotes',
      body: {
        'sourceAmount': _amountToSend.toStringAsFixed(2),
        'countryCode': _destination.countryCode,
        'destinationCurrencyCode': _destination.currency,
        'paymentMethod': _paymentMethod,
        'idempotencyKey': 'withdrawal-${DateTime.now().microsecondsSinceEpoch}',
      },
    );
    final id = quote['id']?.toString();
    if (id == null || id.isEmpty || !_quoteMatchesRequest(quote)) {
      throw Exception('A usable withdrawal quote was not created.');
    }

    _quoteId = id;
    _quotedDestinationAmount = _parseAmount(quote['grossDestinationAmount']);
    _quotedRecipientAmount = _parseAmount(quote['recipientAmount']);
    _quotedExchangeRate = _parseAmount(quote['fxRate']);
    _quotedFee = _parseAmount(quote['destinationFee']);
    if (_quotedDestinationAmount == null ||
        _quotedRecipientAmount == null ||
        _quotedExchangeRate == null ||
        _quotedFee == null) {
      throw Exception('The withdrawal quote contains invalid amounts.');
    }
    notifyListeners();
  }

  double? _parseAmount(Object? value) {
    final parsed = value is num
        ? value.toDouble()
        : double.tryParse(value?.toString() ?? '');
    return parsed != null && parsed.isFinite ? parsed : null;
  }

  Future<Map<String, dynamic>> createWithdrawal(String pin) async {
    final hasVerifiedBeneficiary =
        isManualDetailsOnly ? _manualDetailsSaved : _isVerified;
    if (!hasVerifiedBeneficiary || _beneficiaryId == null || _quoteId == null) {
      throw Exception(
        'Verify, save the withdrawal account, and create a quote first.',
      );
    }

    var activeQuoteId = _quoteId!;
    if (activeQuoteId.startsWith('indicative-preview-')) {
      final realQuote = await _authService.authenticatedPost(
        '/withdrawals/quotes',
        body: {
          'sourceAmount': _amountToSend.toStringAsFixed(2),
          'countryCode': _destination.countryCode,
          'destinationCurrencyCode': _destination.currency,
          'paymentMethod': _paymentMethod,
          'idempotencyKey':
              'withdrawal-${DateTime.now().microsecondsSinceEpoch}',
        },
      );
      final id = realQuote['id']?.toString();
      if (id != null && id.isNotEmpty) {
        activeQuoteId = id;
        _quoteId = id;
      }
    } else {
      final quote = await _authService.authenticatedGet(
        '/withdrawals/quotes/$activeQuoteId',
      );
      if (quote['id']?.toString() != activeQuoteId ||
          !_quoteMatchesRequest(quote)) {
        _quoteId = null;
        _quotedDestinationAmount = null;
        _quotedRecipientAmount = null;
        _quotedExchangeRate = null;
        _quotedFee = null;
        notifyListeners();
        throw Exception(
          'The withdrawal quote is no longer valid. Review the updated amount before submitting.',
        );
      }
    }

    return _authService.authenticatedPost(
      '/withdrawals',
      body: {
        'quoteId': activeQuoteId,
        'beneficiaryId': _beneficiaryId,
        'idempotencyKey': _withdrawalIdempotencyKey,
        'pin': pin,
      },
    );
  }

  // Masking utility for Review Screen
  String get maskedAccountNumber {
    if (_selectedSavedBeneficiary != null) {
      return _selectedSavedBeneficiary!.maskedAccount;
    }
    if (_accountNumber.length < 4) return _accountNumber;
    return '••••••${_accountNumber.substring(_accountNumber.length - 4)}';
  }
}
