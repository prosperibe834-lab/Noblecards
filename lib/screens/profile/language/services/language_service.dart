import 'package:shared_preferences/shared_preferences.dart';
import '../models/language_model.dart';
import '../data/language_data.dart';

class LanguageService {
  static const String _languageKey = 'selected_language_id';

  Future<List<LanguageModel>> getLanguages() async {
    // Simulate a brief delay for smooth shimmer effect
    await Future.delayed(const Duration(milliseconds: 400));
    return LanguageData.languages;
  }

  Future<LanguageModel> getSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedId = prefs.getString(_languageKey);
      if (savedId != null) {
        return LanguageData.findById(savedId);
      }
    } catch (_) {}
    return LanguageData.defaultLanguage;
  }

  Future<void> saveLanguage(LanguageModel language) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, language.id);
    } catch (_) {}
  }
}
