import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../models/account_tier_model.dart';

class AboutTiersSection extends StatelessWidget {
  final List<TierConfig> tiers;
  final String currentTierName;

  const AboutTiersSection({Key? key, required this.tiers, required this.currentTierName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("About Your Tier", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Column(
            children: tiers.map((tier) {
              final isCurrent = tier.name == currentTierName;
              return _buildTierRow(context, tier, isCurrent);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTierRow(BuildContext context, TierConfig tier, bool isCurrent) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Assigning distinct colors to emulate medal materials
    Color iconColor;
    switch (tier.name) {
      case "Bronze": iconColor = const Color(0xFFCD7F32); break;
      case "Silver": iconColor = const Color(0xFFC0C0C0); break;
      case "Gold": iconColor = const Color(0xFFFBBF24); break;
      case "Platinum": iconColor = const Color(0xFFE5E4E2); break;
      case "Diamond": iconColor = const Color(0xFF00BFFF); break;
      default: iconColor = AppColors.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isCurrent ? (isDark ? AppColors.primary.withOpacity(0.1) : AppColors.successLight.withOpacity(0.1)) : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: tier.name != "Diamond" ? (isDark ? AppColors.darkBorder : AppColors.lightBorder) : Colors.transparent,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: iconColor.withOpacity(0.2), shape: BoxShape.circle),
            child: Icon(tier.name == "Diamond" ? Boxicons.bxs_diamond : Boxicons.bxs_medal, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tier.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
                const SizedBox(height: 2),
                Text(
                  tier.maxPoints == 99999 ? "${tier.minPoints}+ points" : "${tier.minPoints} - ${tier.maxPoints} points",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            "Up to \$${(tier.dailyLimit / 1000).toInt()}k/day",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}