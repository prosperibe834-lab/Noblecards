import 'dart:convert';

import 'package:noble_cards/screens/authentication/services/authentication_service.dart';
import 'package:noble_cards/providers/exchange_rate_provider.dart';
import '../models/gift_card_region_model.dart';

class GiftCardSellService {
  final AuthenticationService _authentication;

  GiftCardSellService({AuthenticationService? authentication})
    : _authentication = authentication ?? AuthenticationService();

  Future<List<dynamic>> getCatalog() async {
    final response = await _authentication.authenticatedGet(
      '/gift-cards/sell/catalog',
    );
    final data = response['data'];
    return data is List ? data : const [];
  }

  Future<List<GiftCardRegionModel>> getRegionsForCard(
    String cardName, {
    String? cardSlug,
    String cardType = 'ecode',
    double cardAmount = 100,
  }) async {
    final catalog = await getCatalog();
    final product = _findProduct(catalog, cardName, cardSlug);
    final countries = product['countries'];
    if (countries is! List) return const [];
    final ratesResponse = await _authentication.authenticatedGet(
      '/gift-cards/sell/rates',
    );
    final rates = ratesResponse['data'] is List
        ? (ratesResponse['data'] as List).whereType<Map>().firstWhere(
            (item) => item['slug']?.toString() == product['slug']?.toString(),
            orElse: () => <String, dynamic>{},
          )['rates']
        : null;
    return countries.whereType<Map>().map((country) {
      final code = (country['code'] ?? country['country_code'] ?? country['countryCode'])?.toString().toUpperCase() ?? '';
      final currency = (country['currency'] ?? country['currency_code'] ?? country['currencyCode'])?.toString().toUpperCase() ?? '';
      final providerRate = _providerRate(
        rates,
        currency,
        cardType,
        cardAmount,
      );
      final payoutCurrency = _payoutCurrency(rates, currency, cardType);
      final sellRate = providerRate == null || payoutCurrency == null
          ? 0.0
          : _ratePercentage(providerRate, payoutCurrency, currency);
      return GiftCardRegionModel(
        id: code.toLowerCase(),
        countryName: country['label']?.toString() ?? code,
        countryCode: code,
        flag: _flagForCountry(code),
        currencyCode: currency,
        currencySymbol: _symbolForCurrency(currency),
        buyRate: 0,
        sellRate: sellRate,
        availableDenominations: [
          if (product['min_amount'] != null) product['min_amount'].toString(),
          if (product['max_amount'] != null) product['max_amount'].toString(),
        ],
        isAvailable: true,
      );
    }).toList();
  }

  Future<Map<String, dynamic>?> getSellConfiguration({
    required String cardName,
    String? cardSlug,
    required String countryCode,
    required String cardType,
  }) async {
    final catalog = await getCatalog();
    final product = _findProduct(catalog, cardName, cardSlug);
    final countries = product['countries'] is List
        ? product['countries'] as List
        : const [];
    final country = countries.whereType<Map>().firstWhere(
      (item) =>
          item['code']?.toString().toUpperCase() == countryCode.toUpperCase(),
      orElse: () => <String, dynamic>{},
    );
    if (country.isEmpty) return null;
    final ratesResponse = await _authentication.authenticatedGet(
      '/gift-cards/sell/rates',
    );
    final products = ratesResponse['data'];
    if (products is! List) return null;
    final rateProduct = products.whereType<Map>().firstWhere(
      (item) => item['slug']?.toString() == product['slug']?.toString(),
      orElse: () => <String, dynamic>{},
    );
    final rates = rateProduct['rates'] is Map
        ? rateProduct['rates'] as Map
        : const {};
    final currencyNode = rates[country['currency']];
    final typeNode = currencyNode is Map ? currencyNode[cardType] : null;
    if (typeNode is! Map) return null;
    final payoutKeys = typeNode.keys
        .where((key) => RegExp(r'^[A-Z]{3}$').hasMatch(key.toString()))
        .toList();
    if (payoutKeys.isEmpty) return null;
    final payout = payoutKeys.first.toString();
    final payoutValue = typeNode[payout];
    final receiptType = payoutValue is Map && payoutValue.isNotEmpty
        ? payoutValue.keys.first.toString()
        : null;
    return {
      'slug': product['slug'],
      'cardCurrency': country['currency'],
      'payoutCurrency': payout,
      'receiptType': receiptType,
    };
  }

  Future<List<String>?> getAvailableCardTypes({
    required String cardName,
    String? cardSlug,
    required String countryCode,
  }) async {
    final response = await _authentication.authenticatedGet(
      '/gift-cards/sell/catalog',
    );
    final products = response['data'];
    if (products is! List) return null;

    for (final product in products) {
      if (product is! Map) continue;
      if (!_matchesCard(product, cardName, cardSlug)) continue;

      final countries = product['countries'];
      if (countries is List &&
          !countries.any(
            (country) =>
                country is Map &&
                country['code']?.toString().toUpperCase() ==
                    countryCode.toUpperCase(),
          )) {
        return const [];
      }
      final cardTypes = product['card_types'];
      if (cardTypes is! List) return const [];
      return cardTypes
          .map((type) => type.toString().trim().toLowerCase())
          .where((type) => type == 'ecode' || type == 'physical')
          .toSet()
          .toList();
    }
    return null;
  }

