class CountryHelper {
  /// Converts any 2-letter ISO country code into its authentic Unicode flag emoji.
  /// E.g. "JP" -> 🇯🇵, "US" -> 🇺🇸, "FR" -> 🇫🇷, "CH" -> 🇨🇭, "DE" -> 🇩🇪, "GB" -> 🇬🇧
  static String flagEmoji(String? countryCode) {
    if (countryCode == null) return '🌐';
    final code = countryCode.trim().toUpperCase();
    if (code.length != 2) return '🌐';

    // Verify ASCII A-Z
    final c1 = code.codeUnitAt(0);
    final c2 = code.codeUnitAt(1);
    if (c1 < 65 || c1 > 90 || c2 < 65 || c2 > 90) return '🌐';

    // Regional indicator symbols start at 0x1F1E6 for 'A'
    final first = c1 - 65 + 0x1F1E6;
    final second = c2 - 65 + 0x1F1E6;
    return String.fromCharCodes([first, second]);
  }

  /// Full display country name mapping for common country codes
  static String countryName(String? countryCode) {
    if (countryCode == null || countryCode.isEmpty) return 'Global';
    final code = countryCode.trim().toUpperCase();

    const names = {
      'US': 'United States',
      'GB': 'United Kingdom',
      'CA': 'Canada',
      'NG': 'Nigeria',
      'GH': 'Ghana',
      'AU': 'Australia',
      'FR': 'France',
      'DE': 'Germany',
      'IT': 'Italy',
      'ES': 'Spain',
      'JP': 'Japan',
      'CH': 'Switzerland',
      'LU': 'Luxembourg',
      'NL': 'Netherlands',
      'SE': 'Sweden',
      'NO': 'Norway',
      'DK': 'Denmark',
      'PL': 'Poland',
      'BR': 'Brazil',
      'MX': 'Mexico',
      'IN': 'India',
      'ZA': 'South Africa',
      'KE': 'Kenya',
      'AE': 'United Arab Emirates',
      'SA': 'Saudi Arabia',
      'SG': 'Singapore',
      'NZ': 'New Zealand',
      'IE': 'Ireland',
      'BE': 'Belgium',
      'AT': 'Austria',
      'PT': 'Portugal',
      'TR': 'Turkey',
      'EU': 'Europe',
      'HK': 'Hong Kong',
      'KR': 'South Korea',
    };

    return names[code] ?? code;
  }

  /// Extracts a canonical brand key for grouping regional products together
  /// (e.g. "Amazon.jp", "Amazon.fr", "Amazon.com.be", "Amazon.com.mx" -> "amazon")
  static String extractBrandKey(String rawName) {
    var name = rawName.toLowerCase().trim();

    // High-priority brand keyword matching
    if (name.contains('amazon')) return 'amazon';
    if (name.contains('apple') || name.contains('itunes')) return 'apple';
    if (name.contains('google play') || name.startsWith('google')) return 'google play';
    if (name.contains('steam')) return 'steam';
    if (name.contains('playstation') || name.contains('psn')) return 'playstation';
    if (name.contains('xbox')) return 'xbox';
    if (name.contains('netflix')) return 'netflix';
    if (name.contains('spotify')) return 'spotify';
    if (name.contains('uber eats')) return 'uber eats';
    if (name.startsWith('uber')) return 'uber';
    if (name.startsWith('flixtrain')) return 'flixtrain';
    if (name.startsWith('flixbus')) return 'flixbus';
    if (name.startsWith('primark') || name.startsWith('penneys')) return 'primark';
    if (name.startsWith('zalando')) return 'zalando';
    if (name.startsWith('carrefour')) return 'carrefour';
    if (name.startsWith('decathlon')) return 'decathlon';
    if (name.startsWith('ikea')) return 'ikea';
    if (name.startsWith('airbnb')) return 'airbnb';
    if (name.startsWith('starbucks')) return 'starbucks';
    if (name.startsWith('nike')) return 'nike';
    if (name.startsWith('adidas')) return 'adidas';
    if (name.startsWith('roblox')) return 'roblox';
    if (name.startsWith('razer')) return 'razer gold';
    if (name.startsWith('ebay')) return 'ebay';
    if (name.startsWith('walmart')) return 'walmart';
    if (name.startsWith('target')) return 'target';
    if (name.startsWith('sephora')) return 'sephora';

    // Generic domain & TLD stripping (.com.be, .co.uk, .com.mx, .de, .fr, .jp, .eg, etc.)
    name = name.replaceAll(
      RegExp(r'\.[a-z]{2,4}(\.[a-z]{2,4})?', caseSensitive: false),
      '',
    );

    // Strip country abbreviations or parenthesized codes like (US), (UK), - DE, DE, AT
    name = name.replaceAll(
      RegExp(
        r'[\(\[\-–—/,\s]+([a-z]{2,3}|usa|uk|eur|gbp|usd|cad|aud|jpy|ngn|ghs|uae)\b',
        caseSensitive: false,
      ),
      '',
    );

    // Strip trailing generic words
    name = name.replaceAll(
      RegExp(r'\b(gift\s*card|e-?gift|voucher|store)\b', caseSensitive: false),
      '',
    );

    name = name.trim().replaceAll(RegExp(r'\s+'), ' ');
    return name.isEmpty ? rawName.toLowerCase().trim() : name;
  }

