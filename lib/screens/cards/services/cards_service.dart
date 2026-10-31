import '../models/gift_card_model.dart';
import '../models/gift_card_region_model.dart';
import '../utils/country_helper.dart';
import '../../authentication/services/authentication_service.dart';

class CardsService {
  final AuthenticationService _authentication;

  static List<GiftCardModel>? _cachedCatalog;
  static DateTime? _lastFetchTime;

  CardsService({AuthenticationService? authentication})
      : _authentication = authentication ?? AuthenticationService();

  static bool get hasCachedCatalog =>
      _cachedCatalog != null && _cachedCatalog!.isNotEmpty;

  static List<GiftCardModel> getCachedCatalog() => _cachedCatalog ?? const [];

  static void clearCache() {
    _cachedCatalog = null;
    _lastFetchTime = null;
  }

  Future<List<GiftCardModel>> fetchCards({
    String? countryCode,
    bool forceRefresh = false,
  }) async {
    // Return cached catalog instantly if available and fresh (< 10 minutes)
    if (!forceRefresh &&
        countryCode == null &&
        _cachedCatalog != null &&
        _lastFetchTime != null &&
        DateTime.now().difference(_lastFetchTime!).inMinutes < 10) {
      return _cachedCatalog!;
    }

    final query = countryCode == null
        ? ''
        : '?country=${Uri.encodeQueryComponent(countryCode)}';
    final response = await _authentication.authenticatedGet(
      '/gift-cards/buy/catalog$query',
    );

    final rawCards = parseCatalogResponse(response);
    final groupedCards = groupCatalogByBrand(rawCards);

    if (countryCode == null) {
      _cachedCatalog = groupedCards;
      _lastFetchTime = DateTime.now();
    }

    return groupedCards;
  }

  /// Groups regional products (e.g. Amazon.jp, Amazon.fr, Amazon US) into ONE card per brand
  List<GiftCardModel> groupCatalogByBrand(List<GiftCardModel> rawCards) {
    final Map<String, List<GiftCardModel>> groups = {};

    for (final card in rawCards) {
      final key = CountryHelper.extractBrandKey(card.name);
      groups.putIfAbsent(key, () => []).add(card);
    }

    final List<GiftCardModel> consolidated = [];

    for (final entry in groups.entries) {
      final cards = entry.value;
      if (cards.isEmpty) continue;

      // Primary card serves as base
      final primary = cards.first;
      final cleanName = CountryHelper.cleanBrandName(primary.name);

      // Find first non-empty logo across all variants in this brand
      String brandLogo = primary.logoUrl;
      for (final c in cards) {
        if (c.logoUrl.isNotEmpty) {
          brandLogo = c.logoUrl;
          break;
        }
      }

      // Collect and deduplicate all supported regions across variants
      final Map<String, GiftCardRegionModel> regionMap = {};

      for (final c in cards) {
        for (final reg in c.supportedRegions) {
          final regionKey = '${reg.countryCode}-${reg.currencyCode}'.toUpperCase();
          if (!regionMap.containsKey(regionKey)) {
            regionMap[regionKey] = reg.copyWith(productId: c.id);
          }
        }
      }

      final allRegions = regionMap.values.toList();
      // Sort regions: US and GB first, then alphabetical by country name
      allRegions.sort((a, b) {
        if (a.countryCode == 'US') return -1;
        if (b.countryCode == 'US') return 1;
        if (a.countryCode == 'GB') return -1;
        if (b.countryCode == 'GB') return 1;
        return a.countryName.compareTo(b.countryName);
      });

      // Compute display country & flag
      String displayCountry;
      String displayFlag;

      if (allRegions.length == 1) {
        displayCountry = allRegions.first.countryName;
        displayFlag = allRegions.first.flag;
      } else if (allRegions.length > 1) {
        displayCountry = '${allRegions.length} Countries';
        displayFlag = '🌐';
      } else {
        displayCountry = primary.country;
        displayFlag = primary.countryFlag;
      }

      // Best rate among variants
      final bestRate = cards.map((c) => c.buyRate).where((r) => r > 0).fold<double>(
            primary.buyRate,
            (prev, r) => prev == 0 ? r : (r < prev ? r : prev),
          );

      // Aggregate denominations
      final Set<String> allDenoms = {};
      for (final c in cards) {
        allDenoms.addAll(c.denominations);
      }

      consolidated.add(
        primary.copyWith(
          name: cleanName,
          category: CountryHelper.detectCategory(cleanName, primary.category),
          logoUrl: brandLogo,
          country: displayCountry,
          countryFlag: displayFlag,
          buyRate: bestRate,
          supportedRegions: allRegions,
          denominations: allDenoms.toList(),
        ),
      );
    }

    // Sort catalog: Popular brands first, then alphabetical
    consolidated.sort((a, b) {
      final aKey = a.name.toLowerCase();
      final bKey = b.name.toLowerCase();
      int score(String k) {
        if (k.contains('amazon')) return 100;
        if (k.contains('apple')) return 95;
        if (k.contains('google')) return 90;
        if (k.contains('steam')) return 85;
        if (k.contains('playstation')) return 80;
        if (k.contains('xbox')) return 75;
        if (k.contains('netflix')) return 70;
        if (k.contains('spotify')) return 65;
        if (k.contains('uber')) return 60;
        return 0;
      }
      final diff = score(bKey) - score(aKey);
      if (diff != 0) return diff;
      return a.name.compareTo(b.name);
    });

    return consolidated;
  }

