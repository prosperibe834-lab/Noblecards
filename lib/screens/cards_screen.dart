import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boxicons/boxicons.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  // runApp(const CardsScreen());
}



// =============================================================================
// DESIGN SYSTEM & THEME
// =============================================================================

class NobleTheme {
  static const Color primaryPurple = Color(0xFF6E0DD0);
  static const Color secondaryPurple = Color(0xFF923CB5);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color backgroundLight = Color(0xFFF7F8FC);
  static const Color backgroundDark = Color(0xFF0F0F16);
  static const Color cardDark = Color(0xFF1A1A26);
  static const Color textDark = Color(0xFF0D0D12);
  static const Color textLight = Color(0xFFF3F4F6);
  static const Color successGreen = Color(0xFF10B981);

  static LinearGradient primaryGradient = const LinearGradient(
    colors: [primaryPurple, secondaryPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient cardGlassGradient = LinearGradient(
    colors: [Colors.white.withOpacity(0.15), Colors.white.withOpacity(0.05)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: backgroundLight,
    primaryColor: primaryPurple,
    fontFamily: 'SF Pro Display',
    colorScheme: const ColorScheme.light(
      primary: primaryPurple,
      secondary: secondaryPurple,
      surface: Colors.white,
      background: backgroundLight,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundDark,
    primaryColor: primaryPurple,
    fontFamily: 'SF Pro Display',
    colorScheme: const ColorScheme.dark(
      primary: primaryPurple,
      secondary: secondaryPurple,
      surface: cardDark,
      background: backgroundDark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );
}

// =============================================================================
// DATA MODELS
// =============================================================================

class Country {
  final String code;
  final String name;
  final String flag;

  const Country({required this.code, required this.name, required this.flag});
}

class GiftCard {
  final String id;
  final String name;
  final String category;
  final String countryCode;
  final double buyRate; // USD per $100 face value
  final double sellRate; // USD payout per $100 value
  final String logoUrl;
  final Color primaryColor;
  final bool isAvailable;
  final bool isTrending;
  final bool isPopular;
  final bool isNew;
  final String processingTime;
  final double minAmount;
  final double maxAmount;
  final List<int> denominations;
  final String description;
  final DateTime lastUpdated;

  GiftCard({
    required this.id,
    required this.name,
    required this.category,
    required this.countryCode,
    required this.buyRate,
    required this.sellRate,
    required this.logoUrl,
    required this.primaryColor,
    this.isAvailable = true,
    this.isTrending = false,
    this.isPopular = false,
    this.isNew = false,
    required this.processingTime,
    this.minAmount = 10.0,
    this.maxAmount = 500.0,
    required this.denominations,
    required this.description,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();
}

class MarketplaceFilter {
  String selectedCategory;
  String selectedCountryCode;
  String searchQuery;
  String
  quickFilter; // 'All', 'Trending', 'Popular', 'Highest Rate', 'Instant Trade', 'Favorites', 'New'
  bool buyOnly;
  bool sellOnly;
  bool instantTradeOnly;
  bool availableOnly;
  bool favoritesOnly;
  String sortBy; // 'Popularity', 'Highest Rate', 'Lowest Rate', 'A-Z', 'Newest'

  MarketplaceFilter({
    this.selectedCategory = 'All',
    this.selectedCountryCode = 'US',
    this.searchQuery = '',
    this.quickFilter = 'All',
    this.buyOnly = false,
    this.sellOnly = false,
    this.instantTradeOnly = false,
    this.availableOnly = false,
    this.favoritesOnly = false,
    this.sortBy = 'Popularity',
  });

  void reset() {
    selectedCategory = 'All';
    selectedCountryCode = 'US';
    searchQuery = '';
    quickFilter = 'All';
    buyOnly = false;
    sellOnly = false;
    instantTradeOnly = false;
    availableOnly = false;
    favoritesOnly = false;
    sortBy = 'Popularity';
  }
}

// =============================================================================
// REPOSITORY & DATA STORE
// =============================================================================

class GiftCardRepository {
  static final List<Country> countries = const [
    Country(code: 'US', name: 'United States', flag: '🇺🇸'),
    Country(code: 'CA', name: 'Canada', flag: '🇨🇦'),
    Country(code: 'GB', name: 'United Kingdom', flag: '🇬🇧'),
    Country(code: 'EU', name: 'Eurozone', flag: '🇪🇺'),
    Country(code: 'AU', name: 'Australia', flag: '🇦🇺'),
    Country(code: 'DE', name: 'Germany', flag: '🇩🇪'),
  ];

  static List<String> categories = const [
    'All',
    'Popular',
    'Shopping',
    'Gaming',
    'Entertainment',
    'Streaming',
    'Music',
    'Food',
    'Travel',
    'Tech',
    'Finance',
    'Lifestyle',
  ];

  static List<GiftCard> generateMockCards() {
    return [
      GiftCard(
        id: '1',
        name: 'Amazon',
        category: 'Shopping',
        countryCode: 'US',
        buyRate: 98.50,
        sellRate: 94.00,
        logoUrl: 'https://img.icons8.com/color/512/amazon.png',
        primaryColor: const Color(0xFFFF9900),
        isTrending: true,
        isPopular: true,
        processingTime: '⚡ Instant (< 2 mins)',
        denominations: [25, 50, 100, 200, 500],
        description:
            'Instant delivery Amazon USD gift card redeemable for millions of products online.',
      ),
      GiftCard(
        id: '2',
        name: 'Apple & iTunes',
        category: 'Tech',
        countryCode: 'US',
        buyRate: 99.00,
        sellRate: 96.00,
        logoUrl: 'https://img.icons8.com/color/512/apple-logo.png',
        primaryColor: const Color(0xFF555555),
        isTrending: true,
        isPopular: true,
        processingTime: '⚡ Instant',
        denominations: [15, 25, 50, 100],
        description:
            'Use for apps, games, music, movies, iCloud storage, and Apple Store hardware.',
      ),
      GiftCard(
        id: '3',
        name: 'Steam',
        category: 'Gaming',
        countryCode: 'US',
        buyRate: 97.00,
        sellRate: 92.50,
        logoUrl: 'https://img.icons8.com/color/512/steam.png',
        primaryColor: const Color(0xFF171A21),
        isTrending: true,
        isPopular: true,
        processingTime: '⚡ Instant',
        denominations: [20, 50, 100],
        description:
            'Instantly top-up your Steam Wallet for games, software, and in-game items.',
      ),
      GiftCard(
        id: '4',
        name: 'PlayStation Store',
        category: 'Gaming',
        countryCode: 'US',
        buyRate: 96.50,
        sellRate: 91.00,
        logoUrl: 'https://img.icons8.com/color/512/playstation.png',
        primaryColor: const Color(0xFF003791),
        isPopular: true,
        processingTime: '5 mins',
        denominations: [10, 25, 50, 100],
        description:
            'Buy games, add-ons, subscriptions and more on PS4 and PS5 consoles.',
      ),
      GiftCard(
        id: '5',
        name: 'Xbox Network',
        category: 'Gaming',
        countryCode: 'US',
        buyRate: 95.00,
        sellRate: 89.50,
        logoUrl: 'https://img.icons8.com/color/512/xbox.png',
        primaryColor: const Color(0xFF107C41),
        processingTime: '⚡ Instant',
        denominations: [15, 25, 50, 100],
        description:
            'Redeem for latest full Xbox game downloads, apps, and Game Pass Ultimate.',
      ),
      GiftCard(
        id: '6',
        name: 'Razer Gold',
        category: 'Gaming',
        countryCode: 'US',
        buyRate: 98.00,
        sellRate: 95.50,
        logoUrl: 'https://img.icons8.com/color/512/razer.png',
        primaryColor: const Color(0xFF00FF00),
        isTrending: true,
        isNew: true,
        processingTime: '⚡ Instant',
        denominations: [10, 20, 50, 100, 250],
        description:
            'Unified virtual credits for gamers worldwide across thousands of titles.',
      ),
      GiftCard(
        id: '7',
        name: 'Netflix',
        category: 'Streaming',
        countryCode: 'US',
        buyRate: 97.50,
        sellRate: 90.00,
        logoUrl: 'https://img.icons8.com/color/512/netflix.png',
        primaryColor: const Color(0xFFE50914),
        isPopular: true,
        processingTime: '⚡ Instant',
        denominations: [25, 60, 100],
        description:
            'Pay for your monthly subscription or stream instantly without credit cards.',
      ),
      GiftCard(
        id: '8',
        name: 'Nike',
        category: 'Shopping',
        countryCode: 'US',
        buyRate: 94.00,
        sellRate: 88.00,
        logoUrl: 'https://img.icons8.com/color/512/nike.png',
        primaryColor: const Color(0xFF111111),
        processingTime: '10 mins',
        denominations: [25, 50, 100, 250],
        description: 'Valid online and at Nike retail stores nationwide.',
      ),
      GiftCard(
        id: '9',
        name: 'Vanilla Visa Prepaid',
        category: 'Finance',
        countryCode: 'US',
        buyRate: 98.00,
        sellRate: 93.00,
        logoUrl: 'https://img.icons8.com/color/512/visa.png',
        primaryColor: const Color(0xFF1A1F71),
        isTrending: true,
        isPopular: true,
        processingTime: '15 mins',
        denominations: [50, 100, 200, 500],
        description: 'Everywhere Visa debit cards are accepted in the US.',
      ),
      GiftCard(
        id: '10',
        name: 'Uber & Uber Eats',
        category: 'Travel',
        countryCode: 'US',
        buyRate: 96.00,
        sellRate: 89.00,
        logoUrl: 'https://img.icons8.com/color/512/uber.png',
        primaryColor: const Color(0xFF000000),
        processingTime: '⚡ Instant',
        denominations: [15, 25, 50, 100],
        description:
            'Use for ride shares or food delivery from your favorite local restaurants.',
      ),
    ];
  }
}

// =============================================================================
// MAIN MARKETPLACE SCREEN
// =============================================================================

class CardsMarketplaceScreen extends StatefulWidget {
  const CardsMarketplaceScreen({super.key});

  @override
  State<CardsMarketplaceScreen> createState() => _CardsMarketplaceScreenState();
}

class _CardsMarketplaceScreenState extends State<CardsMarketplaceScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _favoriteCardIds = {'1', '3', '6', '9'};
  final List<GiftCard> _recentlyViewedCards = [];

  late List<GiftCard> _allCards;
  MarketplaceFilter _filter = MarketplaceFilter();
  bool _isLoading = false;

  // Carousel State
  final PageController _bannerController = PageController();
  int _currentBannerIndex = 0;
  Timer? _bannerTimer;

  @override
  void initState() {
    super.initState();
    _allCards = GiftCardRepository.generateMockCards();
    _startBannerAutoSlide();
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _startBannerAutoSlide() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_bannerController.hasClients) {
        final nextPage = (_currentBannerIndex + 1) % 4;
        _bannerController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.decelerate,
        );
      }
    });
  }

  Future<void> _handleRefresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    setState(() {
      _allCards = GiftCardRepository.generateMockCards();
      _isLoading = false;
    });
  }

  List<GiftCard> get _filteredCards {
    return _allCards.where((card) {
      // Category filter
      if (_filter.selectedCategory != 'All' &&
          _filter.selectedCategory != 'Popular' &&
          card.category != _filter.selectedCategory) {
        return false;
      }
      if (_filter.selectedCategory == 'Popular' && !card.isPopular) {
        return false;
      }

      // Quick Filters
      if (_filter.quickFilter == '🔥 Trending' && !card.isTrending)
        return false;
      if (_filter.quickFilter == '⭐ Popular' && !card.isPopular) return false;
      if (_filter.quickFilter == '⚡ Instant' &&
          !card.processingTime.contains('Instant'))
        return false;
      if (_filter.quickFilter == '❤️ Favorites' &&
          !_favoriteCardIds.contains(card.id))
        return false;
      if (_filter.quickFilter == '🆕 New' && !card.isNew) return false;

      // Country filter
      if (card.countryCode != _filter.selectedCountryCode) return false;

      // Search Query
      if (_filter.searchQuery.isNotEmpty) {
        final query = _filter.searchQuery.toLowerCase();
        final matchName = card.name.toLowerCase().contains(query);
        final matchCat = card.category.toLowerCase().contains(query);
        if (!matchName && !matchCat) return false;
      }

      // Advanced Options
      if (_filter.favoritesOnly && !_favoriteCardIds.contains(card.id))
        return false;
      if (_filter.instantTradeOnly && !card.processingTime.contains('Instant'))
        return false;

      return true;
    }).toList();
  }

  void _toggleFavorite(String id) {
    setState(() {
      if (_favoriteCardIds.contains(id)) {
        _favoriteCardIds.remove(id);
      } else {
        _favoriteCardIds.add(id);
      }
    });
  }

  void _onCardTap(GiftCard card) {
    setState(() {
      _recentlyViewedCards.removeWhere((element) => element.id == card.id);
      _recentlyViewedCards.insert(0, card);
    });

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (context, anim, secondAnim) => GiftCardDetailsScreen(
          card: card,
          isFavorite: _favoriteCardIds.contains(card.id),
          onFavoriteToggle: () => _toggleFavorite(card.id),
        ),
        transitionsBuilder: (context, anim, secondAnim, child) {
          return FadeTransition(
            opacity: anim,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = _filteredCards;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: NobleTheme.primaryPurple,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1. Premium Animated App Bar
              SliverAppBar(
                floating: true,
                pinned: true,
                elevation: 0,
                expandedHeight: 60.0,
                backgroundColor: isDark
                    ? NobleTheme.backgroundDark
                    : NobleTheme.backgroundLight,
                title: const Text(
                  'Cards',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                actions: [
                  _IconButtonCircle(icon: Boxicons.bx_bell, onTap: () {}),
                  const SizedBox(width: 8),
                  _LiveMarketBadge(),
                  const SizedBox(width: 16),
                ],
              ),

              // 2. Sticky Search Bar & 3. Country Picker Header
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickySearchHeaderDelegate(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    color:
                        (isDark
                                ? NobleTheme.backgroundDark
                                : NobleTheme.backgroundLight)
                            .withOpacity(0.95),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Search Bar
                            Expanded(
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? NobleTheme.cardDark
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(
                                        isDark ? 0.2 : 0.04,
                                      ),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: (val) {
                                    setState(() {
                                      _filter.searchQuery = val;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Search Amazon, Apple, Steam...',
                                    hintStyle: TextStyle(
                                      color: isDark
                                          ? Colors.grey[500]
                                          : Colors.grey[400],
                                      fontSize: 14,
                                    ),
                                    prefixIcon: Icon(
                                      Boxicons.bx_search,
                                      color: isDark
                                          ? Colors.grey[400]
                                          : Colors.grey[600],
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Filter Button
                            GestureDetector(
                              onTap: () => _openAdvancedFilterSheet(context),
                              child: Container(
                                height: 48,
                                width: 48,
                                decoration: BoxDecoration(
                                  gradient: NobleTheme.primaryGradient,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: NobleTheme.primaryPurple
                                          .withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Boxicons.bx_slider_alt,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Country Selector
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 4.0,
                      ),
                      child: GestureDetector(
                        onTap: () => _openCountryPickerModal(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isDark ? NobleTheme.cardDark : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark ? Colors.white10 : Colors.black12,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                GiftCardRepository.countries
                                    .firstWhere(
                                      (c) =>
                                          c.code == _filter.selectedCountryCode,
                                    )
                                    .flag,
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                GiftCardRepository.countries
                                    .firstWhere(
                                      (c) =>
                                          c.code == _filter.selectedCountryCode,
                                    )
                                    .name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Boxicons.bx_chevron_down,
                                size: 16,
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 4. Category Chips
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: GiftCardRepository.categories.length,
                        itemBuilder: (context, index) {
                          final cat = GiftCardRepository.categories[index];
                          final isSelected = _filter.selectedCategory == cat;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _filter.selectedCategory = cat;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  gradient: isSelected
                                      ? NobleTheme.primaryGradient
                                      : null,
                                  color: isSelected
                                      ? null
                                      : (isDark
                                            ? NobleTheme.cardDark
                                            : Colors.white),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: NobleTheme.primaryPurple
                                                .withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    cat,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : (isDark
                                                ? Colors.grey[300]
                                                : Colors.grey[800]),
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 5. Quick Filters
                    SizedBox(
                      height: 36,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children:
                            [
                              'All',
                              '🔥 Trending',
                              '⭐ Popular',
                              '💲 Highest Rate',
                              '⚡ Instant',
                              '❤️ Favorites',
                              '🆕 New',
                            ].map((filterLabel) {
                              final isSelected =
                                  _filter.quickFilter == filterLabel;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  label: Text(
                                    filterLabel,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? Colors.white
                                          : (isDark
                                                ? Colors.grey[300]
                                                : Colors.black87),
                                    ),
                                  ),
                                  selected: isSelected,
                                  onSelected: (val) {
                                    setState(() {
                                      _filter.quickFilter = filterLabel;
                                    });
                                  },
                                  selectedColor: NobleTheme.primaryPurple,
                                  backgroundColor: isDark
                                      ? NobleTheme.cardDark
                                      : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 7. Promotional Banner Slider
                    _buildPromoBannerSlider(isDark),

                    const SizedBox(height: 20),

                    // 8. Featured Cards & 9. Trending
                    _buildHorizontalCardsSection(
                      title: '🔥 Hot Today',
                      cards: _allCards.where((c) => c.isTrending).toList(),
                      isDark: isDark,
                    ),

                    const SizedBox(height: 16),

                    // 10. Highest Rate Cards
                    _buildHighestRatesSection(isDark),

                    const SizedBox(height: 16),

                    // 15. Recently Viewed Section (If any)
                    if (_recentlyViewedCards.isNotEmpty)
                      _buildHorizontalCardsSection(
                        title: 'Recently Viewed',
                        cards: _recentlyViewedCards,
                        isDark: isDark,
                      ),

                    const SizedBox(height: 16),

                    // Section Title for Marketplace Grid
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Marketplace',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${filtered.length} Cards',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 12. Main 2-Column Responsive Marketplace Grid
              if (_isLoading)
                const SliverToBoxAdapter(child: _ShimmerGridLoading())
              else if (filtered.isEmpty)
                SliverToBoxAdapter(child: _buildEmptyState(isDark))
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.72,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final card = filtered[index];
                      final isFav = _favoriteCardIds.contains(card.id);
                      return _buildMarketplaceCardTile(card, isFav, isDark);
                    }, childCount: filtered.length),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // SUB-WIDGETS & SECTIONS
  // ===========================================================================

  Widget _buildPromoBannerSlider(bool isDark) {
    final banners = [
      {
        'title': 'Trade Gift Cards Faster',
        'subtitle': 'Get instant payouts in USD directly to your wallet',
        'badge': 'INSTANT PAYOUT',
        'colors': [const Color(0xFF6E0DD0), const Color(0xFF3B82F6)],
      },
      {
        'title': 'Highest Rates Guaranteed',
        'subtitle': 'Up to 99% payout on Apple and Amazon cards today',
        'badge': 'BEST RATES',
        'colors': [const Color(0xFF059669), const Color(0xFF10B981)],
      },
      {
        'title': 'Global Marketplace',
        'subtitle': 'Supporting US, UK, Canada, and EU regional cards',
        'badge': 'MULTI-CURRENCY',
        'colors': [const Color(0xFFD97706), const Color(0xFFF59E0B)],
      },
      {
        'title': 'Zero Service Fees',
        'subtitle': 'First 3 trades this week come with 0% platform charges',
        'badge': 'PROMOTION',
        'colors': [const Color(0xFFEC4899), const Color(0xFF8B5CF6)],
      },
    ];

    return Column(
      children: [
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: _bannerController,
            onPageChanged: (idx) => setState(() => _currentBannerIndex = idx),
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final item = banners[index];
              final gradientColors = item['colors'] as List<Color>;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: gradientColors[0].withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item['badge'].toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'].toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item['subtitle'].toString(),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 6,
              width: _currentBannerIndex == index ? 18 : 6,
              decoration: BoxDecoration(
                color: _currentBannerIndex == index
                    ? NobleTheme.primaryPurple
                    : (isDark ? Colors.white24 : Colors.black12),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalCardsSection({
    required String title,
    required List<GiftCard> cards,
    required bool isDark,
  }) {
    if (cards.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: cards.length,
            itemBuilder: (context, index) {
              final card = cards[index];
              return Container(
                width: 140,
                margin: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => _onCardTap(card),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? NobleTheme.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: card.primaryColor.withOpacity(
                                0.15,
                              ),
                              child: Icon(
                                Boxicons.bx_gift,
                                color: card.primaryColor,
                                size: 20,
                              ),
                            ),
                            Text(
                              '${card.sellRate.toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: NobleTheme.successGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              card.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Buy \$${card.buyRate.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHighestRatesSection(bool isDark) {
    final highestRates = List<GiftCard>.from(_allCards)
      ..sort((a, b) => b.sellRate.compareTo(a.sellRate));
    final topThree = highestRates.take(3).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? NobleTheme.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: NobleTheme.primaryPurple.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '💲 Highest Rates Today',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'Live Rates',
                style: TextStyle(
                  fontSize: 11,
                  color: NobleTheme.successGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          ...topThree.map(
            (card) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: card.primaryColor.withOpacity(0.2),
                    child: Icon(
                      Boxicons.bx_check_shield,
                      size: 14,
                      color: card.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      card.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Sell Rate: ${card.sellRate.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          color: NobleTheme.successGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Buy: \$${card.buyRate.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketplaceCardTile(GiftCard card, bool isFav, bool isDark) {
    return GestureDetector(
      onTap: () => _onCardTap(card),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? NobleTheme.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.25 : 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Header Row: Badge & Heart
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: NobleTheme.successGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Available',
                    style: TextStyle(
                      color: NobleTheme.successGreen,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _toggleFavorite(card.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isFav
                          ? Colors.red.withOpacity(0.1)
                          : (isDark ? Colors.white10 : Colors.grey[100]),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFav ? Boxicons.bxs_heart : Boxicons.bx_heart,
                      size: 16,
                      color: isFav ? Colors.red : Colors.grey[400],
                    ),
                  ),
                ),
              ],
            ),

            // Card Brand Logo Placeholder
            Center(
              child: Hero(
                tag: 'card_logo_${card.id}',
                child: CircleAvatar(
                  radius: 26,
                  backgroundColor: card.primaryColor.withOpacity(0.15),
                  child: Icon(
                    Boxicons.bx_credit_card_front,
                    color: card.primaryColor,
                    size: 28,
                  ),
                ),
              ),
            ),

            // Info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  card.category,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),

                // Rates USD
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BUY',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.grey[500] : Colors.grey[600],
                          ),
                        ),
                        Text(
                          '\$${card.buyRate.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'SELL',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.grey[500] : Colors.grey[600],
                          ),
                        ),
                        Text(
                          '\$${card.sellRate.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: NobleTheme.successGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            // Action Button
            SizedBox(
              width: double.infinity,
              height: 32,
              child: ElevatedButton(
                onPressed: () => _onCardTap(card),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: NobleTheme.primaryPurple,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Trade Now',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Boxicons.bx_search_alt,
            size: 64,
            color: isDark ? Colors.grey[600] : Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'No Gift Cards Found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'We couldn\'t find any cards matching your filter criteria. Try resetting filters.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _filter.reset();
                _searchController.clear();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: NobleTheme.primaryPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Reset All Filters',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Modals & Bottom Sheets
  void _openCountryPickerModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Select Region',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: GiftCardRepository.countries.length,
                itemBuilder: (ctx, idx) {
                  final country = GiftCardRepository.countries[idx];
                  return ListTile(
                    leading: Text(
                      country.flag,
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(country.name),
                    trailing: _filter.selectedCountryCode == country.code
                        ? const Icon(
                            Boxicons.bx_check,
                            color: NobleTheme.primaryPurple,
                          )
                        : null,
                    onTap: () {
                      setState(
                        () => _filter.selectedCountryCode = country.code,
                      );
                      Navigator.pop(ctx);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openAdvancedFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter Gift Cards',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setModalState(() => _filter.reset());
                          setState(() {});
                        },
                        child: const Text(
                          'Reset',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),

                  // Fast Toggles
                  SwitchListTile(
                    title: const Text('Instant Trade Cards Only'),
                    value: _filter.instantTradeOnly,
                    activeColor: NobleTheme.primaryPurple,
                    onChanged: (val) {
                      setModalState(() => _filter.instantTradeOnly = val);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Favorites Only'),
                    value: _filter.favoritesOnly,
                    activeColor: NobleTheme.primaryPurple,
                    onChanged: (val) {
                      setModalState(() => _filter.favoritesOnly = val);
                    },
                  ),

                  const SizedBox(height: 12),
                  const Text(
                    'Sort By',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 8,
                    children:
                        [
                          'Popularity',
                          'Highest Rate',
                          'Lowest Rate',
                          'A-Z',
                          'Newest',
                        ].map((sort) {
                          final isSelected = _filter.sortBy == sort;
                          return ChoiceChip(
                            label: Text(sort),
                            selected: isSelected,
                            selectedColor: NobleTheme.primaryPurple,
                            onSelected: (selected) {
                              if (selected) {
                                setModalState(() => _filter.sortBy = sort);
                              }
                            },
                          );
                        }).toList(),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {});
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NobleTheme.primaryPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Apply Filters',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// =============================================================================
// GIFT CARD DETAILS PAGE
// =============================================================================

class GiftCardDetailsScreen extends StatelessWidget {
  final GiftCard card;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const GiftCardDetailsScreen({
    super.key,
    required this.card,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Boxicons.bx_arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Boxicons.bxs_heart : Boxicons.bx_heart,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: onFavoriteToggle,
          ),
          IconButton(icon: const Icon(Boxicons.bx_share_alt), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Hero Header
            Center(
              child: Column(
                children: [
                  Hero(
                    tag: 'card_logo_${card.id}',
                    child: CircleAvatar(
                      radius: 44,
                      backgroundColor: card.primaryColor.withOpacity(0.2),
                      child: Icon(
                        Boxicons.bx_credit_card,
                        size: 48,
                        color: card.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    card.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${card.countryCode} Region • ${card.category}',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Exchange Rates Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? NobleTheme.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildRateDetailColumn(
                    'Buy Rate',
                    '\$${card.buyRate.toStringAsFixed(2)}',
                    Colors.blue,
                  ),
                  Container(height: 30, width: 1, color: Colors.grey[300]),
                  _buildRateDetailColumn(
                    'Sell Rate',
                    '\$${card.sellRate.toStringAsFixed(2)}',
                    NobleTheme.successGreen,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Card Specs
            const Text(
              'Card Specifications',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            _buildSpecTile(
              Boxicons.bx_time_five,
              'Speed',
              card.processingTime,
              isDark,
            ),
            _buildSpecTile(
              Boxicons.bx_dollar_circle,
              'Limits',
              '\$${card.minAmount.toInt()} - \$${card.maxAmount.toInt()} USD',
              isDark,
            ),
            _buildSpecTile(
              Boxicons.bx_check_circle,
              'Status',
              card.isAvailable ? 'Available Now' : 'Out of Stock',
              isDark,
            ),

            const SizedBox(height: 16),

            const Text(
              'Accepted Denominations',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              children: card.denominations.map((denom) {
                return Chip(
                  label: Text('\$$denom'),
                  backgroundColor: isDark
                      ? NobleTheme.cardDark
                      : Colors.grey[200],
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            const Text(
              'Description',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              card.description,
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[700],
                height: 1.4,
              ),
            ),

            const SizedBox(height: 32),

            // Buy & Sell Buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: NobleTheme.primaryPurple,
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Buy Card',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NobleTheme.primaryPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Sell Card',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRateDetailColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildSpecTile(
    IconData icon,
    String title,
    String value,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: NobleTheme.primaryPurple),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// =============================================================================
// HELPER WIDGETS
// =============================================================================

class _IconButtonCircle extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconButtonCircle({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: isDark ? NobleTheme.cardDark : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
          ],
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }
}

class _LiveMarketBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: NobleTheme.successGreen.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          CircleAvatar(radius: 3, backgroundColor: NobleTheme.successGreen),
          SizedBox(width: 6),
          Text(
            'Market Open',
            style: TextStyle(
              color: NobleTheme.successGreen,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerGridLoading extends StatelessWidget {
  const _ShimmerGridLoading();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: 4,
      itemBuilder: (ctx, idx) => Container(
        decoration: BoxDecoration(
          color: isDark ? NobleTheme.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

class _StickySearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickySearchHeaderDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => 64.0;

  @override
  double get minExtent => 64.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
