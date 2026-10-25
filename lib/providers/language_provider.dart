import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/authentication/services/authentication_service.dart';
import '../screens/profile/language/data/language_data.dart';
import '../screens/profile/language/models/language_model.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'selected_language_id';

  LanguageModel _currentLanguage = LanguageData.defaultLanguage;
  bool _isInitialized = false;

  LanguageProvider() {
    _loadSavedLanguage();
  }

  LanguageModel get currentLanguage => _currentLanguage;
  Locale get locale => _currentLanguage.locale;
  bool get isRtl => _currentLanguage.isRtl;
  bool get isInitialized => _isInitialized;

  List<Locale> get supportedLocales => LanguageData.supportedLocales;

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedId = prefs.getString(_languageKey);

      if (savedId != null && savedId.isNotEmpty) {
        _currentLanguage = LanguageData.findById(savedId);
      } else {
        _currentLanguage = LanguageData.defaultLanguage;
      }

      // Check if user is authenticated and fetch their backend preference
      _syncFromBackendIfAvailable();
    } catch (_) {
      _currentLanguage = LanguageData.defaultLanguage;
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> _syncFromBackendIfAvailable() async {
    try {
      final auth = AuthenticationService();
      if (auth.isAuthenticated) {
        final profile = await auth.getUserProfile('');
        final serverLang = profile?['preferredLanguage'] as String?;
        if (serverLang != null && serverLang.isNotEmpty) {
          final matched = LanguageData.findById(serverLang);
          if (matched.id != _currentLanguage.id) {
            _currentLanguage = matched;
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString(_languageKey, matched.id);
            notifyListeners();
          }
        }
      }
    } catch (_) {}
  }

  Future<void> syncUserLanguage(String? languageId) async {
    if (languageId == null || languageId.isEmpty) return;
    final matched = LanguageData.findById(languageId);
    if (matched.id != _currentLanguage.id) {
      _currentLanguage = matched;
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_languageKey, matched.id);
      } catch (_) {}
      notifyListeners();
    }
  }

  Future<void> changeLanguage(LanguageModel language) async {
    if (_currentLanguage.id == language.id) return;

    _currentLanguage = language;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, language.id);
    } catch (_) {}

    // Sync to user profile on the backend so any new device/phone will have it
    try {
      final auth = AuthenticationService();
      if (auth.isAuthenticated) {
        await auth.updatePreferredLanguage(language.id);
      }
    } catch (_) {}
  }

  Future<void> setLanguageById(String id) async {
    final language = LanguageData.findById(id);
    await changeLanguage(language);
  }
}
