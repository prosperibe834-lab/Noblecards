import 'dart:async';

import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  Timer? _debounce;
  String _query = '';
  List<String> _recentSearches = ['Apple', 'Amazon', 'Steam'];

  String get query => _query;
  List<String> get recentSearches => _recentSearches;

  void setQuery(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _query = value;
      notifyListeners();
    });
  }

  void addRecentSearch(String value) {
    if (value.isNotEmpty && !_recentSearches.contains(value)) {
      _recentSearches.insert(0, value);
      notifyListeners();
    }
  }

  void clearQuery() {
    _debounce?.cancel();
    _query = '';
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
