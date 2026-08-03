class GiftCardModel {
  final String id;
  final String name;
  final String logoUrl;
  final String country;
  final String countryFlag;
  final String category;
  final String description;
  final double buyRate;
  final double sellRate;
  final bool isAvailable;
  final bool isInstant;
  final bool isTrending;
  final bool isFavorite;
  final int popularityRank;

  const GiftCardModel({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.country,
    required this.countryFlag,
    required this.category,
    required this.description,
    required this.buyRate,
    required this.sellRate,
    this.isAvailable = true,
    this.isInstant = true,
    this.isTrending = false,
    this.isFavorite = false,
    this.popularityRank = 0,
  });

  GiftCardModel copyWith({
    String? id,
    String? name,
    String? logoUrl,
    String? country,
    String? countryFlag,
    String? category,
    String? description,
    double? buyRate,
    double? sellRate,
    bool? isAvailable,
    bool? isInstant,
    bool? isTrending,
    bool? isFavorite,
    int? popularityRank,
  }) {
    return GiftCardModel(
      id: id ?? this.id,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      country: country ?? this.country,
      countryFlag: countryFlag ?? this.countryFlag,
      category: category ?? this.category,
      description: description ?? this.description,
      buyRate: buyRate ?? this.buyRate,
      sellRate: sellRate ?? this.sellRate,
      isAvailable: isAvailable ?? this.isAvailable,
      isInstant: isInstant ?? this.isInstant,
      isTrending: isTrending ?? this.isTrending,
      isFavorite: isFavorite ?? this.isFavorite,
      popularityRank: popularityRank ?? this.popularityRank,
    );
  }
}