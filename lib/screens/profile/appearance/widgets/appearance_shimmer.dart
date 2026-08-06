import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';

class AppearanceShimmer extends StatefulWidget {
  const AppearanceShimmer({super.key});

  @override
  State<AppearanceShimmer> createState() => _AppearanceShimmerState();
}

class _AppearanceShimmerState extends State<AppearanceShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.8).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.white10 : Colors.grey.shade300;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 80, height: 20, color: baseColor),
              const SizedBox(height: 8),
              Container(width: 220, height: 14, color: baseColor),
              const SizedBox(height: 24),
              
              ...List.generate(3, (index) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              )),
              
              const SizedBox(height: 8),
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}