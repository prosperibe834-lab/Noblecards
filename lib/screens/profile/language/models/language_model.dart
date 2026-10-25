import 'package:flutter/material.dart';

class LanguageModel {
  final String id;
  final String name;
  final String flag;
  final bool isDefault;
  final String code;
  final String? countryCode;
  final bool isRtl;

  const LanguageModel({
    required this.id,
    required this.name,
    required this.flag,
    this.isDefault = false,
    this.code = 'en',
    this.countryCode,
    this.isRtl = false,
  });

  Locale get locale =>
      countryCode != null ? Locale(code, countryCode) : Locale(code);

  String get localeTag =>
      countryCode != null ? '${code}_$countryCode' : code;
}
