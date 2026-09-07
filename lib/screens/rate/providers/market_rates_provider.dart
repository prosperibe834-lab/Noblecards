import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../models/market_rate_model.dart';

class MarketRatesProvider extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String _selectedTab = 'All Cards';
  String get selectedTab => _selectedTab;

  String _selectedSort = 'Highest Buy';
  String get selectedSort => _selectedSort;

  List<MarketRateModel> _allRates = [];

  MarketRatesProvider() {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    _isLoading = true;
    notifyListeners();
    
    // Simulating network delay for shimmer effect
    await Future.delayed(const Duration(milliseconds: 1500));
    
    _allRates = [
      MarketRateModel(id: '1', name: 'Amazon', icon: Boxicons.bxl_amazon, country: 'USA', flag: '🇺🇸', buyRate: 480.00, sellRate: 460.00, change24h: 8.24, category: 'Best Sellers', volume: 2.1),
      MarketRateModel(id: '2', name: 'Apple', icon: Boxicons.bxl_apple, country: 'USA', flag: '🇺🇸', buyRate: 700.00, sellRate: 680.00, change24h: 5.61, category: 'Trending', volume: 1.24),
      MarketRateModel(id: '3', name: 'Steam', icon: Boxicons.bxl_steam, country: 'USA', flag: '🇺🇸', buyRate: 430.00, sellRate: 410.00, change24h: 3.75, category: 'Trending', volume: 0.9),
      MarketRateModel(id: '4', name: 'Google Play', icon: Boxicons.bxl_play_store, country: 'USA', flag: '🇺🇸', buyRate: 340.00, sellRate: 320.00, change24h: 2.31, category: 'Best Sellers', volume: 1.5),
      MarketRateModel(id: '5', name: 'Nike', icon: Boxicons.bx_run, country: 'USA', flag: '🇺🇸', buyRate: 310.00, sellRate: 295.00, change24h: -1.02, category: 'Apparel', volume: 0.4),
      MarketRateModel(id: '6', name: 'Starbucks', icon: Boxicons.bx_coffee, country: 'USA', flag: '🇺🇸', buyRate: 285.00, sellRate: 270.00, change24h: -1.45, category: 'Food', volume: 0.6),
      MarketRateModel(id: '7', name: 'Walmart', icon: Boxicons.bx_store, country: 'USA', flag: '🇺🇸', buyRate: 280.00, sellRate: 265.00, change24h: -2.11, category: 'Best Sellers', volume: 1.8),
    ];
    
    _isLoading = false;
    notifyListeners();
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

  void setSort(String sort) {
    _selectedSort = sort;
    notifyListeners();
  }

  List<MarketRateModel> get filteredAndSortedRates {
    List<MarketRateModel> result = List.from(_allRates);

    // Apply Tab Filter
    if (_selectedTab != 'All Cards') {
      result = result.where((rate) => rate.category == _selectedTab).toList();
    }

    // Apply Search Filter
    if (_searchQuery.isNotEmpty) {
      result = result.where((rate) => rate.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
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