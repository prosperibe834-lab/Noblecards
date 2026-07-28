import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

class AnalyticsCardPerformanceSection extends StatelessWidget {
  const AnalyticsCardPerformanceSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cards = [
      {
        'name': 'Apple Gift Card',
        'tag': 'Most Sold',
        'trades': 142,
        'amount': '\$38,400',
        'profit': '+\$4,200',
        'icon': Boxicons.bxl_apple,
      },
      {
        'name': 'Amazon US',
        'tag': 'Highest Profit',
        'trades': 98,
        'amount': '\$29,100',
        'profit': '+\$3,850',
        'icon': Boxicons.bxl_amazon,
      },
      {
        'name': 'Steam Card',
        'tag': 'Trending',
        'trades': 84,
        'amount': '\$18,900',
        'profit': '+\$2,100',
        'icon': Boxicons.bx_game,
      },
      {
        'name': 'Google Play',
        'tag': 'Most Bought',
        'trades': 62,
        'amount': '\$12,500',
        'profit': '+\$1,400',
        'icon': Boxicons.bxl_play_store,
      },
    ];

    return Column(
      children: cards.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.s),
          padding: const EdgeInsets.all(AppSpacing.m),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.black.withOpacity(0.05),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  item['icon'] as IconData,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          item['name'].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accentViolet.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item['tag'].toString(),
                            style: const TextStyle(
                              fontSize: 9,
                              color: AppColors.accentViolet,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${item['trades']} trades • Volume ${item['amount']}',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Text(
                item['profit'].toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.success,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
