import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../providers/market_rates_provider.dart';
import '../models/market_rate_model.dart';
import 'gift_card_action_sheet.dart';

class MarketRatesList extends StatelessWidget {
  const MarketRatesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MarketRatesProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (provider.isLoading) {
      return _buildShimmerList(isDark);
    }

    final rates = provider.filteredAndSortedRates;

    if (rates.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Column(
            children: [
              Icon(Boxicons.bx_credit_card_front, size: 64, color: Theme.of(context).textTheme.bodyMedium!.color?.withOpacity(0.5)),
              const SizedBox(height: AppSpacing.md),
              Text('No gift cards found', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // List Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s, vertical: AppSpacing.s),
          child: Row(
            children: [
              Expanded(flex: 3, child: Text('Gift Card', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11))),
              Expanded(flex: 2, child: Text('Buy Rate\n(We buy)', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11))),
              Expanded(flex: 2, child: Text('Sell Rate\n(We sell)', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11))),
              Expanded(flex: 2, child: Text('Change\n24h', textAlign: TextAlign.right, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11))),
              const SizedBox(width: 20), // Chevron spacer
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        
        // List Rows
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: rates.length,
          separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.s),
          itemBuilder: (context, index) => _MarketRateRow(rate: rates[index]),
        ),
      ],
    );
  }

  Widget _buildShimmerList(bool isDark) {
    final shimmerColor = isDark ? AppColors.darkCard : AppColors.lightBorder.withOpacity(0.5);
    return Column(
      children: List.generate(5, (index) => Container(
        height: 70,
        margin: const EdgeInsets.only(bottom: AppSpacing.s),
        decoration: BoxDecoration(color: shimmerColor, borderRadius: BorderRadius.circular(AppRadius.md)),
      )),
    );
  }
}

class _MarketRateRow extends StatelessWidget {
  final MarketRateModel rate;
  const _MarketRateRow({required this.rate});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => GiftCardActionSheet(rate: rate),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: isDark ? Border.all(color: AppColors.darkBorder) : Border.all(color: AppColors.lightBorder, width: 0.5),
          boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 5, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            // Logo & Name
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(color: isDark ? AppColors.darkInput : AppColors.lightBackground, borderRadius: BorderRadius.circular(AppRadius.sm)),
                    child: Icon(rate.icon, color: Theme.of(context).textTheme.bodyLarge!.color),
                  ),
                  const SizedBox(width: AppSpacing.s),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(rate.name, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 13, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(rate.flag, style: const TextStyle(fontSize: 10)),
                            const SizedBox(width: 4),
                            Text(rate.country, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11)),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Buy Rate
            Expanded(
              flex: 2,
              child: Text('\$${rate.buyRate.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Poppins')),
            ),
            
            // Sell Rate
            Expanded(
              flex: 2,
              child: Text('\$${rate.sellRate.toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Poppins')),
            ),
            
            // Change
            Expanded(
              flex: 2,
              child: Text(
                '${rate.isPositive ? '↑' : '↓'} ${rate.change24h.abs()}%',
                textAlign: TextAlign.right,
                style: TextStyle(color: rate.isPositive ? AppColors.primary : AppColors.error, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            
            // Chevron
            const SizedBox(width: AppSpacing.s),
            Icon(Boxicons.bx_chevron_right, size: 16, color: Theme.of(context).textTheme.bodyMedium!.color),
          ],
        ),
      ),
    );
  }
}