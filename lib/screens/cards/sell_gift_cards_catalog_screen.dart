import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'models/gift_card_model.dart';
import 'services/gift_card_sell_service.dart';
import 'sell_gift_card_screen.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import 'widgets/gift_card_hero_banner.dart';
import 'widgets/gift_card_search_bar.dart';
import 'widgets/gift_card_category_chips.dart';
import 'widgets/gift_card_product_card.dart';
import 'widgets/gift_card_catalog_empty_state.dart';
import 'widgets/gift_card_catalog_shimmer.dart';
import 'widgets/network_error_widget.dart';

class SellGiftCardsCatalogScreen extends StatefulWidget {
  const SellGiftCardsCatalogScreen({Key? key}) : super(key: key);

  @override
  State<SellGiftCardsCatalogScreen> createState() =>
      _SellGiftCardsCatalogScreenState();
}

class _SellGiftCardsCatalogScreenState
    extends State<SellGiftCardsCatalogScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  List<GiftCardModel> _cards = [];
  List<GiftCardModel> _filteredCards = [];
  bool _isLoading = true;
  bool _hasError = false;
  final GiftCardSellService _service = GiftCardSellService();
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
    _loadCards();
  }

  Future<void> _loadCards() async {
    if (mounted && (!_isLoading || _hasError)) {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });
    }
    try {
      final cards = await _service.getCatalogCards();
      if (!mounted) return;
      final filteredCards = _filterCardsFrom(cards);
      setState(() {
        _cards = cards;
        _filteredCards = filteredCards;
        _isLoading = false;
        _hasError = false;
      });
    } catch (_) {
      if (mounted) {
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

  List<GiftCardModel> _filterCardsFrom(List<GiftCardModel> cards) {
    final search = _searchController.text.toLowerCase();
    return cards.where((card) {
      final matchesSearch = card.name.toLowerCase().contains(search);
      final matchesCategory =
          _selectedCategory == 'All' || card.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sell Gift Cards',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Turn your gift cards into cash',
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
          IconButton(
            icon: const Icon(Boxicons.bx_gift),
            color: AppColors.success,
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  GiftCardHeroBanner(
                    title: 'Sell Your\nGift Cards Today.',
                    subtitle:
                        'Get competitive rates and instant payment for your unused gift cards.',
                    ctaText: 'Start Selling Now',
                    onCtaPressed: () {},
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  GiftCardSearchBar(
                    controller: _searchController,
                    onChanged: (val) => _filterCards(),
                    onFilterTap: () {},
                    isDark: isDark,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  GiftCardCategoryChips(
                    categories: _categories,
                    selectedCategory: _selectedCategory,
                    onCategorySelected: (cat) {
                      _selectedCategory = cat;
                      _filterCards();
                    },
                    isDark: isDark,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Popular Gift Cards',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.darkText
                              : AppColors.lightText,
                        ),
                      ),
                      Text(
                        'View All →',
                        style: TextStyle(
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
              child: NetworkErrorWidget(onRetry: _loadCards),
            )
          else if (_filteredCards.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: GiftCardCatalogEmptyState(
                isDark: isDark,
                onReset: () {
                  _searchController.clear();
                  _selectedCategory = 'All';
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
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final card = _filteredCards[index];
                    return GiftCardProductCard(
                      key: ValueKey(card.catalogKey),
                      card: card,
                      isSellMode: true,
                      isDark: isDark,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SellGiftCardScreen(card: card),
                          ),
                        );
                      },
                    );
                  },
                  childCount: _filteredCards.length,
                  findChildIndexCallback: (key) {
                    if (key is ValueKey<String>) {
                      final index = _filteredCards.indexWhere(
                        (card) => card.catalogKey == key.value,
                      );
                      return index == -1 ? null : index;
                    }
                    return null;
                  },
                ),
              ),
            ),
          const SliverPadding(padding: EdgeInsets.only(bottom: AppSpacing.xl)),
        ],
      ),
    );
  }
}
