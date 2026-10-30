import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:boxicons/boxicons.dart';
import '../../../core/config/api_config.dart';
import '../models/market_rate_model.dart';

class MarketRatesProvider extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String _selectedTab = 'All Cards';
  String get selectedTab => _selectedTab;

  String _selectedCountry = 'All';
  String get selectedCountry => _selectedCountry;

  String _selectedSort = 'Highest Buy';
  String get selectedSort => _selectedSort;

  List<MarketRateModel> _allRates = [];

  // Dynamic summary metrics from backend
  String _topGainerName = 'Amazon';
  String _topGainerChange = '↑ 8.24%';
  String _mostTradedName = 'Apple';
  String _mostTradedVolume = '\$1.24M';
  String _avgDiscount = '12.6%';

  String get topGainerName => _topGainerName;
  String get topGainerChange => _topGainerChange;
  String get mostTradedName => _mostTradedName;
  String get mostTradedVolume => _mostTradedVolume;
  String get avgDiscount => _avgDiscount;

  List<String> get categories {
    final set = <String>{'All Cards', 'Best Sellers', 'Trending'};
    for (final rate in _allRates) {
      if (rate.category.isNotEmpty) {
        set.add(rate.category);
      }
    }
    return set.toList();
  }

  List<Map<String, String>> get availableCountries {
    final map = <String, String>{};
    for (final rate in _allRates) {
      if (rate.country.isNotEmpty && !map.containsKey(rate.country)) {
        map[rate.country] = rate.flag;
      }
    }
    return map.entries.map((e) => {'country': e.key, 'flag': e.value}).toList();
  }

  MarketRatesProvider() {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/gift-cards/market-rates');
      final response = await http.get(uri, headers: {'ngrok-skip-browser-warning': 'true'}).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is Map<String, dynamic> && decoded['rates'] is List) {
          final list = (decoded['rates'] as List)
              .map((item) => MarketRateModel.fromJson(item as Map<String, dynamic>))
              .toList();
          _allRates = list;

          if (decoded['summary'] is Map<String, dynamic>) {
            final summary = decoded['summary'] as Map<String, dynamic>;
            if (summary['topGainer'] is Map) {
              _topGainerName = summary['topGainer']['name']?.toString() ?? _topGainerName;
              _topGainerChange = summary['topGainer']['change']?.toString() ?? _topGainerChange;
            }
            if (summary['mostTraded'] is Map) {
              _mostTradedName = summary['mostTraded']['name']?.toString() ?? _mostTradedName;
              _mostTradedVolume = summary['mostTraded']['volume']?.toString() ?? _mostTradedVolume;
            }
            if (summary['avgDiscount'] != null) {
              _avgDiscount = summary['avgDiscount'].toString();
            }
          }
        }
      } else {
        if (_allRates.isEmpty) {
          _allRates = _fallbackRates();
        }
      }
    } catch (e) {
      debugPrint('Error fetching market rates from backend: $e');
      if (_allRates.isEmpty) {
        _allRates = _fallbackRates();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<MarketRateModel> _fallbackRates() {
    return [
      MarketRateModel(id: '1', name: 'Amazon', icon: Boxicons.bxl_amazon, country: 'USA', flag: '🇺🇸', buyRate: 480.00, sellRate: 460.00, change24h: 8.24, category: 'Best Sellers', volume: 2.1),
      MarketRateModel(id: '2', name: 'Apple', icon: Boxicons.bxl_apple, country: 'USA', flag: '🇺🇸', buyRate: 700.00, sellRate: 680.00, change24h: 5.61, category: 'Trending', volume: 1.24),
      MarketRateModel(id: '3', name: 'Steam', icon: Boxicons.bxl_steam, country: 'USA', flag: '🇺🇸', buyRate: 430.00, sellRate: 410.00, change24h: 3.75, category: 'Trending', volume: 0.9),
      MarketRateModel(id: '4', name: 'Google Play', icon: Boxicons.bxl_play_store, country: 'USA', flag: '🇺🇸', buyRate: 340.00, sellRate: 320.00, change24h: 2.31, category: 'Best Sellers', volume: 1.5),
      MarketRateModel(id: '5', name: 'Nike', icon: Boxicons.bx_run, country: 'USA', flag: '🇺🇸', buyRate: 310.00, sellRate: 295.00, change24h: -1.02, category: 'Apparel', volume: 0.4),
      MarketRateModel(id: '6', name: 'Starbucks', icon: Boxicons.bx_coffee, country: 'USA', flag: '🇺🇸', buyRate: 285.00, sellRate: 270.00, change24h: -1.45, category: 'Food', volume: 0.6),
      MarketRateModel(id: '7', name: 'Walmart', icon: Boxicons.bx_store, country: 'USA', flag: '🇺🇸', buyRate: 280.00, sellRate: 265.00, change24h: -2.11, category: 'Best Sellers', volume: 1.8),
    ];
  }

  Future<void> refreshRates() async {
    await _loadInitialData();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setTab(String tab) {
    _selectedTab = tab;
    notifyListeners();
  }

  void setCountry(String country) {
    _selectedCountry = country;
    notifyListeners();
  }

  void setSort(String sort) {
    _selectedSort = sort;
    notifyListeners();
  }

  List<MarketRateModel> get filteredAndSortedRates {
    List<MarketRateModel> result = List.from(_allRates);

    // Apply Tab Filter
    if (_selectedTab != 'All Cards') {
      result = result.where((rate) => rate.category.toLowerCase() == _selectedTab.toLowerCase()).toList();
    }

    // Apply Country Filter
    if (_selectedCountry != 'All') {
      result = result.where((rate) => rate.country.toLowerCase() == _selectedCountry.toLowerCase()).toList();
    }

    // Apply Search Filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result.where((rate) =>
        rate.name.toLowerCase().contains(query) ||
        rate.country.toLowerCase().contains(query)
      ).toList();
    }

    // Apply Sort
    switch (_selectedSort) {
      case 'Highest Buy':
        result.sort((a, b) => b.buyRate.compareTo(a.buyRate));
        break;
      case 'Lowest Buy':
        result.sort((a, b) => a.buyRate.compareTo(b.buyRate));
        break;
      case 'Highest Sell':
        result.sort((a, b) => b.sellRate.compareTo(a.sellRate));
        break;
      case 'Biggest 24h Gain':
        result.sort((a, b) => b.change24h.compareTo(a.change24h));
        break;
      case 'Biggest 24h Drop':
        result.sort((a, b) => a.change24h.compareTo(b.change24h));
        break;
    }

    return result;
  }
}