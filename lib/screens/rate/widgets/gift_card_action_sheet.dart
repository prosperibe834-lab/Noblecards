import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../models/market_rate_model.dart';

class GiftCardActionSheet extends StatelessWidget {
  final MarketRateModel rate;

  const GiftCardActionSheet({Key? key, required this.rate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Theme.of(context).dividerColor, borderRadius: BorderRadius.circular(AppRadius.full))),
            const SizedBox(height: AppSpacing.lg),
            
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(color: isDark ? AppColors.darkCard : Colors.white, shape: BoxShape.circle, border: Border.all(color: Theme.of(context).dividerColor)),
              child: Icon(rate.icon, size: 48, color: Theme.of(context).textTheme.bodyLarge!.color),
            ),
            const SizedBox(height: AppSpacing.md),
            
            Text(rate.name, style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 22)),
            const SizedBox(height: AppSpacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(rate.flag, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: AppSpacing.xs),
                Text('${rate.country} Market', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            Row(
              children: [
                Expanded(
                  child: _buildRateCard(context, 'We Buy', '\$${rate.buyRate.toStringAsFixed(2)}', AppColors.primary, isDark),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _buildRateCard(context, 'We Sell', '\$${rate.sellRate.toStringAsFixed(2)}', Theme.of(context).textTheme.bodyLarge!.color!, isDark),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Navigate to Buy screen passing rate.id
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? AppColors.darkCard : Colors.white,
                      foregroundColor: Theme.of(context).textTheme.bodyLarge!.color,
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md), side: BorderSide(color: Theme.of(context).dividerColor)),
                      elevation: 0,
                    ),
                    child: const Text('Buy Gift Card', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Navigate to Sell screen passing rate.id
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                      elevation: 0,
                    ),
                    child: const Text('Sell Gift Card', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  Widget _buildRateCard(BuildContext context, String label, String amount, Color amountColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: isDark ? Border.all(color: AppColors.darkBorder) : Border.all(color: AppColors.lightBorder, width: 0.5),
      ),
      child: Column(
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12)),
          const SizedBox(height: AppSpacing.xs),
          Text(amount, style: TextStyle(color: amountColor, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
        ],
      ),
    );
  }
}