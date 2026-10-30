import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import '../../../localization/app_localizations.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_shadow.dart';
import '../models/account_tier_model.dart';

class TierBenefitsSection extends StatelessWidget {
  final AccountTierModel? data;

  const TierBenefitsSection({Key? key, this.data}) : super(key: key);

  void _showAllBenefitsSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentTierName = data?.currentTier ?? "Gold";

    final tiersInfo = [
      {
        "name": "Bronze",
        "points": "0 - 499 pts",
        "dailyLimit": "\$2,000 / day",
        "color": const Color(0xFFCD7F32),
        "icon": Boxicons.bxs_medal,
        "perks": [
          "Standard daily transaction limit of \$2,000",
          "Competitive exchange & trade rates",
          "24/7 Standard email & chat support",
          "Fast automated card processing",
        ],
      },
      {
        "name": "Silver",
        "points": "500 - 1,499 pts",
        "dailyLimit": "\$5,000 / day",
        "color": const Color(0xFFC0C0C0),
        "icon": Boxicons.bxs_medal,
        "perks": [
          "Increased daily transaction limit of \$5,000",
          "+0.5% Bonus rate on gift card sales",
          "Faster withdrawal settlement queue",
          "Standard priority customer support",
        ],
      },
      {
        "name": "Gold",
        "points": "1,500 - 2,999 pts",
        "dailyLimit": "\$10,000 / day",
        "color": const Color(0xFFFBBF24),
        "icon": Boxicons.bx_crown,
        "perks": [
          "High daily transaction limit of \$10,000",
          "+1.0% Bonus rate on all gift card trades",
          "Priority transaction & withdrawal queue",
          "Dedicated live chat customer care",
        ],
      },
      {
        "name": "Platinum",
        "points": "3,000 - 7,499 pts",
        "dailyLimit": "\$25,000 / day",
        "color": const Color(0xFFA78BFA),
        "icon": Boxicons.bx_crown,
        "perks": [
          "VIP daily transaction limit of \$25,000",
          "+1.5% Bonus rate on gift card sales",
          "Instant withdrawal processing",
          "Dedicated VIP account manager",
        ],
      },
      {
        "name": "Diamond",
        "points": "7,500+ pts",
        "dailyLimit": "\$50,000 / day",
        "color": const Color(0xFF00BFFF),
        "icon": Boxicons.bxs_diamond,
        "perks": [
          "Maximum daily transaction limit of \$50,000",
          "Highest possible rates across all card brands",
          "Zero deposit fees across all supported methods",
          "24/7 VIP Concierge & personalized support",
        ],
      },
    ];

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

              // Sheet Header
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
                        Boxicons.bx_crown,
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
                            "Tier Benefits & Privileges",
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Perks and daily limits for each NobleCards level",
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

              // Scrollable Tiers List
              Flexible(
                child: ListView.separated(
                  padding: const EdgeInsets.all(20),
                  shrinkWrap: true,
                  itemCount: tiersInfo.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final tier = tiersInfo[index];
                    final tierName = tier["name"] as String;
                    final isCurrent = tierName.toLowerCase() == currentTierName.toLowerCase();
                    final tierColor = tier["color"] as Color;
                    final tierIcon = tier["icon"] as IconData;
                    final perks = tier["perks"] as List<String>;

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? (isDark
                                ? AppColors.primary.withOpacity(0.08)
                                : AppColors.successLight.withOpacity(0.08))
                            : (isDark
                                ? AppColors.darkBackground.withOpacity(0.6)
                                : const Color(0xFFF8FAFC)),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isCurrent
                              ? AppColors.primary
                              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                          width: isCurrent ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tier Header Row
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: tierColor.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(tierIcon, color: tierColor, size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          tierName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        if (isCurrent) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary,
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: const Text(
                                              "CURRENT TIER",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      tier["points"] as String,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isDark
                                            ? AppColors.darkSubText
                                            : AppColors.lightSubText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  tier["dailyLimit"] as String,
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Perks List
                          ...perks.map((perk) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Boxicons.bxs_check_circle,
                                    color: isCurrent
                                        ? AppColors.primary
                                        : (isDark ? Colors.white38 : Colors.black38),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      perk,
                                      style: TextStyle(
                                        fontSize: 12,
                                        height: 1.3,
                                        color: isDark ? Colors.white70 : Colors.black87,
                                        fontWeight: isCurrent
                                            ? FontWeight.w500
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  },
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
                      "Got It",
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.tr('tier_benefits'),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontSize: 18),
            ),
            TextButton(
              onPressed: () => _showAllBenefitsSheet(context),
              child: Text(
                context.tr('view_all_benefits'),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildBenefitItem(
              context,
              context.tr('higher_limits'),
              Boxicons.bx_line_chart,
              AppColors.success,
              isDark,
            ),
            _buildBenefitItem(
              context,
              context.tr('better_rates_label'),
              Boxicons.bx_cog,
              AppColors.info,
              isDark,
            ),
            _buildBenefitItem(
              context,
              context.tr('priority_support'),
              Boxicons.bx_headphone,
              AppColors.accentViolet,
              isDark,
            ),
            _buildBenefitItem(
              context,
              context.tr('fast_delivery'),
              Boxicons.bxs_zap,
              AppColors.warning,
              isDark,
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () => _showAllBenefitsSheet(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            icon: const Icon(Boxicons.bx_crown, size: 20),
            label: const Text(
              "View All Tier Benefits",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitItem(
    BuildContext context,
    String title,
    IconData icon,
    Color iconColor,
    bool isDark,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          boxShadow: isDark ? AppShadow.dark : AppShadow.light,
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
