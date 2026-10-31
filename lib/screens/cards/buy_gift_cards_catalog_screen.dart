import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'models/gift_card_model.dart';
import 'services/cards_service.dart';
import 'buy_card_screen.dart';
import '../referral/referral_screen.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import 'widgets/gift_card_hero_banner.dart';
import 'widgets/gift_card_search_bar.dart';
import 'widgets/gift_card_category_chips.dart';
import 'widgets/gift_card_product_card.dart';
import 'widgets/gift_card_catalog_empty_state.dart';
import 'widgets/gift_card_catalog_shimmer.dart';
import 'widgets/network_error_widget.dart';
import 'widgets/gift_card_filter_bottom_sheet.dart';
import '../../localization/app_localizations.dart';

class BuyGiftCardsCatalogScreen extends StatefulWidget {
  const BuyGiftCardsCatalogScreen({Key? key}) : super(key: key);

  @override
  State<BuyGiftCardsCatalogScreen> createState() =>
      _BuyGiftCardsCatalogScreenState();
}

class _BuyGiftCardsCatalogScreenState extends State<BuyGiftCardsCatalogScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  GiftCardFilterOptions _filterOptions = const GiftCardFilterOptions();
  List<GiftCardModel> _cards = [];
  List<GiftCardModel> _filteredCards = [];
  bool _isLoading = true;
  bool _hasError = false;

  final List<String> _categories = [
    'All',
    'Gaming',
    'Shopping',
    'Entertainment',
    'Dining',
  ];

  @override
  void initState() {
    super.initState();
    // Instant Load from in-memory cache if available
    if (CardsService.hasCachedCatalog) {
      _cards = CardsService.getCachedCatalog();
      _filteredCards = _filterCardsFrom(_cards);
      _isLoading = false;
      _loadCards(silent: true);
    } else {
      _loadCards(silent: false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCards({bool silent = false}) async {
    if (!silent && mounted) {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });
    }
    try {
      final cards = await CardsService().fetchCards(forceRefresh: true);
      if (!mounted) return;
      final filteredCards = _filterCardsFrom(cards);
      setState(() {
        _cards = cards;
        _filteredCards = filteredCards;
        _isLoading = false;
        _hasError = false;
      });
    } catch (_) {
      if (mounted && !silent && _cards.isEmpty) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _filteredCards = [];
        });
      }
    }
  }

  void _filterCards() {
    setState(() {
      _filteredCards = _filterCardsFrom(_cards);
    });
  }

  bool _matchesCategory(
    String cardCategory,
    String cardName,
    String selectedCategory,
  ) {
    if (selectedCategory == 'All') return true;
    final c = cardCategory.toLowerCase();
    final n = cardName.toLowerCase();
    switch (selectedCategory) {
      case 'Gaming':
        return c.contains('game') ||
            c.contains('gaming') ||
            c.contains('play') ||
            n.contains('xbox') ||
            n.contains('playstation') ||
            n.contains('steam') ||
            n.contains('nintendo') ||
            n.contains('roblox') ||
            n.contains('razer') ||
            n.contains('blizzard') ||
            n.contains('riot');
      case 'Shopping':
        return c.contains('shop') ||
            c.contains('retail') ||
            c.contains('ecommerce') ||
            c.contains('store') ||
            n.contains('amazon') ||
            n.contains('ebay') ||
            n.contains('walmart') ||
            n.contains('target') ||
            n.contains('apple') ||
            n.contains('ikea') ||
            n.contains('nike') ||
            n.contains('adidas') ||
            n.contains('zara') ||
            n.contains('shein') ||
            n.contains('flixtrain') ||
            n.contains('flixbus');
      case 'Entertainment':
        return c.contains('entertain') ||
            c.contains('stream') ||
            c.contains('music') ||
            c.contains('movie') ||
            n.contains('netflix') ||
            n.contains('spotify') ||
            n.contains('hulu') ||
            n.contains('disney') ||
            n.contains('youtube') ||
            n.contains('cinema') ||
            n.contains('itunes') ||
            n.contains('google play');
      case 'Dining':
        return c.contains('din') ||
            c.contains('food') ||
            c.contains('restaurant') ||
            c.contains('cafe') ||
            n.contains('uber eats') ||
            n.contains('doordash') ||
            n.contains('starbucks') ||
            n.contains('domino') ||
            n.contains('mcdonald') ||
            n.contains('subway') ||
            n.contains('burger');
      default:
        return c.contains(selectedCategory.toLowerCase());
    }
  }

  List<GiftCardModel> _filterCardsFrom(List<GiftCardModel> cards) {
    final search = _searchController.text.trim().toLowerCase();
    var result = cards.where((card) {
      final matchesSearch = search.isEmpty ||
          card.name.toLowerCase().contains(search) ||
          card.country.toLowerCase().contains(search) ||
          card.category.toLowerCase().contains(search) ||
          card.supportedRegions.any((r) =>
              r.countryName.toLowerCase().contains(search) ||
              r.countryCode.toLowerCase().contains(search));

      final matchesCategory =
          _matchesCategory(card.category, card.name, _selectedCategory);

      final matchesCountry = _filterOptions.country == 'All' ||
          card.countryCode == _filterOptions.country ||
          card.supportedRegions.any(
              (r) => r.countryCode.toUpperCase() == _filterOptions.country);

      return matchesSearch && matchesCategory && matchesCountry;
    }).toList();

    // Sorting
    switch (_filterOptions.sortBy) {
      case 'Lowest Rate':
        result.sort((a, b) => a.buyRate.compareTo(b.buyRate));
        break;
      case 'Highest Rate':
        result.sort((a, b) => b.buyRate.compareTo(a.buyRate));
        break;
      case 'Name (A - Z)':
        result.sort((a, b) => a.name.compareTo(b.name));
        break;
      default:
        break;
    }

    return result;
  }

  void _openFilterBottomSheet() {
    GiftCardFilterBottomSheet.show(
      context,
      currentFilters: _filterOptions,
      onApply: (newFilters) {
        setState(() {
          _filterOptions = newFilters;
          _selectedCategory = newFilters.category;
          _filterCards();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr('buy_gift_cards', fallback: 'Buy Gift Cards'),
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Choose from thousands of gift cards worldwide',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(
            Boxicons.bx_chevron_left,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Referral Program Icon Button
          IconButton(
            icon: const Icon(Boxicons.bx_gift),
            color: AppColors.primary,
            tooltip: 'Referral Rewards',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReferralScreen()),
              );
            },
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  GiftCardHeroBanner(
                    title: 'Global Brands.\nInstant Access.',
                    subtitle:
                        'Get your favourite gift cards at the best rates, always.',
                    ctaText: 'Explore Now',
                    onCtaPressed: () {},
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  GiftCardSearchBar(
                    controller: _searchController,
                    onChanged: (val) => _filterCards(),
                    onFilterTap: _openFilterBottomSheet,
                    isDark: isDark,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  GiftCardCategoryChips(
                    categories: _categories,
                    selectedCategory: _selectedCategory,
                    onCategorySelected: (cat) {
                      _selectedCategory = cat;
                      _filterOptions = _filterOptions.copyWith(category: cat);
                      _filterCards();
                    },
                    isDark: isDark,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.tr('popular_gift_cards'),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.darkText
                              : AppColors.lightText,
                        ),
                      ),
                      Text(
                        '${_filteredCards.length} Cards',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
          if (_isLoading)
            SliverFillRemaining(
              hasScrollBody: false,
              child: GiftCardCatalogShimmer(isDark: isDark),
            )
          else if (_hasError)
            SliverFillRemaining(
              hasScrollBody: false,
              child: NetworkErrorWidget(onRetry: () => _loadCards(silent: false)),
            )
          else if (_filteredCards.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: GiftCardCatalogEmptyState(
                isDark: isDark,
                onReset: () {
                  _searchController.clear();
                  _selectedCategory = 'All';
                  _filterOptions = const GiftCardFilterOptions();
                  _filterCards();
                },
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.82,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final card = _filteredCards[index];
                    return GiftCardProductCard(
                      key: ValueKey(card.id),
                      card: card,
                      isSellMode: false,
                      isDark: isDark,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BuyCardScreen(card: card),
                          ),
                        );
                      },
                    );
                  },
                  childCount: _filteredCards.length,
                ),
              ),
            ),
          const SliverPadding(padding: EdgeInsets.only(bottom: AppSpacing.xl)),
        ],
      ),
    );
  }
}
