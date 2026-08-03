import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class PromoIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const PromoIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          height: 5,
          width: currentIndex == index ? 18 : 5,
          decoration: BoxDecoration(
            color: currentIndex == index
                ? AppColors.accentViolet
                : AppColors.lightSubText.withOpacity(0.3),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}