import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';

class MarketRealtimeCard extends StatelessWidget {
  const MarketRealtimeCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark ? [const Color(0xFF0D2518), const Color(0xFF163524)] : [const Color(0xFFE6F6EC), const Color(0xFFF2FBF5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.primary.withOpacity(0.2) : Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Boxicons.bxs_zap, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Rates update in real-time', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text('Our rates change continuously based on market demand and availability.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11, height: 1.4)),
                  ],
                ),
              ),
              // Decorative Graphic representation
              const SizedBox(width: AppSpacing.sm),
              Icon(Boxicons.bx_line_chart, size: 40, color: AppColors.primary.withOpacity(isDark ? 0.4 : 0.2)),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Boxicons.bx_check_shield, color: AppColors.primary, size: 16),
            const SizedBox(width: AppSpacing.xs),
            Text('All rates are verified and updated in real-time', style: TextStyle(color: AppColors.primary.withOpacity(0.8), fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}