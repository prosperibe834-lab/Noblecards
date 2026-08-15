import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_shadow.dart';
import '../models/account_tier_model.dart';
import 'transaction_limit_selector.dart';

class DailyLimitCard extends StatelessWidget {
  final AccountTierModel data;

  const DailyLimitCard({Key? key, required this.data}) : super(key: key);

  void _showLimitsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TransactionLimitSelector(tiers: data.allTiers, currentTierName: data.currentTier),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return InkWell(
      onTap: () => _showLimitsSheet(context),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          boxShadow: isDark ? AppShadow.dark : AppShadow.light,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Boxicons.bx_shield_quarter, color: AppColors.primary, size: 18),
                ),
                const SizedBox(width: 12),
                Text(
                  "Daily Transaction Limit",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
                ),
                const Spacer(),
                Icon(Boxicons.bx_chevron_right, color: isDark ? AppColors.darkSubText : AppColors.lightSubText),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "\$${data.dailyLimit.toInt().toString().replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',')}",
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: AppColors.primary, fontSize: 32),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Remaining Today",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildCircularProgress(),
                    const SizedBox(height: 8),
                    Text(
                      "\$${data.remainingDailyLimit.toInt().toString().replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',')} left",
                      style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularProgress() {
    final double percentage = data.remainingDailyLimit / data.dailyLimit;
    return SizedBox(
      height: 50,
      width: 50,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: percentage,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            color: AppColors.primary,
            strokeWidth: 5,
            strokeCap: StrokeCap.round,
          ),
          Center(
            child: Text(
              "${(percentage * 100).toInt()}%",
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}