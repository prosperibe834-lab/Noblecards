import 'package:flutter/material.dart';

class LanguageLoadingShimmer extends StatelessWidget {
  const LanguageLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.white10 : Colors.black.withOpacity(0.05);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Shimmer
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(height: 24),
          // Search Shimmer
          Container(
            height: 54,
            width: double.infinity,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 32),
          // List Title Shimmer
          Container(height: 20, width: 100, color: baseColor),
          const SizedBox(height: 16),
          // List Shimmer
          ...List.generate(6, (index) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Container(height: 30, width: 40, color: baseColor),
                const SizedBox(width: 16),
                Container(height: 20, width: 150, color: baseColor),
                const Spacer(),
                Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: baseColor),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}