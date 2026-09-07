import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_animation.dart';
import '../providers/create_pin_provider.dart';

class PinInputDisplay extends StatelessWidget {
  const PinInputDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreatePinProvider>(
      builder: (context, provider, child) {
        final pinLength = provider.pin.length;
        
        return AnimatedOpacity(
          opacity: provider.isLoading ? 0.5 : 1.0,
          duration: AppAnimation.normal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              final isFilled = index < pinLength;
              return _PinBox(isFilled: isFilled);
            }),
          ),
        );
      },
    );
  }
}

class _PinBox extends StatelessWidget {
  final bool isFilled;

  const _PinBox({required this.isFilled});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: AppAnimation.fast,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkInput : AppColors.lightInput,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isFilled 
              ? AppColors.primary 
              : (isDarkMode ? AppColors.darkBorder : AppColors.lightBorder),
          width: isFilled ? 1.5 : 1,
        ),
      ),
      child: Center(
        child: AnimatedScale(
          scale: isFilled ? 1.0 : 0.0,
          duration: AppAnimation.fast,
          child: Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}