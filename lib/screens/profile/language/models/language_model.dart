class LanguageModel {
  final String id;
  final String name;
  final String flag;
  final bool isDefault;

  const LanguageModel({
    required this.id,
    required this.name,
    required this.flag,
    this.isDefault = false,
  });
}