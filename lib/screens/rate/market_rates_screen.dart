import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import 'providers/market_rates_provider.dart';
import 'widgets/market_rates_header.dart';
import 'widgets/market_rates_search.dart';
import 'widgets/market_rates_summary_cards.dart';
import 'widgets/market_rates_tabs.dart';
import 'widgets/market_rates_list.dart';
import 'widgets/market_realtime_card.dart';

class MarketRatesScreen extends StatelessWidget {
  const MarketRatesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MarketRatesProvider(),
      child: const _MarketRatesScreenBody(),
    );
  }
}

class _MarketRatesScreenBody extends StatelessWidget {
  const _MarketRatesScreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MarketRatesProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: isDark ? AppColors.darkCard : Colors.white,
          onRefresh: () async {
            HapticFeedback.lightImpact();
            await context.read<MarketRatesProvider>().refreshRates();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.md),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const MarketRatesHeader(),
                    const SizedBox(height: AppSpacing.lg),
                    
                    const MarketRatesSearch(),
                    const SizedBox(height: AppSpacing.lg),
                    
                    const MarketRatesSummaryCards(),
                    const SizedBox(height: AppSpacing.lg),
                    
                    const MarketRatesTabs(),
                    const SizedBox(height: AppSpacing.lg),
                    
                    const MarketRatesList(),
                    const SizedBox(height: AppSpacing.xl),
                    
                    if (!provider.isLoading) const MarketRealtimeCard(),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}