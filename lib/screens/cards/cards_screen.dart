import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

import 'models/gift_card_model.dart';
import 'providers/cards_provider.dart';
import 'providers/country_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/filter_provider.dart';
import 'providers/search_provider.dart';

import 'widgets/animated_search_bar.dart';
import 'widgets/category_chip_list.dart';
import 'widgets/country_bottom_sheet.dart';
import 'widgets/country_selector.dart';
import 'widgets/empty_market_widget.dart';
import 'widgets/filter_bottom_sheet.dart';
import 'widgets/floating_snackbar.dart';
import 'widgets/hot_today_list.dart';
import 'widgets/live_market_marquee.dart';
import 'widgets/marketplace_grid.dart';
import 'widgets/marketplace_header.dart';
import 'widgets/network_error_widget.dart';
import 'widgets/promo_carousel.dart';
import 'widgets/quick_filter_chip_list.dart';
import 'widgets/recently_viewed_list.dart';
import 'widgets/cards_app_bar.dart';
import 'widgets/section_header.dart';
import 'widgets/shimmer_marketplace.dart';
import 'widgets/top_rates_card.dart';
import 'sell_gift_card_screen.dart';

class CardsScreen extends StatelessWidget {
  const CardsScreen({super.key});

  void _onBuyTap(BuildContext context, GiftCardModel card) {
    showFloatingSnackbar(context, 'Buy Screen Placeholder for ${card.name}');
  }

  void _onSellTap(BuildContext context, GiftCardModel card) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SellGiftCardScreen(card: card),
      ),
    );
  }

  void _onCardDetailsTap(BuildContext context, GiftCardModel card) {
    context.read<CardsProvider>().addRecentlyViewed(card);
    showFloatingSnackbar(context, 'Details Screen Placeholder for ${card.name}');
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CardsProvider()),
        ChangeNotifierProvider(create: (_) => CountryProvider()),
        ChangeNotifierProvider(create: (_) => FilterProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: Builder(
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final cardsProvider = context.watch<CardsProvider>();
          final filterProvider = context.watch<FilterProvider>();
          final searchProvider = context.watch<SearchProvider>();
          final countryProvider = context.watch<CountryProvider>();
          final favProvider = context.watch<FavoritesProvider>();

          // Dynamic Client Side Filtering Logic
          List<GiftCardModel> filteredCards = cardsProvider.allCards.where((card) {
            // 1. Search filter
            final q = searchProvider.query.toLowerCase();
            if (q.isNotEmpty) {
              final matches = card.name.toLowerCase().contains(q) ||
                  card.category.toLowerCase().contains(q) ||
                  card.country.toLowerCase().contains(q);
              if (!matches) return false;
            }

            // 2. Category filter
            if (filterProvider.selectedCategory != 'All' &&
                card.category != filterProvider.selectedCategory) {
              return false;
            }

            // 3. Country filter
            if (countryProvider.selectedCountry.id != 'all' &&
                !card.country.toLowerCase().contains(
                    countryProvider.selectedCountry.name.toLowerCase())) {
              return false;
            }

            // 4. Quick filter
            final qf = filterProvider.selectedQuickFilter;
            if (qf == 'Trending' && !card.isTrending) return false;
            if (qf == 'Instant Delivery' && !card.isInstant) return false;
            if (qf == 'Available' && !card.isAvailable) return false;
            if (qf == 'Favorites' && !favProvider.isFavorite(card.id)) return false;

            return true;
          }).toList();

          if (filterProvider.selectedQuickFilter == 'Highest Rate') {
            filteredCards.sort((a, b) => b.sellRate.compareTo(a.sellRate));
          }

          return Scaffold(
            backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
            appBar: const CardsAppBar(),
            body: RefreshIndicator(
              color: AppColors.accentViolet,
              onRefresh: () async {
                await cardsProvider.fetchCards();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.sm),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
                      child: AnimatedSearchBar(
                        onFilterTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (sheetContext) => ChangeNotifierProvider.value(
                              value: context.read<FilterProvider>(),
                              child: const FilterBottomSheet(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
                      child: CountrySelector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (sheetContext) => ChangeNotifierProvider.value(
                              value: context.read<CountryProvider>(),
                              child: const CountryBottomSheet(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    const CategoryChipList(),
                    const SizedBox(height: 12),
                    const QuickFilterChipList(),
                    const SizedBox(height: 20),
                    const PromoCarousel(),
                    const SizedBox(height: 20),
                    const LiveMarketMarquee(),
                    const SizedBox(height: 24),
                    SectionHeader(
                      title: 'Hot Today 🔥',
                      onViewAll: () {},
                    ),
                    const SizedBox(height: 12),
                    HotTodayList(
                      cards: cardsProvider.allCards.where((c) => c.isTrending).toList(),
                      onCardTap: (card) => _onCardDetailsTap(context, card),
                    ),
                    const SizedBox(height: 24),
                    SectionHeader(
                      title: 'Top Rates Today',
                      subtitle: '• Live',
                      onViewAll: () {},
                    ),
                    const SizedBox(height: 12),
                    TopRatesCard(cards: cardsProvider.allCards),
                    const SizedBox(height: 24),
                    if (cardsProvider.recentlyViewed.isNotEmpty) ...[
                      SectionHeader(
                        title: 'Recently Viewed',
                        onViewAll: () {},
                      ),
                      const SizedBox(height: 12),
                      RecentlyViewedList(
                        cards: cardsProvider.recentlyViewed,
                        onTap: (card) => _onCardDetailsTap(context, card),
                      ),
                      const SizedBox(height: 24),
                    ],
                    MarketplaceHeader(count: filteredCards.length),
                    const SizedBox(height: 16),
                    if (cardsProvider.state == CardsState.loading)
                      const ShimmerMarketplace()
                    else if (cardsProvider.state == CardsState.error)
                      NetworkErrorWidget(onRetry: cardsProvider.fetchCards)
                    else if (filteredCards.isEmpty)
                      const EmptyMarketWidget()
                    else
                      MarketplaceGrid(
                        cards: filteredCards,
                        onCardTap: (card) => _onCardDetailsTap(context, card),
                        onBuyTap: (card) => _onBuyTap(context, card),
                        onSellTap: (card) => _onSellTap(context, card),
                      ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

