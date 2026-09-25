import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import 'models/mock_gift_card.dart';
import 'widgets/gift_card_hero_banner.dart';
import 'widgets/gift_card_search_bar.dart';
import 'widgets/gift_card_category_chips.dart';
import 'widgets/gift_card_product_card.dart';
import 'widgets/gift_card_catalog_empty_state.dart';

class BuyGiftCardsCatalogScreen extends StatefulWidget {
  const BuyGiftCardsCatalogScreen({Key? key}) : super(key: key);

  @override
  State<BuyGiftCardsCatalogScreen> createState() => _BuyGiftCardsCatalogScreenState();
}

class _BuyGiftCardsCatalogScreenState extends State<BuyGiftCardsCatalogScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  List<MockGiftCard> _filteredCards = [];
  final List<String> _categories = ['All', 'Gaming', 'Shopping', 'Entertainment', 'Dining'];

  @override
  void initState() {
    super.initState();
    _filterCards();
  }

  void _filterCards() {
    setState(() {
      _filteredCards = mockGiftCards.where((card) {
        final matchesBuy = card.isBuy;
        final matchesSearch = card.brand.toLowerCase().contains(_searchController.text.toLowerCase());
        final matchesCategory = _selectedCategory == 'All' || card.category == _selectedCategory;
        return matchesBuy && matchesSearch && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Buy Gift Cards', style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Choose from thousands of gift cards worldwide', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkSubText : AppColors.lightSubText, fontWeight: FontWeight.normal)),
          ],
        ),
        leading: IconButton(
          icon: Icon(Boxicons.bx_chevron_left, color: isDark ? AppColors.darkText : AppColors.lightText),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Boxicons.bx_gift), color: AppColors.primary, onPressed: () {}),
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
                    title: 'Global Brands.\nInstant Access.',
                    subtitle: 'Get your favourite gift cards at the best rates, always.',
                    ctaText: 'Explore Now',
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
                      Text('Popular Gift Cards', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkText : AppColors.lightText)),
                      Text('View All →', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
          if (_filteredCards.isEmpty)
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
                    return GiftCardProductCard(
                      card: _filteredCards[index],
                      isSellMode: false,
                      isDark: isDark,
                      onTap: () {
                        // Pass mock data directly into the existing unmodified buy_card_screen.dart
                        // Navigator.pushNamed(context, '/buy_card_screen', arguments: _filteredCards[index]);
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