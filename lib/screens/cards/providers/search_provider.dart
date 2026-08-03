import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  String _query = '';
  List<String> _recentSearches = ['Apple', 'Amazon', 'Steam'];

  String get query => _query;
  List<String> get recentSearches => _recentSearches;

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void addRecentSearch(String value) {
    if (value.isNotEmpty && !_recentSearches.contains(value)) {
      _recentSearches.insert(0, value);
      notifyListeners();
    }
  }

  void clearQuery() {
    _query = '';
    notifyListeners();
  }
}