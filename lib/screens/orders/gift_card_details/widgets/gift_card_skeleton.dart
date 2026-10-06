import 'package:flutter/material.dart';
import '../../../../../theme/app_colors.dart';
import '../../../../../theme/app_spacing.dart';
import '../../../../../theme/app_radius.dart';

class GiftCardSkeleton extends StatefulWidget {
  const GiftCardSkeleton({Key? key}) : super(key: key);

  @override
  State<GiftCardSkeleton> createState() => _GiftCardSkeletonState();
}

class _GiftCardSkeletonState extends State<GiftCardSkeleton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final baseColor = isDark ? theme.cardColor : AppColors.lightBorder;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: 0.5 + (_controller.value * 0.5),
          child: Column(
            children: [
              // Header shim
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 40, height: 40, decoration: BoxDecoration(shape: BoxShape.circle, color: baseColor)),
                    Container(width: 100, height: 28, color: baseColor),
                    Container(width: 80, height: 28, decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppRadius.full), color: baseColor)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  children: [
                    const SizedBox(height: AppSpacing.s),
                    Container(width: 150, height: 24, color: baseColor, margin: const EdgeInsets.only(right: 150)),
                    const SizedBox(height: AppSpacing.xs),
                    Container(width: double.infinity, height: 16, color: baseColor),
                    Container(width: 200, height: 16, color: baseColor, margin: const EdgeInsets.only(top: 4, right: 100)),
                    const SizedBox(height: AppSpacing.l),
                    
                    // Hero Shim
                    Container(height: 90, decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.circular(AppRadius.lg))),
                    const SizedBox(height: AppSpacing.l),
                    
                    // Summary Shim
                    Container(height: 70, decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.circular(AppRadius.lg))),
                    const SizedBox(height: AppSpacing.l),
                    
                    // Code & PIN Shim
                    Container(height: 120, decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.circular(AppRadius.lg))),
                    const SizedBox(height: AppSpacing.m),
                    Container(height: 120, decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.circular(AppRadius.lg))),
                  ],
                ),
              ),
              // Bottom Button Shim
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: SafeArea(top: false, child: Container(height: 54, decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.circular(AppRadius.md)))),
              )
            ],
          ),
        );
      }
    );
  }
}