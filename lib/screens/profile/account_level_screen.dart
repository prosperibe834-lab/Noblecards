import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_shadow.dart';
import 'models/account_tier_model.dart';
import 'widgets/current_level_card.dart';
import 'widgets/daily_limit_card.dart';
import 'widgets/stats_grid.dart';
import 'widgets/tier_benefits_section.dart';
import 'widgets/about_tiers_section.dart';
import 'widgets/how_to_level_up_section.dart';
import 'widgets/support_section.dart';

class AccountLevelScreen extends StatefulWidget {
  const AccountLevelScreen({Key? key}) : super(key: key);

  @override
  State<AccountLevelScreen> createState() => _AccountLevelScreenState();
}

class _AccountLevelScreenState extends State<AccountLevelScreen> {
  bool _isLoading = true;
  AccountTierModel? _accountData;

  @override
  void initState() {
    super.initState();
    _fetchAccountTierData();
  }

  Future<void> _fetchAccountTierData() async {
    setState(() => _isLoading = true);
    // Simulate backend network delay
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() {
      _accountData = AccountTierModel.mockData;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Boxicons.bx_chevron_left, color: isDark ? AppColors.darkText : AppColors.lightText, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Account Level",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Boxicons.bx_info_circle, color: isDark ? AppColors.darkText : AppColors.lightText),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: _fetchAccountTierData,
          child: _isLoading
              ? _buildShimmerLoading(isDark)
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final isTablet = constraints.maxWidth > 700;

                    if (isTablet) {
                      return _buildTabletLayout();
                    }
                    return _buildMobileLayout();
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CurrentLevelCard(data: _accountData!),
          const SizedBox(height: 16),
          DailyLimitCard(data: _accountData!),
          const SizedBox(height: 16),
          StatsGrid(stats: _accountData!.stats),
          const SizedBox(height: 24),
          const TierBenefitsSection(),
          const SizedBox(height: 24),
          AboutTiersSection(tiers: _accountData!.allTiers, currentTierName: _accountData!.currentTier),
          const SizedBox(height: 24),
          const HowToLevelUpSection(),
          const SizedBox(height: 24),
          const SupportSection(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Column
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CurrentLevelCard(data: _accountData!),
                const SizedBox(height: 16),
                DailyLimitCard(data: _accountData!),
                const SizedBox(height: 16),
                StatsGrid(stats: _accountData!.stats),
                const SizedBox(height: 24),
                const TierBenefitsSection(),
              ],
            ),
          ),
          const SizedBox(width: 24),
          // Right Column
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AboutTiersSection(tiers: _accountData!.allTiers, currentTierName: _accountData!.currentTier),
                const SizedBox(height: 24),
                const HowToLevelUpSection(),
                const SizedBox(height: 24),
                const SupportSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading(bool isDark) {
    final baseColor = isDark ? AppColors.darkCard : AppColors.lightBorder;
    final highlightColor = isDark ? AppColors.darkInput : Colors.white;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(height: 180, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20))),
            const SizedBox(height: 16),
            Container(height: 100, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20))),
            const SizedBox(height: 16),
            Container(height: 160, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20))),
          ],
        ),
      ),
    );
  }
}