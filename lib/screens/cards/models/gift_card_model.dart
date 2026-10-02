import 'gift_card_region_model.dart';

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
  final String currency;
  final String minDenomination;
  final String maxDenomination;
  final bool isAvailable;
  final bool isInstant;
  final bool isTrending;
  final bool isFavorite;
  final int popularityRank;
  final String? countryCode;
  final String provider;
  final String denominationType;
  final String redemptionInstructions;
  final List<String> denominations;
  final List<String> cardTypes;
  final List<GiftCardRegionModel> supportedRegions;
  final Map<String, dynamic> productData;

  String get catalogKey => '$id|${countryCode ?? ''}|$currency';

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
    this.currency = '',
    this.minDenomination = '',
    this.maxDenomination = '',
    this.isAvailable = true,
    this.isInstant = true,
    this.isTrending = false,
    this.isFavorite = false,
    this.popularityRank = 0,
    this.countryCode,
    this.provider = '',
    this.denominationType = '',
    this.redemptionInstructions = '',
    this.denominations = const [],
    this.cardTypes = const [],
    this.supportedRegions = const [],
    this.productData = const {},
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
    String? currency,
    String? minDenomination,
    String? maxDenomination,
    bool? isAvailable,
    bool? isInstant,
    bool? isTrending,
    bool? isFavorite,
    int? popularityRank,
    String? countryCode,
    String? provider,
    String? denominationType,
    String? redemptionInstructions,
    List<String>? denominations,
    List<String>? cardTypes,
    List<GiftCardRegionModel>? supportedRegions,
    Map<String, dynamic>? productData,
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
      currency: currency ?? this.currency,
      minDenomination: minDenomination ?? this.minDenomination,
      maxDenomination: maxDenomination ?? this.maxDenomination,
      isAvailable: isAvailable ?? this.isAvailable,
      isInstant: isInstant ?? this.isInstant,
      isTrending: isTrending ?? this.isTrending,
      isFavorite: isFavorite ?? this.isFavorite,
      popularityRank: popularityRank ?? this.popularityRank,
      countryCode: countryCode ?? this.countryCode,
      provider: provider ?? this.provider,
      denominationType: denominationType ?? this.denominationType,
      redemptionInstructions:
          redemptionInstructions ?? this.redemptionInstructions,
      denominations: denominations ?? this.denominations,
      cardTypes: cardTypes ?? this.cardTypes,
      supportedRegions: supportedRegions ?? this.supportedRegions,
      productData: productData ?? this.productData,
    );
  }
}
