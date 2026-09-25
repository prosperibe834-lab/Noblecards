import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../models/analytics_model.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';

class AnalyticsRecentActivity extends StatelessWidget {
  final List<RecentActivityItem> activities;
  final VoidCallback onViewAll;

  const AnalyticsRecentActivity({
    Key? key,
    required this.activities,
    required this.onViewAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activity',
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            GestureDetector(
              onTap: onViewAll,
              child: const Row(
                children: [
                  Text(
                    'View All',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Boxicons.bx_right_arrow_alt, color: AppColors.primary, size: 16),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        ...activities.map((item) => _ActivityRow(item: item)).toList(),
      ],
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final RecentActivityItem item;

  const _ActivityRow({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subTextColor = isDark ? AppColors.darkSubText : AppColors.lightSubText;

    IconData icon;
    Color color;

    switch (item.category) {
      case 'deposit':
        icon = Boxicons.bx_download;
        color = AppColors.primary;
        break;
      case 'withdrawal':
        icon = Boxicons.bx_upload;
        color = AppColors.accentViolet;
        break;
      case 'buy':
        icon = Boxicons.bx_gift;
        color = AppColors.secondary;
        break;
      case 'sell':
      default:
        icon = Boxicons.bx_tag_alt;
        color = AppColors.accent;
        break;
    }

    final prefix = item.isPositive ? '+' : '-';
    final amountColor = item.isPositive ? AppColors.success : textColor;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  style: TextStyle(
                    color: subTextColor,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$prefix\$${item.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: amountColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  item.status,
                  style: const TextStyle(
                    color: AppColors.success,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}