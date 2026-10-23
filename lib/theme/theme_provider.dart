import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier with WidgetsBindingObserver {
  static const String _themePreferenceKey = 'selected_theme_mode';

  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider() {
    WidgetsBinding.instance.addObserver(this);
    _loadTheme();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    if (_themeMode == ThemeMode.system) {
      notifyListeners();
    }
  }

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_themePreferenceKey);

    switch (savedTheme) {
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      case 'system':
      case null:
        _themeMode = ThemeMode.system;
        break;
    }

    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) {
      return;
    }

    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themePreferenceKey, mode.name);
    notifyListeners();
  }

  Future<void> setThemeOption(String option) async {
    switch (option) {
      case 'light':
        await setThemeMode(ThemeMode.light);
        break;
      case 'dark':
        await setThemeMode(ThemeMode.dark);
        break;
      case 'system':
      default:
        await setThemeMode(ThemeMode.system);
        break;
    }
  }

  void toggleTheme(bool isDark) {
    setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
