import '../models/country_model.dart';

class CountryService {
  Future<List<CountryModel>> fetchCountries() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      CountryModel(id: 'all', name: 'All Countries', flag: '🌐', code: 'ALL'),
      CountryModel(id: 'us', name: 'United States', flag: '🇺🇸', code: 'US'),
      CountryModel(id: 'ca', name: 'Canada', flag: '🇨🇦', code: 'CA'),
      CountryModel(id: 'uk', name: 'United Kingdom', flag: '🇬🇧', code: 'UK'),
      CountryModel(id: 'de', name: 'Germany', flag: '🇩🇪', code: 'DE'),
      CountryModel(id: 'fr', name: 'France', flag: '🇫🇷', code: 'FR'),
      CountryModel(id: 'au', name: 'Australia', flag: '🇦🇺', code: 'AU'),
      CountryModel(id: 'jp', name: 'Japan', flag: '🇯🇵', code: 'JP'),
    ];
  }
}