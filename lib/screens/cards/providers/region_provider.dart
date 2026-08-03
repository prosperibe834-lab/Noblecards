import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/gift_card_region_model.dart';
import '../services/region_service.dart';

class RegionProvider extends ChangeNotifier {
  RegionProvider({RegionService? service}) : _service = service ?? RegionService() {
    loadRegions();
  }

  final RegionService _service;

  bool _isLoading = false;
  String _searchQuery = '';
  List<GiftCardRegionModel> _regions = [];
  GiftCardRegionModel? _selectedRegion;

  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  List<GiftCardRegionModel> get regions => _regions;
  GiftCardRegionModel? get selectedRegion => _selectedRegion;

  List<GiftCardRegionModel> get filteredRegions {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return _regions;
    }

    return _regions.where((region) {
      final name = region.countryName.toLowerCase();
      final code = region.countryCode.toLowerCase();
      final currency = region.currencyCode.toLowerCase();
      return name.contains(query) || code.contains(query) || currency.contains(query);
    }).toList();
  }

  Future<void> loadRegions() async {
    _isLoading = true;
    notifyListeners();

    final regions = await _service.loadRegions();
    _regions = regions;
    if (_selectedRegion == null && regions.isNotEmpty) {
      _selectedRegion = regions.first;
    }

    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void selectRegion(GiftCardRegionModel region) {
    _selectedRegion = region;
    HapticFeedback.lightImpact();
    notifyListeners();
  }
}
