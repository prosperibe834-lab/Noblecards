import 'dart:async';

import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import '../../authentication/services/authentication_service.dart';
import '../models/withdraw_country.dart';
import '../models/withdraw_method.dart';

class WithdrawProvider extends ChangeNotifier {
  WithdrawProvider({AuthenticationService? authService})
    : _authService = authService ?? AuthenticationService() {
    selectedCountry = supportedCountries.first;
    _updateAvailableMethods();
  }

  final AuthenticationService _authService;
  double? availableBalance;
  bool isBalanceVisible = true;
  bool isLoading = true;
  bool isQuoteLoading = false;
  String? dataError;
  Map<String, dynamic>? _quote;
  Map<String, dynamic>? _indicativePreview;
  Timer? _quoteDebounce;
  int _quoteRequestGeneration = 0;

  String amountText = '100.00';

  final List<WithdrawCountry> supportedCountries = [
    WithdrawCountry(
      id: 'NG',
      name: 'Nigeria',
      currency: 'NGN',
      flagInitials: 'NG',
      supportedMethodIds: ['bank', 'momo'],
    ),
    WithdrawCountry(
      id: 'GH',
      name: 'Ghana',
      currency: 'GHS',
      flagInitials: 'GH',
      supportedMethodIds: ['bank', 'momo'],
    ),
    WithdrawCountry(
      id: 'GB',
      name: 'United Kingdom',
      currency: 'GBP',
      flagInitials: 'GB',
      supportedMethodIds: ['bank'],
    ),
    WithdrawCountry(
      id: 'US',
      name: 'United States',
      currency: 'USD',
      flagInitials: 'US',
      supportedMethodIds: ['bank'],
    ),
    WithdrawCountry(
      id: 'CA',
      name: 'Canada',
      currency: 'CAD',
      flagInitials: 'CA',
      supportedMethodIds: ['bank'],
    ),
  ];

  final List<WithdrawMethod> allMethods = [
    WithdrawMethod(
      id: 'bank',
      name: 'Bank Transfer',
      subtitle: 'To your bank account',
      icon: Boxicons.bxs_bank,
    ),
    WithdrawMethod(
      id: 'momo',
      name: 'Mobile Money',
      subtitle: 'To your mobile wallet',
      icon: Boxicons.bx_mobile_alt,
    ),
  ];

  late WithdrawCountry selectedCountry;
  WithdrawMethod? selectedMethod;

  double get parsedAmount => double.tryParse(amountText) ?? 0.0;
  String? get quoteId => _quote?['id']?.toString();
  bool get hasQuote => _quoteMatchesCurrentSelection(_quote);
  bool get isIndicativeRoute =>
      const {'GB', 'US', 'CA'}.contains(selectedCountry.id);
  bool get isIndicativePreview =>
      !isQuoteLoading && _previewMatchesCurrentSelection(_indicativePreview);
  double? get exchangeRate => _quoteNumber('fxRate');
  double? get convertedAmount => _quoteNumber('grossDestinationAmount');
  double? get indicativeExchangeRate => _previewNumber('fxRate');
  double? get indicativeConvertedAmount =>
      _previewNumber('estimatedGrossDestinationAmount');
  double? get indicativeTransferAmount =>
      _previewNumber('estimatedTransferAmount');
  String? get indicativeExchangeRateSource =>
      _indicativePreview?['exchangeRateSource']?.toString();
  String? get indicativeProviderFeeStatus =>
      _indicativePreview?['providerFeeStatus']?.toString();
  String? get indicativeProviderFeeType =>
      _indicativePreview?['providerFeeType']?.toString();
  double? get indicativeProviderFeeAmount =>
      _previewNumber('providerFeeAmount');
  String? get indicativeProviderFeeCurrency =>
      _indicativePreview?['providerFeeCurrency']?.toString();
  String? get indicativeProviderFeeMessage =>
      _indicativePreview?['providerFeeMessage']?.toString();
  double? get indicativeNobleCardsFee => _previewNumber('nobleCardsFeeUsd');
  double? get indicativeNobleCardsFeePercent =>
      _previewNumber('nobleCardsFeePercent');
  String? get indicativeProviderFeeFundingCurrency =>
      _indicativePreview?['providerFeeFundingCurrency']?.toString();
  double? get indicativeProviderFeeUsdEquivalent =>
      _previewNumber('providerFeeUsdEquivalent');
  double? get indicativeTotalFeeUsd => _previewNumber('estimatedTotalCostsUsd');
  double? get indicativeRecipientAmount =>
      _previewNumber('estimatedRecipientAmount');
  double? get providerFee => _quoteNumber('providerFee');
  double? get nobleCardsFee => _quoteNumber('nobleCardsFee');
  double? get totalFee => _quoteNumber('totalFee');
  double? get withdrawalFee => _quoteNumber('destinationFee');
  double? get amountReceived => _quoteNumber('recipientAmount');

