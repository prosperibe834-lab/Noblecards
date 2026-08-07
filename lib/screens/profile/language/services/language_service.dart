import '../models/language_model.dart';
import '../data/language_data.dart';

class LanguageService {
  Future<List<LanguageModel>> getLanguages() async {
    // Simulate network delay for shimmer effect
    await Future.delayed(const Duration(milliseconds: 1500));
    return LanguageData.languages;
  }
}