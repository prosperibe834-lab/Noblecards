import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';

class HelpCenterShimmer extends StatefulWidget {
  const HelpCenterShimmer({super.key});

  @override
  State<HelpCenterShimmer> createState() => _HelpCenterShimmerState();
}

class _HelpCenterShimmerState extends State<HelpCenterShimmer>
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
    _animation = Tween<double>(begin: 0.2, end: 0.7).animate(_controller);
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar Shimmer
                Container(
                  height: 50,
                  decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.circular(16)),
                ),
                const SizedBox(height: 24),
                // Section Title Shimmer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 100, height: 16, color: baseColor),
                    Container(width: 50, height: 14, color: baseColor),
                  ],
                ),
                const SizedBox(height: 16),
                // Quick Help Grid Shimmer
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 8,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (_, __) => Container(
                    decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const SizedBox(height: 24),
                // FAQs Title
                Container(width: 180, height: 16, color: baseColor),
                const SizedBox(height: 16),
                // FAQs List Shimmer
                ...List.generate(4, (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Container(width: double.infinity, height: 40, color: baseColor),
                )),
              ],
            ),
          ),
        );
      },
    );
  }
}