  double? _quoteNumber(String key) {
    final value = _quote?[key];
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }

  double? _previewNumber(String key) {
    final value = _indicativePreview?[key];
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }

  double? get convertedBalance {
    final rate = exchangeRate;
    if (availableBalance == null || rate == null) return null;
    return availableBalance! * rate;
  }

  void toggleBalanceVisibility() {
    isBalanceVisible = !isBalanceVisible;
    notifyListeners();
  }

  void setAmount(String amount) {
    amountText = amount;
    _scheduleQuoteRefresh();
    notifyListeners();
  }

  void setMaxAmount() {
    final balance = availableBalance;
    if (balance == null) return;
    setAmount(balance.toStringAsFixed(2));
  }

  void selectCountry(WithdrawCountry country) {
    selectedCountry = country;
    _updateAvailableMethods();
    _quote = null;
    _indicativePreview = null;
    _scheduleQuoteRefresh();
    notifyListeners();
  }

  void selectMethod(WithdrawMethod method) {
    selectedMethod = method;
    _scheduleQuoteRefresh();
    notifyListeners();
  }

  void _updateAvailableMethods() {
    final available = allMethods
        .where(
          (method) => selectedCountry.supportedMethodIds.contains(method.id),
        )
        .toList();

    if (available.isNotEmpty) {
      if (selectedMethod == null || !available.contains(selectedMethod)) {
        selectedMethod = available.first;
      }
    } else {
      selectedMethod = null;
    }
  }

  void _scheduleQuoteRefresh() {
    _quoteRequestGeneration++;
    _quoteDebounce?.cancel();
    _quote = null;
    _indicativePreview = null;
    dataError = null;
    if (parsedAmount <= 0) {
      isQuoteLoading = false;
      return;
    }
    isQuoteLoading = true;
    _quoteDebounce = Timer(
      const Duration(milliseconds: 450),
      () => refreshPricingNow(),
    );
  }

  static String formatErrorMessage(Object error) {
    if (error is FormatException) {
      return error.message;
    }
    final message = error.toString();
    if (message.startsWith('FormatException: ')) {
      return message.substring('FormatException: '.length);
    }
    if (message.startsWith('Exception: ')) {
      return message.substring('Exception: '.length);
    }
    return message;
  }

