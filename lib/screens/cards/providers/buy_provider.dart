import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/gift_card_region_model.dart';
import '../services/buy_service.dart';
import '../models/gift_card_model.dart';

class BuyProvider extends ChangeNotifier {
  BuyProvider({
    GiftCardModel? card,
    GiftCardRegionModel? initialRegion,
    BuyService? service,
    bool loadQuote = true,
  }) : _service = service ?? BuyService(),
       _productId = card?.id {
    var region = initialRegion;
    if (region == null && card != null) {
      for (final supportedRegion in card.supportedRegions) {
        if (supportedRegion.countryCode == card.countryCode &&
            supportedRegion.currencyCode == card.currency) {
          region = supportedRegion;
          break;
        }
      }
    }
    _selectedRegion = region;
    _currentRate = region?.buyRate ?? card?.buyRate ?? 0;
    _currencyCode = region?.currencyCode ?? card?.currency ?? '';
    _currencySymbol =
        region?.currencySymbol ?? _symbolForCurrency(_currencyCode);
    _availableDenominations =
        region?.availableDenominations ?? card?.denominations ?? const [];
    _amount = _availableDenominations.isNotEmpty
        ? double.tryParse(_availableDenominations.first) ?? 0
        : double.tryParse(
                region?.minimumAmount ?? card?.minDenomination ?? '',
              ) ??
              0;
    if (loadQuote && _productId != null && region != null) {
      unawaited(refreshQuote());
    }
  }

  final BuyService _service;
  final String? _productId;

  double _amount = 0;
  int _quantity = 1;
  double _currentRate = 0;
  bool _isLoadingRate = false;
  GiftCardRegionModel? _selectedRegion;
  String _currencyCode = '';
  String _currencySymbol = '';
  List<String> _availableDenominations = const [];
  Timer? _quoteTimer;
  int _quoteGeneration = 0;
  double? _customerPrice;
  String? _quoteError;

  double get amount => _amount;
  int get quantity => _quantity;
  double get currentRate => _currentRate;
  bool get isLoadingRate => _isLoadingRate;
  bool get hasCurrentQuote => _customerPrice != null && _quoteError == null;
  String? get quoteError => _quoteError;
  GiftCardRegionModel? get selectedRegion => _selectedRegion;
  String get currencyCode => _currencyCode;
  String get currencySymbol => _currencySymbol;
  List<String> get availableDenominations => _availableDenominations;

  double? get totalToPay => _customerPrice;

  void setAmount(double newAmount) {
    _amount = newAmount;
    HapticFeedback.lightImpact();
    _queueQuoteRefresh();
  }

  void setRegion(GiftCardRegionModel region) {
    _selectedRegion = region;
    _currentRate = region.buyRate;
    _currencyCode = region.currencyCode;
    _currencySymbol = region.currencySymbol;
    _availableDenominations = List<String>.from(region.availableDenominations);
    _amount = _availableDenominations.isNotEmpty
        ? double.tryParse(_availableDenominations.first) ?? _amount
        : double.tryParse(region.minimumAmount) ?? 0;
    HapticFeedback.lightImpact();
    _queueQuoteRefresh();
  }

  void incrementQuantity() {
    _quantity++;
    HapticFeedback.lightImpact();
    _queueQuoteRefresh();
  }

  void decrementQuantity() {
    if (_quantity > 1) {
      _quantity--;
      HapticFeedback.lightImpact();
      _queueQuoteRefresh();
    }
  }

  Future<void> refreshRate() async {
    await refreshQuote();
  }

  Future<void> refreshQuote() async {
    _quoteTimer?.cancel();
    final region = _selectedRegion;
    final productId = _productId;
    if (region == null || productId == null || _amount <= 0) {
      _customerPrice = null;
      _quoteError = 'A valid product, country, and amount are required.';
      _isLoadingRate = false;
      notifyListeners();
      return;
    }

    final generation = ++_quoteGeneration;
    _isLoadingRate = true;
    _customerPrice = null;
    _quoteError = null;
    notifyListeners();
    try {
      final quote = await _service.fetchQuote(
        productId: productId,
        countryCode: region.countryCode,
        currencyCode: region.currencyCode,
        amount: _amount,
        quantity: _quantity,
      );
      if (generation != _quoteGeneration) return;
      final rate = double.tryParse(
        quote['customerRatePercent']?.toString() ?? '',
      );
      final customerPrice = double.tryParse(
        quote['customerPrice']?.toString() ?? '',
      );
      if (rate == null || customerPrice == null) {
        throw StateError(
          'The Buy pricing service returned an incomplete quote.',
        );
      }
      _currentRate = rate;
      _customerPrice = customerPrice;
    } catch (error) {
      if (generation != _quoteGeneration) return;
      _quoteError = error.toString().replaceFirst('Exception: ', '');
    } finally {
      if (generation == _quoteGeneration) {
        _isLoadingRate = false;
        notifyListeners();
      }
    }
  }

  void _queueQuoteRefresh() {
    _quoteTimer?.cancel();
    _quoteGeneration++;
    _customerPrice = null;
    _quoteError = null;
    _isLoadingRate = true;
    notifyListeners();
    _quoteTimer = Timer(const Duration(milliseconds: 350), () {
      unawaited(refreshQuote());
    });
  }

  @override
  void dispose() {
    _quoteTimer?.cancel();
    _quoteGeneration++;
    super.dispose();
  }

  static String _symbolForCurrency(String currency) =>
      {
        'USD': r'$',
        'GBP': '£',
        'CAD': r'C$',
        'AUD': r'A$',
        'EUR': '€',
        'NGN': '₦',
        'GHS': '₵',
        'ZAR': 'R',
        'JPY': '¥',
        'CHF': 'CHF',
        'SEK': 'kr',
        'NOK': 'kr',
        'DKK': 'kr',
        'NZD': r'NZ$',
        'PLN': 'zł',
        'TRY': '₺',
      }[currency] ??
      currency;
}