  Future<Map<String, dynamic>> submitSale({
    required String slug,
    required String cardCountry,
    required String cardType,
    String? receiptType,
    required String cardCurrency,
    required String payoutCurrency,
    required double cardAmount,
    required List<Map<String, dynamic>> cards,
  }) {
    final additionalInfo = jsonEncode({'cards': cards});
    return _authentication.authenticatedPost(
      '/gift-cards/sell',
      body: {
        'slug': slug,
        'cardCountry': cardCountry,
        'cardType': cardType,
        if (receiptType != null) 'receiptType': receiptType,
        'cardCurrency': cardCurrency,
        'payoutCurrency': payoutCurrency,
        'cardAmount': cardAmount,
        'additionalInfo': additionalInfo,
      },
    );
  }

  Future<Map<String, dynamic>> quoteSale({
    required String slug,
    required String cardCountry,
    required String cardType,
    String? receiptType,
    required String cardCurrency,
    required String payoutCurrency,
    required double cardAmount,
  }) {
    return _authentication.authenticatedPost(
      '/gift-cards/sell/quote',
      body: {
        'slug': slug,
        'cardCountry': cardCountry,
        'cardType': cardType,
        if (receiptType != null) 'receiptType': receiptType,
        'cardCurrency': cardCurrency,
        'payoutCurrency': payoutCurrency,
        'cardAmount': cardAmount,
      },
    );
  }

  Map<String, dynamic> _findProduct(
    List<dynamic> catalog,
    String cardName,
    String? cardSlug,
  ) {
    for (final item in catalog.whereType<Map>()) {
      if (_matchesCard(item, cardName, cardSlug)) {
        return Map<String, dynamic>.from(item);
      }
    }
    return <String, dynamic>{};
  }

  bool _matchesCard(Map product, String cardName, [String? cardSlug]) {
    String normalize(String value) =>
        value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    final requested = normalize(cardName);
    final requestedSlug = normalize(cardSlug ?? '');
    final slug = normalize(product['slug']?.toString() ?? '');
    final name = normalize(product['name']?.toString() ?? '');
    if (slug.isEmpty && name.isEmpty) return false;
    return (requestedSlug.isNotEmpty && slug == requestedSlug) ||
      slug == requested ||
        name == requested ||
        slug.contains(requested) ||
      requested.contains(slug) ||
      (requestedSlug.isNotEmpty &&
        (slug.contains(requestedSlug) || requestedSlug.contains(slug)));
  }

  String _symbolForCurrency(String currency) =>
      {
        'USD': r'$',
        'GBP': '£',
        'EUR': '€',
        'CAD': r'C$',
        'AUD': r'A$',
        'JPY': '¥',
        'CHF': 'CHF',
        'DKK': 'kr',
        'NOK': 'kr',
        'SEK': 'kr',
        'NZD': r'NZ$',
        'TRY': '₺',
        'PLN': 'zł',
      }[currency] ??
      currency;

  String _flagForCountry(String code) {
    const combined = {
      'CH': '🇨🇭🇱🇮',
      'EU': '🇪🇺',
    };
    if (combined.containsKey(code)) return combined[code]!;
    if (code.length == 2 && code.codeUnits.every((unit) => unit >= 65 && unit <= 90)) {
      return String.fromCharCodes(code.codeUnits.map((unit) => 0x1F1E6 + unit - 65));
    }
    return {
        'US': '🇺🇸',
        'GB': '🇬🇧',
        'CA': '🇨🇦',
        'AU': '🇦🇺',
        'DE': '🇩🇪',
    }[code] ?? '🌍';
  }

  double? _providerRate(Object? rates, String currency, String cardType, double amount) {
    if (rates is! Map) return null;
    final typeNode = rates[currency] is Map ? rates[currency][cardType] : null;
    if (typeNode is! Map) return null;
    for (final value in typeNode.values) {
      final rate = _rateValue(value, amount);
      if (rate != null) return rate;
    }
    return null;
  }

  String? _payoutCurrency(Object? rates, String currency, String cardType) {
    if (rates is! Map) return null;
    final typeNode = rates[currency] is Map ? rates[currency][cardType] : null;
    if (typeNode is! Map || typeNode.isEmpty) return null;
    return typeNode.keys.first.toString().toUpperCase();
  }

  double? _rateValue(Object? value, double amount) {
    if (value is num) return value.toDouble();
    if (value is List) {
      for (final item in value.whereType<Map>()) {
        final min = double.tryParse(item['min']?.toString() ?? '');
        final max = double.tryParse(item['max']?.toString() ?? '');
        if ((min == null || amount >= min) && (max == null || amount <= max)) {
          return double.tryParse(item['rate']?.toString() ?? '');
        }
      }
    }
    if (value is Map) {
      for (final item in value.values) {
        final rate = _rateValue(item, amount);
        if (rate != null) return rate;
      }
    }
    return null;
  }

  double _ratePercentage(double providerRate, String payoutCurrency, String cardCurrency) {
    final payoutUsd = ExchangeRateProvider.convertToUSD(providerRate, payoutCurrency);
    final cardUnitUsd = ExchangeRateProvider.convertToUSD(1, cardCurrency);
    if (payoutUsd <= 0 || cardUnitUsd <= 0) return 0;
    return payoutUsd / cardUnitUsd * 100;
  }
}
