import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../models/account_tier_model.dart';

class TransactionLimitSelector extends StatelessWidget {
  final List<TierConfig> tiers;
  final String currentTierName;

  const TransactionLimitSelector({Key? key, required this.tiers, required this.currentTierName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(width: 40, height: 4, decoration: BoxDecoration(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 24),
            Text("Daily Limits by Tier", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text("Upgrade your tier to unlock higher daily transaction limits.", style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            ...tiers.map((tier) => _buildLimitRow(context, tier, tier.name == currentTierName)).toList(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text("Close", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLimitRow(BuildContext context, TierConfig tier, bool isCurrent) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrent ? (isDark ? AppColors.primary.withOpacity(0.1) : AppColors.successLight.withOpacity(0.1)) : (isDark ? AppColors.darkCard : AppColors.lightCard),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isCurrent ? AppColors.primary.withOpacity(0.5) : (isDark ? AppColors.darkBorder : AppColors.lightBorder)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Boxicons.bxs_medal, color: isCurrent ? AppColors.primary : (isDark ? AppColors.darkSubText : AppColors.lightSubText)),
              const SizedBox(width: 12),
              Text(tier.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
            ],
          ),
          Text(
            "\$${tier.dailyLimit.toInt().toString().replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',')}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}