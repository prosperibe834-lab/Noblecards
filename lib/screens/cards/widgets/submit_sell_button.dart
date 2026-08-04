import 'package:flutter/material.dart';
import 'package:noble_cards/theme/app_colors.dart';
import 'package:noble_cards/theme/app_radius.dart';
import 'package:noble_cards/theme/app_spacing.dart';
import 'package:noble_cards/theme/app_animation.dart';

class SubmitSellButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onTap;

  const SubmitSellButton({super.key, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: AppAnimation.fast,
      opacity: enabled ? 1 : 0.5,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          width: double.infinity,
          height: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]),
            boxShadow: [
              BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Submit Cards for Verification', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
              SizedBox(width: AppSpacing.sm),
              Icon(Icons.arrow_forward, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
