import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';

class GiftCardHeroBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final String ctaText;
  final VoidCallback onCtaPressed;

  const GiftCardHeroBanner({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.ctaText,
    required this.onCtaPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        gradient: const LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primary, AppColors.successLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Boxicons.bxs_zap, color: Colors.white, size: 14),
                SizedBox(width: 4),
                Text('Best Rates • Instant Delivery', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, height: 1.2),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            subtitle,
            style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.white.withOpacity(0.9)),
          ),
          const SizedBox(height: AppSpacing.md),
          ElevatedButton(
            onPressed: onCtaPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primaryDark,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.full)),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(ctaText, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 4),
                const Icon(Boxicons.bx_right_arrow_alt, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}