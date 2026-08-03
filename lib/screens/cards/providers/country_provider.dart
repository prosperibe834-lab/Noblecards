import 'package:flutter/material.dart';
import '../models/country_model.dart';
import '../services/country_service.dart';

class CountryProvider extends ChangeNotifier {
  final CountryService _service = CountryService();

  List<CountryModel> _countries = [];
  CountryModel _selectedCountry = const CountryModel(
    id: 'us',
    name: 'United States',
    flag: '🇺🇸',
    code: 'US',
  );

  List<CountryModel> get countries => _countries;
  CountryModel get selectedCountry => _selectedCountry;

  CountryProvider() {
    loadCountries();
  }

  Future<void> loadCountries() async {
    _countries = await _service.fetchCountries();
    notifyListeners();
  }

  void selectCountry(CountryModel country) {
    _selectedCountry = country;
    notifyListeners();
  }
}