import 'package:flutter/material.dart';

class FilterProvider extends ChangeNotifier {
  String _selectedCategory = 'All';
  String _selectedQuickFilter = 'All';

  String get selectedCategory => _selectedCategory;
  String get selectedQuickFilter => _selectedQuickFilter;

  final List<String> categories = const [
    'All', 'Shopping', 'Gaming', 'Streaming', 'Food', 'Travel', 'Finance',
    'Music', 'Fashion', 'Tech', 'Lifestyle', 'Education', 'Mobile', 'Crypto',
    'Sports', 'Beauty', 'Health', 'Digital', 'Utilities'
  ];

  final List<String> quickFilters = const [
    'All', 'Trending', 'Highest Rate', 'Instant Delivery', 'Recently Added', 'Available', 'Favorites'
  ];

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setQuickFilter(String filter) {
    _selectedQuickFilter = filter;
    notifyListeners();
  }

  void resetFilters() {
    _selectedCategory = 'All';
    _selectedQuickFilter = 'All';
    notifyListeners();
  }
}