  List<GiftCardModel> parseCatalogResponse(Map<String, dynamic> response) {
    final products = response['products'];
    if (products is! List) return const [];

    return products.whereType<Map>().map((product) {
      final id = product['productId']?.toString() ??
          product['providerProductId']?.toString() ??
          product['id']?.toString() ??
          'gift-card';
      final name = product['productName']?.toString() ??
          product['brandName']?.toString() ??
          'Gift Card';
      final countryCode = (product['countryCode'] ?? product['country'] ?? '')
          .toString()
          .toUpperCase();
      final countryName = CountryHelper.countryName(countryCode);
      final currencyCode =
          (product['currency'] ?? 'USD').toString().toUpperCase();
      final rate = double.tryParse(
            product['customerRatePercent']?.toString() ??
                product['baseBuyRatePercent']?.toString() ??
                '0',
          ) ??
          0;
      final denominations = product['denominations'] is List
          ? (product['denominations'] as List)
              .map((value) => double.tryParse(value.toString()))
              .whereType<double>()
              .toList()
          : <double>[];
      final minimum = product['minimumAmount']?.toString() ??
          (denominations.isEmpty
              ? ''
              : denominations.reduce((a, b) => a < b ? a : b).toString());
      final maximum = product['maximumAmount']?.toString() ??
          (denominations.isEmpty
              ? ''
              : denominations.reduce((a, b) => a > b ? a : b).toString());
      final rawSupportedCountries = product['supportedCountries'] is List
          ? (product['supportedCountries'] as List).whereType<Map>().toList()
          : <Map>[];
      final supportedCountries =
          rawSupportedCountries.isEmpty && countryCode.isNotEmpty
              ? [
                  {
                    'countryCode': countryCode,
                    'country': product['country'],
                    'currency': currencyCode,
                    'denominations': denominations,
                    'minimumAmount': minimum,
                    'maximumAmount': maximum,
                    'customerRatePercent': rate,
                  },
                ]
              : rawSupportedCountries;
      final supportedRegions = supportedCountries
          .map((country) {
            final code = (country['countryCode'] ?? country['code'] ?? '')
                .toString()
                .toUpperCase();
            if (code.isEmpty) return null;
            final currency =
                (country['currency'] ?? currencyCode).toString().toUpperCase();
            final countryDenominations = country['denominations'] is List
                ? (country['denominations'] as List)
                    .map((value) => value.toString())
                    .toList()
                : denominations.map((value) => value.toString()).toList();
            final countryRate = double.tryParse(
                  country['customerRatePercent']?.toString() ?? '',
                ) ??
                rate;
            final reportedCountryName = (country['countryName'] ??
                    country['label'] ??
                    country['country'])
                ?.toString()
                .trim();
            final resolvedName = reportedCountryName != null &&
                    reportedCountryName.isNotEmpty &&
                    reportedCountryName.toUpperCase() != code
                ? reportedCountryName
                : CountryHelper.countryName(code);

            return GiftCardRegionModel(
              id: '$id-$code-$currency'.toLowerCase(),
              countryName: resolvedName,
              countryCode: code,
              flag: CountryHelper.flagEmoji(code),
              currencyCode: currency,
              currencySymbol: _currencySymbol(currency),
              buyRate: countryRate,
              sellRate: countryRate,
              availableDenominations: countryDenominations,
              isAvailable: true,
              minimumAmount: country['minimumAmount']?.toString() ?? minimum,
              maximumAmount: country['maximumAmount']?.toString() ?? maximum,
              productId: id,
            );
          })
          .whereType<GiftCardRegionModel>()
          .toList();

      // Extract official logo from provider metadata or top-level fields
      final pm = product['providerMetadata'];
      String resolvedLogo = '';
      if (pm is Map) {
        if (pm['images'] is List) {
          final images = pm['images'] as List;
          for (final img in images) {
            if (img is Map && img['type'] == 'logo' && img['src'] != null) {
              resolvedLogo = img['src'].toString();
              break;
            }
          }
          if (resolvedLogo.isEmpty && images.isNotEmpty && images.first is Map) {
            resolvedLogo = images.first['src']?.toString() ?? '';
          }
        }
        if (resolvedLogo.isEmpty && pm['logoUrl'] != null) {
          resolvedLogo = pm['logoUrl'].toString();
        }
      }
      if (resolvedLogo.isEmpty) {
        resolvedLogo = product['logoUrl']?.toString() ??
            product['brandLogo']?.toString() ??
            product['imageUrl']?.toString() ??
            (product['logoUrls'] is List && (product['logoUrls'] as List).isNotEmpty
                ? (product['logoUrls'] as List).first.toString()
                : '');
      }

      return GiftCardModel(
        id: id,
        name: name,
        logoUrl: resolvedLogo,
        country: countryName,
        countryFlag: CountryHelper.flagEmoji(countryCode),
        category: CountryHelper.detectCategory(
          name,
          product['subcategory']?.toString() ??
              product['category']?.toString(),
        ),
        description:
            product['description']?.toString() ?? '$currencyCode gift card',
        buyRate: rate,
        sellRate: rate,
        currency: currencyCode,
        minDenomination: minimum,
        maxDenomination: maximum,
        countryCode: countryCode.isEmpty ? null : countryCode,
        provider: product['provider']?.toString() ?? '',
        denominationType: product['denominationType']?.toString() ?? '',
        redemptionInstructions:
            product['redemptionInstructions']?.toString() ?? '',
        denominations: denominations.map((value) => value.toString()).toList(),
        supportedRegions: supportedRegions,
        productData: Map<String, dynamic>.from(product),
        isAvailable: true,
        isInstant: true,
        isTrending: false,
        isFavorite: false,
        popularityRank: 0,
      );
    }).toList();
  }

  String _currencySymbol(String currency) =>
      {
        'USD': r'$',
        'GBP': '£',
        'CAD': r'C$',
        'AUD': r'A$',
        'EUR': '€',
        'NGN': '₦',
        'GHS': '₵',
        'ZAR': 'R',
        'JPY': '¥',
        'CHF': 'CHF',
        'SEK': 'kr',
        'NOK': 'kr',
        'DKK': 'kr',
        'NZD': r'NZ$',
        'PLN': 'zł',
        'TRY': '₺',
        'AED': 'AED',
        'SAR': 'SAR',
        'SGD': r'S$',
      }[currency.toUpperCase()] ??
      currency;
}
