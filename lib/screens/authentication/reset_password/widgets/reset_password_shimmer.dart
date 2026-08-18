import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';

/// A reusable shimmer widget to display during initial data load or layout building
class ResetPasswordShimmer extends StatefulWidget {
  const ResetPasswordShimmer({super.key});

  @override
  State<ResetPasswordShimmer> createState() => _ResetPasswordShimmerState();
}

class _ResetPasswordShimmerState extends State<ResetPasswordShimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color baseColor = isDark ? AppColors.darkCard : AppColors.lightBorder;
    final Color highlightColor = isDark ? AppColors.darkBorder : Colors.white;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [baseColor, highlightColor, baseColor],
              stops: const [0.1, 0.5, 0.9],
              begin: const Alignment(-1.0, -0.3),
              end: const Alignment(1.0, 0.3),
              transform: _SlidingGradientTransform(slidePercent: _controller.value),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Container(width: 150, height: 40, color: Colors.white, margin: const EdgeInsets.only(bottom: 24)),
            Container(width: 200, height: 28, color: Colors.white, margin: const EdgeInsets.only(bottom: 12)),
            Container(width: 280, height: 40, color: Colors.white, margin: const EdgeInsets.only(bottom: 40)),
            Container(width: 180, height: 180, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white), margin: const EdgeInsets.only(bottom: 40)),
            Container(height: 80, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), margin: const EdgeInsets.only(bottom: 16)),
            Container(height: 60, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), margin: const EdgeInsets.only(bottom: 24)),
            Container(height: 56, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
          ],
        ),
      ),
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;
  const _SlidingGradientTransform({required this.slidePercent});

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * (slidePercent * 2 - 1), 0.0, 0.0);
  }
}