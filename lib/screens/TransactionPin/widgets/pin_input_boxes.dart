import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';

class PinInputBoxes extends StatelessWidget {
  final String pin;
  final int maxLength;
  final bool isError;
  final Animation<double> shakeAnimation;

  const PinInputBoxes({
    super.key,
    required this.pin,
    this.maxLength = 4,
    this.isError = false,
    required this.shakeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: shakeAnimation,
      builder: (context, child) {
        final double offset = math.sin(shakeAnimation.value * math.pi * 4) * 8.0;
        return Transform.translate(
          offset: Offset(offset, 0),
          child: child,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(maxLength, (index) {
          final isFilled = index < pin.length;
          final isCurrent = index == pin.length;

          Color borderColor;
          Color backgroundColor;

          if (isError) {
            borderColor = AppColors.error;
            backgroundColor = isDark
                ? AppColors.error.withOpacity(0.12)
                : AppColors.error.withOpacity(0.06);
          } else if (isFilled) {
            borderColor = AppColors.primary;
            backgroundColor = isDark
                ? AppColors.primary.withOpacity(0.1)
                : AppColors.primary.withOpacity(0.04);
          } else if (isCurrent) {
            borderColor = AppColors.primary.withOpacity(0.6);
            backgroundColor = isDark ? AppColors.darkInput : Colors.white;
          } else {
            borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
            backgroundColor = isDark ? AppColors.darkInput : Colors.white;
          }

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: borderColor,
                width: isFilled || isCurrent ? 2.0 : 1.2,
              ),
              boxShadow: [
                if (isFilled && !isError)
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                if (isError)
                  BoxShadow(
                    color: AppColors.error.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: isFilled
                    ? Container(
                        key: ValueKey('dot_$index'),
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: isError ? AppColors.error : AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      )
                    : const SizedBox.shrink(key: ValueKey('empty')),
              ),
            ),
          );
        }),
      ),
    );
  }
}