import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_animation.dart';

class TransactionHistoryShimmer extends StatefulWidget {
  const TransactionHistoryShimmer({Key? key}) : super(key: key);

  @override
  State<TransactionHistoryShimmer> createState() => _TransactionHistoryShimmerState();
}

class _TransactionHistoryShimmerState extends State<TransactionHistoryShimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? AppColors.darkCard : AppColors.lightBorder;

    return FadeTransition(
      opacity: Tween<double>(begin: 0.5, end: 1.0).animate(_controller),
      child: ListView.builder(
        itemCount: 6,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard.withOpacity(0.5) : AppColors.lightCard,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.circular(AppRadius.md)),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 100, height: 16, color: baseColor),
                      const SizedBox(height: 8),
                      Container(width: 80, height: 12, color: baseColor),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(width: 60, height: 16, color: baseColor),
                    const SizedBox(height: 8),
                    Container(
                      width: 50,
                      height: 20,
                      decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.circular(AppRadius.full)),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}