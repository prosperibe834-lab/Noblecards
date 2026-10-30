import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../localization/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../authentication/services/authentication_service.dart';
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
    try {
      final response = await AuthenticationService().authenticatedGet('/users/me/account-tier');
      setState(() {
        _accountData = AccountTierModel.fromJson(response);
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        _accountData = AccountTierModel.mockData;
        _isLoading = false;
      });
    }
  }

  void _showAccountLevelInfoSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Indicator
              const SizedBox(height: 12),
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 16),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Boxicons.bx_info_circle,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Account Level & Points",
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "How your VIP tier status and limits work",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 12,
                                  color: isDark
                                      ? AppColors.darkSubText
                                      : AppColors.lightSubText,
                                ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Boxicons.bx_x,
                        color: isDark ? Colors.white70 : Colors.black54,
                        size: 24,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Divider(
                height: 1,
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),

              // Content List
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section 1: What is Account Level?
                      _buildInfoSection(
                        context,
                        icon: Boxicons.bxs_award,
                        iconColor: const Color(0xFFFBBF24),
                        title: "What is Account Level?",
                        description:
                            "Your Account Level reflects your activity and trustworthiness on NobleCards. As you complete trades, buy, and sell gift cards, you earn lifetime points and climb tiers to unlock higher daily transaction limits, exclusive bonuses, and VIP priority care.",
                        isDark: isDark,
                      ),
                      const SizedBox(height: 16),

                      // Section 2: How Points are Earned
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkBackground.withOpacity(0.6)
                              : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Boxicons.bxs_zap,
                                  color: AppColors.warning,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "How You Earn Points",
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildPointRow(context, "Completed Transaction", "+15 pts", isDark),
                            _buildPointRow(context, "Gift Card Bought", "+25 pts", isDark),
                            _buildPointRow(context, "Gift Card Sold", "+25 pts", isDark),
                            _buildPointRow(context, "Every \$10 Trading Volume", "+1 pt", isDark),
                            _buildPointRow(context, "Invited Friend (Referral)", "+50 pts", isDark),
                            _buildPointRow(context, "ID Verification (KYC)", "+200 pts bonus", isDark, isHighlight: true),
                            _buildPointRow(context, "Email Verification", "+50 pts bonus", isDark),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Section 3: Daily Limits
                      _buildInfoSection(
                        context,
                        icon: Boxicons.bx_shield_quarter,
                        iconColor: AppColors.primary,
                        title: "Daily Transaction Limits",
                        description:
                            "Every tier has a dedicated daily transaction limit. This limit automatically resets every 24 hours at 00:00 UTC. Leveling up to a higher tier increases your daily cap up to \$50,000 per day.",
                        isDark: isDark,
                      ),
                      const SizedBox(height: 16),

                      // Section 4: Lifetime Status
                      _buildInfoSection(
                        context,
                        icon: Boxicons.bx_infinite,
                        iconColor: AppColors.accentViolet,
                        title: "Lifetime Points Never Expire",
                        description:
                            "Your earned points accumulate for life. You will never lose your status or be demoted due to account inactivity. Keep trading to unlock the next VIP tier!",
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Button
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Understood",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoSection(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkBackground.withOpacity(0.6)
            : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointRow(
    BuildContext context,
    String label,
    String points,
    bool isDark, {
    bool isHighlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white70 : Colors.black87,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: isHighlight
                  ? AppColors.primary.withOpacity(0.15)
                  : (isDark ? Colors.white10 : Colors.black.withOpacity(0.04)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              points,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isHighlight
                    ? AppColors.primary
                    : (isDark ? Colors.white : Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Boxicons.bx_chevron_left,
            color: isDark ? AppColors.darkText : AppColors.lightText,
            size: 28,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.tr('account_level'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Boxicons.bx_info_circle,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
            onPressed: () => _showAccountLevelInfoSheet(context),
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
          TierBenefitsSection(data: _accountData!),
          const SizedBox(height: 24),
          AboutTiersSection(
            tiers: _accountData!.allTiers,
            currentTierName: _accountData!.currentTier,
          ),
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
                TierBenefitsSection(data: _accountData!),
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
                AboutTiersSection(
                  tiers: _accountData!.allTiers,
                  currentTierName: _accountData!.currentTier,
                ),
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
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
