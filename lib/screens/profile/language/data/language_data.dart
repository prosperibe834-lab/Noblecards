import 'package:flutter/material.dart';
import '../models/language_model.dart';

class LanguageData {
  static const List<LanguageModel> languages = [
    LanguageModel(
      id: '1',
      name: 'English (United States)',
      flag: '🇺🇸',
      code: 'en',
      countryCode: 'US',
      isDefault: true,
    ),
    LanguageModel(
      id: '2',
      name: 'English (United Kingdom)',
      flag: '🇬🇧',
      code: 'en',
      countryCode: 'GB',
    ),
    LanguageModel(
      id: '3',
      name: 'Français (French)',
      flag: '🇫🇷',
      code: 'fr',
    ),
    LanguageModel(
      id: '4',
      name: 'Español (Spanish)',
      flag: '🇪🇸',
      code: 'es',
    ),
    LanguageModel(
      id: '5',
      name: 'Português (Portuguese)',
      flag: '🇵🇹',
      code: 'pt',
    ),
    LanguageModel(
      id: '6',
      name: 'Deutsch (German)',
      flag: '🇩🇪',
      code: 'de',
    ),
    LanguageModel(
      id: '7',
      name: 'Italiano (Italian)',
      flag: '🇮🇹',
      code: 'it',
    ),
    LanguageModel(
      id: '8',
      name: 'Nederlands (Dutch)',
      flag: '🇳🇱',
      code: 'nl',
    ),
    LanguageModel(
      id: '9',
      name: 'العربية (Arabic)',
      flag: '🇸🇦',
      code: 'ar',
      isRtl: true,
    ),
    LanguageModel(
      id: '10',
      name: 'हिन्दी (Hindi)',
      flag: '🇮🇳',
      code: 'hi',
    ),
    LanguageModel(
      id: '11',
      name: 'বাংলা (Bengali)',
      flag: '🇧🇩',
      code: 'bn',
    ),
    LanguageModel(
      id: '12',
      name: 'اردو (Urdu)',
      flag: '🇵🇰',
      code: 'ur',
      isRtl: true,
    ),
    LanguageModel(
      id: '13',
      name: 'Türkçe (Turkish)',
      flag: '🇹🇷',
      code: 'tr',
    ),
    LanguageModel(
      id: '14',
      name: 'Русский (Russian)',
      flag: '🇷🇺',
      code: 'ru',
    ),
    LanguageModel(
      id: '15',
      name: '中文 (Simplified Chinese)',
      flag: '🇨🇳',
      code: 'zh',
      countryCode: 'CN',
    ),
    LanguageModel(
      id: '16',
      name: '中文 (Traditional Chinese)',
      flag: '🇹🇼',
      code: 'zh',
      countryCode: 'TW',
    ),
    LanguageModel(
      id: '17',
      name: '日本語 (Japanese)',
      flag: '🇯🇵',
      code: 'ja',
    ),
    LanguageModel(
      id: '18',
      name: '한국어 (Korean)',
      flag: '🇰🇷',
      code: 'ko',
    ),
    LanguageModel(
      id: '19',
      name: 'ไทย (Thai)',
      flag: '🇹🇭',
      code: 'th',
    ),
    LanguageModel(
      id: '20',
      name: 'Tiếng Việt (Vietnamese)',
      flag: '🇻🇳',
      code: 'vi',
    ),
    LanguageModel(
      id: '21',
      name: 'Bahasa Indonesia',
      flag: '🇮🇩',
      code: 'id',
    ),
    LanguageModel(
      id: '22',
      name: 'Bahasa Melayu',
      flag: '🇲🇾',
      code: 'ms',
    ),
    LanguageModel(
      id: '23',
      name: 'Filipino',
      flag: '🇵🇭',
      code: 'fil',
    ),
    LanguageModel(
      id: '24',
      name: 'Polski (Polish)',
      flag: '🇵🇱',
      code: 'pl',
    ),
    LanguageModel(
      id: '25',
      name: 'Ελληνικά (Greek)',
      flag: '🇬🇷',
      code: 'el',
    ),
    LanguageModel(
      id: '26',
      name: 'Čeština (Czech)',
      flag: '🇨🇿',
      code: 'cs',
    ),
    LanguageModel(
      id: '27',
      name: 'Română (Romanian)',
      flag: '🇷🇴',
      code: 'ro',
    ),
    LanguageModel(
      id: '28',
      name: 'Magyar (Hungarian)',
      flag: '🇭🇺',
      code: 'hu',
    ),
    LanguageModel(
      id: '29',
      name: 'Svenska (Swedish)',
      flag: '🇸🇪',
      code: 'sv',
    ),
    LanguageModel(
      id: '30',
      name: 'Norsk (Norwegian)',
      flag: '🇳🇴',
      code: 'no',
    ),
    LanguageModel(
      id: '31',
      name: 'Dansk (Danish)',
      flag: '🇩🇰',
      code: 'da',
    ),
    LanguageModel(
      id: '32',
      name: 'Suomi (Finnish)',
      flag: '🇫🇮',
      code: 'fi',
    ),
    LanguageModel(
      id: '33',
      name: 'Українська (Ukrainian)',
      flag: '🇺🇦',
      code: 'uk',
    ),
    LanguageModel(
      id: '34',
      name: 'עברית (Hebrew)',
      flag: '🇮🇱',
      code: 'he',
      isRtl: true,
    ),
    LanguageModel(
      id: '35',
      name: 'Kiswahili (Swahili)',
      flag: '🇰🇪',
      code: 'sw',
    ),
    LanguageModel(
      id: '36',
      name: 'Yoruba',
      flag: '🇳🇬',
      code: 'yo',
    ),
    LanguageModel(
      id: '37',
      name: 'Igbo',
      flag: '🇳🇬',
      code: 'ig',
    ),
    LanguageModel(
      id: '38',
      name: 'Hausa',
      flag: '🇳🇬',
      code: 'ha',
    ),
    LanguageModel(
      id: '39',
      name: 'isiZulu',
      flag: '🇿🇦',
      code: 'zu',
    ),
    LanguageModel(
      id: '40',
      name: 'Afrikaans',
      flag: '🇿🇦',
      code: 'af',
    ),
    LanguageModel(
      id: '41',
      name: 'Amharic',
      flag: '🇪🇹',
      code: 'am',
    ),
    LanguageModel(
      id: '42',
      name: 'Somali',
      flag: '🇸🇴',
      code: 'so',
    ),
    LanguageModel(
      id: '43',
      name: 'Nepali',
      flag: '🇳🇵',
      code: 'ne',
    ),
    LanguageModel(
      id: '44',
      name: 'Sinhala',
      flag: '🇱🇰',
      code: 'si',
    ),
    LanguageModel(
      id: '45',
      name: 'Tamil',
      flag: '🇮🇳',
      code: 'ta',
    ),
    LanguageModel(
      id: '46',
      name: 'Telugu',
      flag: '🇮🇳',
      code: 'te',
    ),
    LanguageModel(
      id: '47',
      name: 'Marathi',
      flag: '🇮🇳',
      code: 'mr',
    ),
    LanguageModel(
      id: '48',
      name: 'Gujarati',
      flag: '🇮🇳',
      code: 'gu',
    ),
    LanguageModel(
      id: '49',
      name: 'Kannada',
      flag: '🇮🇳',
      code: 'kn',
    ),
    LanguageModel(
      id: '50',
      name: 'Malayalam',
      flag: '🇮🇳',
      code: 'ml',
    ),
  ];

  static LanguageModel get defaultLanguage =>
      languages.firstWhere((l) => l.isDefault, orElse: () => languages.first);

  static List<Locale> get supportedLocales =>
      languages.map((l) => l.locale).toList();

  static LanguageModel findById(String id) {
    return languages.firstWhere(
      (lang) => lang.id == id,
      orElse: () => defaultLanguage,
    );
  }

  static LanguageModel findByLocale(Locale locale) {
    return languages.firstWhere(
      (lang) =>
          lang.code == locale.languageCode &&
          (lang.countryCode == null || lang.countryCode == locale.countryCode),
      orElse: () => languages.firstWhere(
        (lang) => lang.code == locale.languageCode,
        orElse: () => defaultLanguage,
      ),
    );
  }
}
