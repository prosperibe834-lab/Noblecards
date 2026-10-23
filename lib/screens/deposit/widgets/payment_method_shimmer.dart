// Location: lib/deposit/widgets/payment_method_shimmer.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/theme_provider.dart';

class PaymentMethodShimmer extends StatefulWidget {
  const PaymentMethodShimmer({super.key});

  @override
  State<PaymentMethodShimmer> createState() => _PaymentMethodShimmerState();
}

class _PaymentMethodShimmerState extends State<PaymentMethodShimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final baseColor = isDark ? AppColors.darkCard : AppColors.lightBorder.withOpacity(0.5);
    final highlightColor = isDark ? AppColors.darkBorder : Colors.white.withOpacity(0.5);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [baseColor, highlightColor, baseColor],
              stops: const [0.1, 0.5, 0.9],
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value + 1, 0),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.lg)),
          ),
          const SizedBox(height: AppSpacing.xl),
          Container(height: 20, width: 120, color: Colors.white),
          const SizedBox(height: AppSpacing.md),
          ...List.generate(4, (index) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.md)),
            ),
          )),
        ],
      ),
    );
  }
}
