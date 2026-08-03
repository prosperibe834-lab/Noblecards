class CountryModel {
  final String id;
  final String name;
  final String flag;
  final String code;

  const CountryModel({
    required this.id,
    required this.name,
    required this.flag,
    required this.code,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      flag: json['flag'] as String,
      code: json['code'] as String,
    );
  }
}