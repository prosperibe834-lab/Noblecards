class GiftCardRegionModel {
  final String id;
  final String countryName;
  final String countryCode;
  final String flag;
  final String currencyCode;
  final String currencySymbol;
  final double buyRate;
  final double sellRate;
  final List<String> availableDenominations;
  final bool isAvailable;
  final String minimumAmount;
  final String maximumAmount;

  const GiftCardRegionModel({
    required this.id,
    required this.countryName,
    required this.countryCode,
    required this.flag,
    required this.currencyCode,
    required this.currencySymbol,
    required this.buyRate,
    required this.sellRate,
    required this.availableDenominations,
    required this.isAvailable,
    this.minimumAmount = '',
    this.maximumAmount = '',
  });

  GiftCardRegionModel copyWith({
    String? id,
    String? countryName,
    String? countryCode,
    String? flag,
    String? currencyCode,
    String? currencySymbol,
    double? buyRate,
    double? sellRate,
    List<String>? availableDenominations,
    bool? isAvailable,
    String? minimumAmount,
    String? maximumAmount,
  }) {
    return GiftCardRegionModel(
      id: id ?? this.id,
      countryName: countryName ?? this.countryName,
      countryCode: countryCode ?? this.countryCode,
      flag: flag ?? this.flag,
      currencyCode: currencyCode ?? this.currencyCode,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      buyRate: buyRate ?? this.buyRate,
      sellRate: sellRate ?? this.sellRate,
      availableDenominations:
          availableDenominations ?? this.availableDenominations,
      isAvailable: isAvailable ?? this.isAvailable,
      minimumAmount: minimumAmount ?? this.minimumAmount,
      maximumAmount: maximumAmount ?? this.maximumAmount,
    );
  }
}
