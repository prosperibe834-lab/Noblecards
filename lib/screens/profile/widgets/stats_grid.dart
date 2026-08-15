import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_shadow.dart';
import '../models/account_tier_model.dart';

class StatsGrid extends StatelessWidget {
  final AccountStats stats;

  const StatsGrid({Key? key, required this.stats}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.2,
      children: [
        _buildStatCard(context, Boxicons.bxs_star, AppColors.warning, "Total Points", stats.totalPoints.toString(), "Lifetime points"),
        _buildStatCard(context, Boxicons.bx_calendar, AppColors.info, "Member Since", stats.memberSince, "1 year, 2 months"),
        _buildStatCard(context, Boxicons.bx_bar_chart_alt_2, AppColors.success, "Successful Transactions", stats.successfulTransactions.toString(), "This month"),
        _buildStatCard(context, Boxicons.bx_wallet, AppColors.accentViolet, "Total Volume", "\$${stats.totalVolume.toInt().toString().replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',')}", "This month"),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, IconData icon, Color color, String title, String value, String subtitle) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        boxShadow: isDark ? AppShadow.dark : AppShadow.light,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
                const SizedBox(height: 2),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 9)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}