// Location: lib/deposit/providers/favourite_currencies_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/deposit_currency.dart';

class FavouriteCurrenciesProvider extends ChangeNotifier {
  static const String _prefsKey = 'favourite_currencies_list';
  
  List<String> _favouriteCurrencyCodes = [];
  String _searchQuery = '';
  bool _isLoading = true;

  FavouriteCurrenciesProvider() {
    _loadFavourites();
  }

  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  // Get all currencies currently matching the search
  List<DepositCurrency> get filteredCurrencies {
    if (_searchQuery.isEmpty) return supportedCurrencies;
    final query = _searchQuery.toLowerCase();
    return supportedCurrencies.where((c) => 
      c.code.toLowerCase().contains(query) || 
      c.name.toLowerCase().contains(query) ||
      c.symbol.toLowerCase().contains(query)
    ).toList();
  }

  // Get the actual currency objects that are marked as favourite
  List<DepositCurrency> get favouriteCurrencies {
    return supportedCurrencies.where((c) => _favouriteCurrencyCodes.contains(c.code)).toList();
  }

  bool isFavourite(String code) => _favouriteCurrencyCodes.contains(code);

  void updateSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> toggleFavourite(String code) async {
    if (_favouriteCurrencyCodes.contains(code)) {
      _favouriteCurrencyCodes.remove(code);
    } else {
      _favouriteCurrencyCodes.add(code);
    }
    notifyListeners();
    await _saveFavourites();
  }

  Future<void> _loadFavourites() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getStringList(_prefsKey);
      
      if (saved != null && saved.isNotEmpty) {
        _favouriteCurrencyCodes = saved;
      } else {
        // Default favourites if none saved
        _favouriteCurrencyCodes = ['USD', 'NGN', 'GBP'];
      }
    } catch (e) {
      _favouriteCurrencyCodes = ['USD', 'NGN', 'GBP'];
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveFavourites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_prefsKey, _favouriteCurrencyCodes);
    } catch (e) {
      debugPrint('Failed to save favourite currencies: $e');
    }
  }
}
