import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

import 'widgets/cards_hero_carousel.dart';
import 'widgets/cards_action_cards.dart';
import 'widgets/live_market_section.dart';
import 'widgets/hot_today_section.dart';
import 'widgets/top_rates_section.dart';
import 'widgets/recently_viewed_section.dart';
import 'widgets/why_noblecards_section.dart';
import 'widgets/cards_screen_shimmer.dart';
import 'widgets/cards_screen_error.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({Key? key}) : super(key: key);

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  bool _isLoading = false; // Set to true to test Shimmer
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchCardsData();
  }

  Future<void> _fetchCardsData() async {
    // Simulated fetch to demonstrate shimmer and error states if needed
    // In actual implementation, listen to your providers here.
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // Uses existing app shell; no bottom navigation bar added here.
      body: SafeArea(
        child: _isLoading
            ? const CardsScreenShimmer()
            : _hasError
                ? CardsScreenError(onRetry: () {
                    setState(() {
                      _hasError = false;
                      _isLoading = true;
                    });
                    _fetchCardsData();
                  })
                : CustomScrollView(
                    slivers: [
                      _buildHeader(isDark),
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: AppSpacing.md),
                            const CardsHeroCarousel(),
                            const SizedBox(height: AppSpacing.md),
                            const CardsActionCards(),
                            const SizedBox(height: AppSpacing.lg),
                            const LiveMarketSection(),
                            const SizedBox(height: AppSpacing.lg),
                            const HotTodaySection(),
                            const SizedBox(height: AppSpacing.lg),
                            const TopRatesSection(),
                            const SizedBox(height: AppSpacing.lg),
                            const RecentlyViewedSection(),
                            const SizedBox(height: AppSpacing.xl),
                            const WhyNobleCardsSection(),
                            const SizedBox(height: AppSpacing.huge),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Gift Cards",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    "Buy, sell & discover gift cards worldwide",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Boxicons.bx_gift,
                    color: isDark ? AppColors.darkText : AppColors.primary,
                  ),
                  onPressed: () {}, // Existing header action
                ),
                IconButton(
                  icon: Icon(
                    Boxicons.bx_bell,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                  onPressed: () {}, // Existing header action
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}