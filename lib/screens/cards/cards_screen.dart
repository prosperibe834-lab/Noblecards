import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

import 'buy_card_screen.dart';
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BuyCardScreen(card: card)),
    );
  }

  void _onSellTap(BuildContext context, GiftCardModel card) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SellGiftCardScreen(card: card)),
    );
  }

  void _onCardDetailsTap(BuildContext context, GiftCardModel card) {
    context.read<CardsProvider>().addRecentlyViewed(card);
    showFloatingSnackbar(
      context,
      'Details Screen Placeholder for ${card.name}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CardsProvider(initialCountryCode: 'US'),
        ),
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
          List<GiftCardModel> filteredCards = cardsProvider.allCards.where((
            card,
          ) {
            // 1. Search filter
            final q = searchProvider.query.toLowerCase();
            if (q.isNotEmpty) {
              final matches =
                  card.name.toLowerCase().contains(q) ||
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
                  countryProvider.selectedCountry.name.toLowerCase(),
                )) {
              return false;
            }

            // 4. Quick filter
            final qf = filterProvider.selectedQuickFilter;
            if (qf == 'Trending' && !card.isTrending) return false;
            if (qf == 'Instant Delivery' && !card.isInstant) return false;
            if (qf == 'Available' && !card.isAvailable) return false;
            if (qf == 'Favorites' && !favProvider.isFavorite(card.id))
              return false;

            return true;
          }).toList();

          if (filterProvider.selectedQuickFilter == 'Highest Rate') {
            filteredCards.sort((a, b) => b.sellRate.compareTo(a.sellRate));
          }

          Widget section(Widget child) => SliverToBoxAdapter(child: child);

          String? catalogCountryCode(String code) {
            if (code == 'ALL') return null;
            return code == 'UK' ? 'GB' : code;
          }

          return Scaffold(
            backgroundColor: isDark
                ? AppColors.darkBackground
                : AppColors.lightBackground,
            appBar: const CardsAppBar(),
            body: RefreshIndicator(
              color: AppColors.accentViolet,
              onRefresh: () async {
                await cardsProvider.fetchCards(
                  countryCode: catalogCountryCode(
                    countryProvider.selectedCountry.code,
                  ),
                  forceRefresh: true,
                );
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  section(const SizedBox(height: AppSpacing.sm)),
                  section(
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.m,
                      ),
                      child: AnimatedSearchBar(
                        onFilterTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (sheetContext) =>
                                ChangeNotifierProvider.value(
                                  value: context.read<FilterProvider>(),
                                  child: const FilterBottomSheet(),
                                ),
                          );
                        },
                      ),
                    ),
                  ),
                  section(const SizedBox(height: 12)),
                  section(
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.m,
                      ),
                      child: CountrySelector(
                        onTap: () async {
                          final selected = await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (sheetContext) =>
                                ChangeNotifierProvider.value(
                                  value: context.read<CountryProvider>(),
                                  child: const CountryBottomSheet(),
                                ),
                          );
                          if (!context.mounted || selected == null) return;
                          await cardsProvider.fetchCards(
                            countryCode: catalogCountryCode(selected.code),
                          );
                        },
                      ),
                    ),
                  ),
                  section(const SizedBox(height: 16)),
                  section(const CategoryChipList()),
                  section(const SizedBox(height: 12)),
                  section(const QuickFilterChipList()),
                  section(const SizedBox(height: 20)),
                  section(const PromoCarousel()),
                  section(const SizedBox(height: 20)),
                  section(const LiveMarketMarquee()),
                  section(const SizedBox(height: 24)),
                  section(
                    SectionHeader(title: 'Hot Today 🔥', onViewAll: () {}),
                  ),
                  section(const SizedBox(height: 12)),
                  section(
                    HotTodayList(
                      cards: cardsProvider.allCards
                          .where((c) => c.isTrending)
                          .toList(),
                      onCardTap: (card) => _onCardDetailsTap(context, card),
                    ),
                  ),
                  section(const SizedBox(height: 24)),
                  section(
                    SectionHeader(
                      title: 'Top Rates Today',
                      subtitle: '• Live',
                      onViewAll: () {},
                    ),
                  ),
                  section(const SizedBox(height: 12)),
                  section(TopRatesCard(cards: cardsProvider.allCards)),
                  section(const SizedBox(height: 24)),
                  if (cardsProvider.recentlyViewed.isNotEmpty) ...[
                    section(
                      SectionHeader(title: 'Recently Viewed', onViewAll: () {}),
                    ),
                    section(const SizedBox(height: 12)),
                    section(
                      RecentlyViewedList(
                        cards: cardsProvider.recentlyViewed,
                        onTap: (card) => _onCardDetailsTap(context, card),
                      ),
                    ),
                    section(const SizedBox(height: 24)),
                  ],
                  section(MarketplaceHeader(count: filteredCards.length)),
                  section(const SizedBox(height: 16)),
                  if (cardsProvider.state == CardsState.loading)
                    section(const ShimmerMarketplace())
                  else if (cardsProvider.state == CardsState.error)
                    section(
                      NetworkErrorWidget(onRetry: cardsProvider.fetchCards),
                    )
                  else if (filteredCards.isEmpty)
                    section(const EmptyMarketWidget())
                  else
                    MarketplaceGrid(
                      cards: filteredCards,
                      onCardTap: (card) => _onCardDetailsTap(context, card),
                      onBuyTap: (card) => _onBuyTap(context, card),
                      onSellTap: (card) => _onSellTap(context, card),
                    ),
                  section(const SizedBox(height: 40)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
