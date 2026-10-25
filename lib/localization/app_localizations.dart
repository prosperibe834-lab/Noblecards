import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_translations.dart';

class FallbackMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    if (GlobalMaterialLocalizations.delegate.isSupported(locale)) {
      try {
        return await GlobalMaterialLocalizations.delegate.load(locale);
      } catch (_) {}
    }
    return await GlobalMaterialLocalizations.delegate.load(const Locale('en', 'US'));
  }

  @override
  bool shouldReload(FallbackMaterialLocalizationsDelegate old) => false;
}

class FallbackCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) async {
    if (GlobalCupertinoLocalizations.delegate.isSupported(locale)) {
      try {
        return await GlobalCupertinoLocalizations.delegate.load(locale);
      } catch (_) {}
    }
    return await GlobalCupertinoLocalizations.delegate.load(const Locale('en', 'US'));
  }

  @override
  bool shouldReload(FallbackCupertinoLocalizationsDelegate old) => false;
}

class FallbackWidgetsLocalizationsDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const FallbackWidgetsLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<WidgetsLocalizations> load(Locale locale) async {
    if (GlobalWidgetsLocalizations.delegate.isSupported(locale)) {
      try {
        return await GlobalWidgetsLocalizations.delegate.load(locale);
      } catch (_) {}
    }
    return await GlobalWidgetsLocalizations.delegate.load(const Locale('en', 'US'));
  }

  @override
  bool shouldReload(FallbackWidgetsLocalizationsDelegate old) => false;
}

class AppLocalizations {
  final Locale locale;

  const AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    AppLocalizations.delegate,
    FallbackMaterialLocalizationsDelegate(),
    FallbackCupertinoLocalizationsDelegate(),
    FallbackWidgetsLocalizationsDelegate(),
  ];

  String translate(String key, {String? defaultText}) {
    final result = AppTranslations.lookup(
      locale.languageCode,
      key,
      locale.countryCode,
    );
    if (result == key && defaultText != null) {
      return defaultText;
    }
    return result;
  }

  static String tr(
    BuildContext context,
    String key, {
    String? fallback,
  }) {
    final loc = of(context);
    if (loc != null) {
      return loc.translate(key, defaultText: fallback);
    }
    return fallback ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension AppLocalizationExtension on BuildContext {
  String tr(String key, {String? fallback}) {
    final localizations = AppLocalizations.of(this);
    if (localizations != null) {
      return localizations.translate(key, defaultText: fallback);
    }
    return fallback ?? key;
  }
}

extension StringLocalizationExtension on String {
  String tr(BuildContext context, {String? fallback}) {
    return context.tr(this, fallback: fallback);
  }
}
