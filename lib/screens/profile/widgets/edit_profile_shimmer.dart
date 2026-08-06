import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';

class EditProfileShimmer extends StatefulWidget {
  const EditProfileShimmer({super.key});

  @override
  State<EditProfileShimmer> createState() => _EditProfileShimmerState();
}

class _EditProfileShimmerState extends State<EditProfileShimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _opacityAnim = Tween<double>(begin: 0.3, end: 0.8).animate(_controller);
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
      animation: _opacityAnim,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnim.value,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Avatar shimmer
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: baseColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 16),
                Container(width: 140, height: 14, color: baseColor),
                const SizedBox(height: 24),
                // Card Shimmer
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: List.generate(
                      6,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: baseColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}