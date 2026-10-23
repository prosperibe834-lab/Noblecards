// Location: lib/deposit/widgets/popular_deposit_currencies.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/theme_provider.dart';
import '../providers/deposit_currency_provider.dart';

class PopularDepositCurrencies extends StatelessWidget {
  const PopularDepositCurrencies({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DepositCurrencyProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final popularList = provider.popularCurrencies;

    if (popularList.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.local_fire_department, color: AppColors.primary, size: 20),
                  const SizedBox(width: 6),
                  Text('Popular', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              GestureDetector(
                onTap: () {
                  // View all
                },
                child: const Row(
                  children: [
                    Text('View all', style: TextStyle(color: AppColors.primary, fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600)),
                    Icon(Icons.chevron_right, color: AppColors.primary, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: popularList.map((currency) {
              final isSelected = provider.selectedCurrency?.code == currency.code;
              
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: GestureDetector(
                  onTap: () {
                    provider.selectCurrency(currency);
                    Navigator.pop(context, currency);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? AppColors.primary 
                          : (isDark ? AppColors.darkCard : AppColors.lightCard),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      boxShadow: isSelected && isDark ? [
                        BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))
                      ] : null,
                      border: Border.all(
                        color: isSelected ? AppColors.primary : theme.dividerColor,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(currency.flagAsset, style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          currency.code,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: isSelected ? Colors.white : (isDark ? AppColors.darkText : AppColors.lightText),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