  Future<void> reloadData() async {
    _quoteRequestGeneration++;
    _quoteDebounce?.cancel();
    _quote = null;
    _indicativePreview = null;
    isQuoteLoading = false;
    isLoading = true;
    dataError = null;
    availableBalance = null;
    notifyListeners();
    try {
      final balances = await _authService.authenticatedGetList(
        '/wallet/balances',
      );
      final usdBalances = balances
          .whereType<Map>()
          .map((balance) => Map<String, dynamic>.from(balance))
          .where((balance) => balance['currency']?.toString() == 'USD')
          .toList();
      if (usdBalances.isEmpty) {
        throw const FormatException('The USD wallet balance is unavailable.');
      }
      final usdBalance = usdBalances.first;
      availableBalance = _parseAmount(usdBalance['availableBalance']);
      if (availableBalance == null || availableBalance!.isNegative) {
        throw const FormatException('The USD wallet balance is invalid.');
      }
      await refreshPricingNow();
    } catch (error) {
      _quote = null;
      dataError = formatErrorMessage(error);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshPricingNow() async {
    if (isIndicativeRoute) {
      await refreshIndicativePreviewNow();
      return;
    }
    await refreshQuoteNow();
  }

  Future<void> refreshIndicativePreviewNow() async {
    _quoteDebounce?.cancel();
    final generation = ++_quoteRequestGeneration;
    if (parsedAmount <= 0) {
      _indicativePreview = null;
      isQuoteLoading = false;
      notifyListeners();
      return;
    }

    final sourceAmount = parsedAmount;
    final countryCode = selectedCountry.id;
    final destinationCurrency = selectedCountry.currency;
    isQuoteLoading = true;
    dataError = null;
    _quote = null;
    _indicativePreview = null;
    notifyListeners();
    try {
      final preview = await _authService.authenticatedPost(
        '/withdrawals/quotes/preview',
        body: {
          'sourceAmount': sourceAmount.toStringAsFixed(2),
          'countryCode': countryCode,
          'destinationCurrencyCode': destinationCurrency,
          'paymentMethod': 'BANK_TRANSFER',
        },
      );
      if (generation != _quoteRequestGeneration) return;
      if (preview['previewContractVersion'] != 2) {
        throw const FormatException(
          'The backend withdrawal preview is outdated. Restart or update the backend service.',
        );
      }
      if (!_previewMatchesSelection(
        preview,
        sourceAmount: sourceAmount,
        countryCode: countryCode,
        destinationCurrency: destinationCurrency,
      )) {
        throw const FormatException(
          'The backend returned an invalid indicative estimate.',
        );
      }
      _indicativePreview = preview;
    } catch (error) {
      if (generation != _quoteRequestGeneration) return;
      _indicativePreview = null;
      dataError = formatErrorMessage(error);
    } finally {
      if (generation == _quoteRequestGeneration) {
        isQuoteLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> refreshQuoteNow() async {
    _quoteDebounce?.cancel();
    final generation = ++_quoteRequestGeneration;
    if (parsedAmount <= 0) {
      _quote = null;
      isQuoteLoading = false;
      notifyListeners();
      return;
    }

    final sourceAmount = parsedAmount;
    final countryCode = selectedCountry.id;
    final destinationCurrency = selectedCountry.currency;
    final paymentMethod = selectedMethod?.id == 'momo'
        ? 'MOBILE_MONEY'
        : 'BANK_TRANSFER';
    isQuoteLoading = true;
    dataError = null;
    _quote = null;
    _indicativePreview = null;
    notifyListeners();
    try {
      final quote = await _authService.authenticatedPost(
        '/withdrawals/quotes',
        body: {
          'sourceAmount': sourceAmount.toStringAsFixed(2),
          'countryCode': countryCode,
          'destinationCurrencyCode': destinationCurrency,
          'paymentMethod': paymentMethod,
          'idempotencyKey':
              'withdraw-preview-${DateTime.now().microsecondsSinceEpoch}',
        },
      );
      if (generation != _quoteRequestGeneration) return;
      if (!_quoteMatchesSelection(
        quote,
        sourceAmount: sourceAmount,
        countryCode: countryCode,
        destinationCurrency: destinationCurrency,
        paymentMethod: paymentMethod,
      )) {
        throw const FormatException(
          'The backend returned an invalid withdrawal quote.',
        );
      }
      _quote = quote;
    } catch (error) {
      if (generation != _quoteRequestGeneration) return;
      _quote = null;
      dataError = formatErrorMessage(error);
    } finally {
      if (generation == _quoteRequestGeneration) {
        isQuoteLoading = false;
        notifyListeners();
      }
    }
  }

  bool _quoteMatchesCurrentSelection(Map<String, dynamic>? quote) =>
      !isQuoteLoading &&
      _quoteMatchesSelection(
        quote,
        sourceAmount: parsedAmount,
        countryCode: selectedCountry.id,
        destinationCurrency: selectedCountry.currency,
        paymentMethod: selectedMethod?.id == 'momo'
            ? 'MOBILE_MONEY'
            : 'BANK_TRANSFER',
      );

  bool _previewMatchesCurrentSelection(Map<String, dynamic>? preview) =>
      _previewMatchesSelection(
        preview,
        sourceAmount: parsedAmount,
        countryCode: selectedCountry.id,
        destinationCurrency: selectedCountry.currency,
      );

  bool _previewMatchesSelection(
    Map<String, dynamic>? preview, {
    required double sourceAmount,
    required String countryCode,
    required String destinationCurrency,
  }) {
    if (preview == null ||
        preview['previewContractVersion'] != 2 ||
        preview['isIndicativePreview'] != true ||
        preview['payoutEnabled'] != false ||
        preview['recipientAmount'] != null ||
        preview['countryCode']?.toString() != countryCode ||
        preview['destinationCurrency']?.toString() != destinationCurrency ||
        _parseAmount(preview['sourceAmount']) != sourceAmount) {
      return false;
    }

    final rate = _parseAmount(preview['fxRate']);
    final gross = _parseAmount(preview['estimatedGrossDestinationAmount']);
    final transferAmount = _parseAmount(preview['estimatedTransferAmount']);
    final nobleCardsFee = _parseAmount(preview['nobleCardsFeeUsd']);
    final transferSourceAmount = _parseAmount(
      preview['estimatedTransferSourceAmountUsd'],
    );
    final providerFeeAmount = _parseAmount(preview['providerFeeAmount']);
    final providerFeeUsdEquivalent = _parseAmount(
      preview['providerFeeUsdEquivalent'],
    );
    final totalCostsUsd = _parseAmount(preview['estimatedTotalCostsUsd']);
    final estimatedRecipientAmount = _parseAmount(
      preview['estimatedRecipientAmount'],
    );
    final rateRetrievedAt = DateTime.tryParse(
      preview['rateRetrievedAt']?.toString() ?? '',
    );
    final providerFeeStatus = preview['providerFeeStatus']?.toString();
    final now = DateTime.now();

    if (rate == null ||
        rate <= 0 ||
        gross == null ||
        gross <= 0 ||
        transferAmount == null ||
        transferAmount < 0 ||
        transferSourceAmount == null ||
        transferSourceAmount < 0 ||
        nobleCardsFee == null ||
        nobleCardsFee < 0 ||
        preview['exchangeRateSource'] != 'FLUTTERWAVE_V3') {
      return false;
    }

    if (rateRetrievedAt == null ||
        rateRetrievedAt.isAfter(now.add(const Duration(minutes: 5))) ||
        rateRetrievedAt.isBefore(now.subtract(const Duration(minutes: 15)))) {
      return false;
    }

    final expectedTransferSource = sourceAmount - nobleCardsFee;
    final expectedGross = sourceAmount * rate;
    final expectedTransferAmount = expectedTransferSource * rate;
    if ((transferSourceAmount * 100).round() !=
            (expectedTransferSource * 100).round() ||
        (gross * 100).round() != (expectedGross * 100).round() ||
        (transferAmount * 100).round() !=
            (expectedTransferAmount * 100).round()) {
      return false;
    }

    if (!const {
      'CONFIRMED',
      'ESTIMATED',
      'AMBIGUOUS',
      'NO_RECORD',
      'UNAVAILABLE',
    }.contains(providerFeeStatus)) {
      return false;
    }

    if (providerFeeStatus == 'CONFIRMED' || providerFeeStatus == 'ESTIMATED') {
      if (providerFeeAmount == null ||
          providerFeeAmount < 0 ||
          providerFeeUsdEquivalent == null ||
          providerFeeUsdEquivalent < 0 ||
          totalCostsUsd == null ||
          totalCostsUsd < 0) {
        return false;
      }
      final expectedTotalCostsCents =
          ((nobleCardsFee + providerFeeUsdEquivalent) * 100).round();
      if ((totalCostsUsd * 100).round() != expectedTotalCostsCents) {
        return false;
      }
      if (estimatedRecipientAmount != null) {
        if (estimatedRecipientAmount < 0 ||
            estimatedRecipientAmount > transferAmount) {
          return false;
        }
      }
    } else {
      if (providerFeeUsdEquivalent != null || totalCostsUsd != null) {
        return false;
      }
    }

    return true;
  }

  bool _quoteMatchesSelection(
    Map<String, dynamic>? quote, {
    required double sourceAmount,
    required String countryCode,
    required String destinationCurrency,
    required String paymentMethod,
  }) {
    if (quote == null ||
        quote['usable'] != true ||
        quote['status'] != 'ACTIVE' ||
        quote['countryCode']?.toString() != countryCode ||
        quote['destinationCurrency']?.toString() != destinationCurrency ||
        quote['paymentMethod']?.toString() != paymentMethod ||
        _parseAmount(quote['sourceAmount']) != sourceAmount) {
      return false;
    }

    final expiresAt = DateTime.tryParse(quote['expiresAt']?.toString() ?? '');
    final rate = _parseAmount(quote['fxRate']);
    final gross = _parseAmount(quote['grossDestinationAmount']);
    final providerFee = _parseAmount(quote['providerFee']);
    final platformFee = _parseAmount(quote['nobleCardsFee']);
    final totalFee = _parseAmount(quote['totalFee']);
    final destinationFee = _parseAmount(quote['destinationFee']);
    final recipientAmount = _parseAmount(quote['recipientAmount']);
    if (expiresAt == null ||
        !expiresAt.isAfter(DateTime.now()) ||
        rate == null ||
        rate <= 0 ||
        gross == null ||
        gross <= 0 ||
        providerFee == null ||
        providerFee < 0 ||
        platformFee == null ||
        platformFee < 0 ||
        totalFee == null ||
        totalFee < 0 ||
        destinationFee == null ||
        destinationFee < 0 ||
        recipientAmount == null) {
      return false;
    }

    final totalFeeCents = (totalFee * 100).round();
    final componentsCents = ((providerFee + platformFee) * 100).round();
    final destinationCents = (destinationFee * 100).round();
    final receiveCents = (recipientAmount * 100).round();
    final grossCents = (gross * 100).round();
    return totalFeeCents == componentsCents &&
        destinationCents + receiveCents == grossCents;
  }

  static double? _parseAmount(Object? value) {
    final parsed = value is num
        ? value.toDouble()
        : double.tryParse(value?.toString() ?? '');
    return parsed != null && parsed.isFinite ? parsed : null;
  }

  @override
  void dispose() {
    _quoteDebounce?.cancel();
    super.dispose();
  }
}
