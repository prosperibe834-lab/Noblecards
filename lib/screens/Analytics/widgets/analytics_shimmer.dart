import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';

class AnalyticsShimmer extends StatefulWidget {
  const AnalyticsShimmer({Key? key}) : super(key: key);

  @override
  State<AnalyticsShimmer> createState() => _AnalyticsShimmerState();
}

class _AnalyticsShimmerState extends State<AnalyticsShimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat(reverse: true);
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
      opacity: Tween<double>(begin: 0.4, end: 0.9).animate(_controller),
      child: Column(
        children: [
          Container(height: 140, decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.circular(AppRadius.lg))),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(child: Container(height: 100, decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.circular(AppRadius.lg)))),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Container(height: 100, decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.circular(AppRadius.lg)))),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(height: 220, decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.circular(AppRadius.lg))),
        ],
      ),
    );
  }
}