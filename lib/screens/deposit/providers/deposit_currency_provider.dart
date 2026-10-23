// Location: lib/deposit/providers/deposit_currency_provider.dart
import 'package:flutter/material.dart';
import '../models/deposit_currency.dart';

enum CurrencySortOption {
  popularFirst,
  alphabeticalAZ,
  alphabeticalZA,
}

class DepositCurrencyProvider extends ChangeNotifier {
  DepositCurrency? _selectedCurrency = supportedCurrencies[0];
  String _searchQuery = '';
  String _selectedRegion = 'All Regions';
  bool _popularOnly = false;
  CurrencySortOption _sortOption = CurrencySortOption.popularFirst;

  DepositCurrency? get selectedCurrency => _selectedCurrency;
  String get searchQuery => _searchQuery;
  String get selectedRegion => _selectedRegion;
  bool get popularOnly => _popularOnly;
  CurrencySortOption get sortOption => _sortOption;

  bool get hasActiveFilters =>
      _selectedRegion != 'All Regions' ||
      _popularOnly ||
      _sortOption != CurrencySortOption.popularFirst;

  List<DepositCurrency> get popularCurrencies =>
      supportedCurrencies.where((c) => c.isPopular).toList();

  List<DepositCurrency> get filteredCurrencies {
    List<DepositCurrency> list = List.from(supportedCurrencies);

    // Filter by search query
    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.trim().toLowerCase();
      list = list.where((c) {
        return c.code.toLowerCase().contains(query) ||
            c.name.toLowerCase().contains(query) ||
            c.country.toLowerCase().contains(query) ||
            c.symbol.toLowerCase().contains(query);
      }).toList();
    }

    // Filter by region
    if (_selectedRegion != 'All Regions') {
      list = list.where((c) => c.region == _selectedRegion).toList();
    }

    // Filter by popular only
    if (_popularOnly) {
      list = list.where((c) => c.isPopular).toList();
    }

    // Sort
    switch (_sortOption) {
      case CurrencySortOption.popularFirst:
        list.sort((a, b) {
          if (a.isPopular && !b.isPopular) return -1;
          if (!a.isPopular && b.isPopular) return 1;
          return a.code.compareTo(b.code);
        });
        break;
      case CurrencySortOption.alphabeticalAZ:
        list.sort((a, b) => a.code.compareTo(b.code));
        break;
      case CurrencySortOption.alphabeticalZA:
        list.sort((a, b) => b.code.compareTo(a.code));
        break;
    }

    return list;
  }

  void updateSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  void selectCurrency(DepositCurrency currency) {
    _selectedCurrency = currency;
    notifyListeners();
  }

  void setFilters({
    required String region,
    required bool popularOnly,
    required CurrencySortOption sort,
  }) {
    _selectedRegion = region;
    _popularOnly = popularOnly;
    _sortOption = sort;
    notifyListeners();
  }

  void resetFilters() {
    _selectedRegion = 'All Regions';
    _popularOnly = false;
    _sortOption = CurrencySortOption.popularFirst;
    notifyListeners();
  }
}