  /// Generates a clean, professional display brand name
  static String cleanBrandName(String rawName) {
    final key = extractBrandKey(rawName);

    // Known curated brand display names
    switch (key) {
      case 'amazon':
        return 'Amazon';
      case 'apple':
        return 'Apple';
      case 'google play':
        return 'Google Play';
      case 'steam':
        return 'Steam';
      case 'playstation':
        return 'PlayStation';
      case 'xbox':
        return 'Xbox';
      case 'netflix':
        return 'Netflix';
      case 'spotify':
        return 'Spotify';
      case 'uber eats':
        return 'Uber Eats';
      case 'uber':
        return 'Uber';
      case 'flixtrain':
        return 'FlixTrain';
      case 'flixbus':
        return 'FlixBus';
      case 'primark':
        return 'Primark';
      case 'zalando':
        return 'Zalando';
      case 'carrefour':
        return 'Carrefour';
      case 'decathlon':
        return 'Decathlon';
      case 'ikea':
        return 'IKEA';
      case 'airbnb':
        return 'Airbnb';
      case 'starbucks':
        return 'Starbucks';
      case 'nike':
        return 'Nike';
      case 'adidas':
        return 'Adidas';
      case 'roblox':
        return 'Roblox';
      case 'razer gold':
        return 'Razer Gold';
      case 'ebay':
        return 'eBay';
      case 'walmart':
        return 'Walmart';
      case 'target':
        return 'Target';
      case 'sephora':
        return 'Sephora';
      default:
        return key.split(' ').map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1);
        }).join(' ');
    }
  }

  /// Resolves a clean display category for any brand
  static String detectCategory(String brandName, String? rawCategory) {
    final key = extractBrandKey(brandName);
    if (key == 'amazon' ||
        key == 'ebay' ||
        key == 'walmart' ||
        key == 'target' ||
        key == 'nike' ||
        key == 'adidas' ||
        key == 'ikea' ||
        key == 'sephora' ||
        key == 'primark' ||
        key == 'zalando' ||
        key == 'carrefour' ||
        key == 'decathlon') {
      return 'Shopping';
    }
    if (key == 'playstation' ||
        key == 'xbox' ||
        key == 'steam' ||
        key == 'roblox' ||
        key == 'razer gold') {
      return 'Gaming';
    }
    if (key == 'netflix' ||
        key == 'spotify' ||
        key == 'apple' ||
        key == 'google play') {
      return 'Entertainment';
    }
    if (key == 'uber eats' || key == 'starbucks') {
      return 'Dining';
    }
    if (key == 'uber' ||
        key == 'flixbus' ||
        key == 'flixtrain' ||
        key == 'airbnb') {
      return 'Travel';
    }

    if (rawCategory != null &&
        rawCategory.isNotEmpty &&
        !rawCategory.contains('.')) {
      final clean = rawCategory.replaceAll('_', ' ').trim();
      return clean[0].toUpperCase() + clean.substring(1);
    }
    return 'Shopping';
  }
}
