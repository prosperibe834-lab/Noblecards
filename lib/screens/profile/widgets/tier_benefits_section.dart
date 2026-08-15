import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_shadow.dart';

class TierBenefitsSection extends StatelessWidget {
  const TierBenefitsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Tier Benefits", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
            TextButton(
              onPressed: () {},
              child: const Text("View All Benefits >", style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildBenefitItem(context, "Higher Limits", Boxicons.bx_line_chart, AppColors.success, isDark),
            _buildBenefitItem(context, "Better Rates", Boxicons.bx_cog, AppColors.info, isDark),
            _buildBenefitItem(context, "Priority Support", Boxicons.bx_headphone, AppColors.accentViolet, isDark),
            _buildBenefitItem(context, "Faster Payouts", Boxicons.bxs_zap, AppColors.warning, isDark),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            icon: const Icon(Boxicons.bx_crown, size: 20),
            label: const Text("View All Tier Benefits", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitItem(BuildContext context, String title, IconData icon, Color iconColor, bool isDark) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          boxShadow: isDark ? AppShadow.dark : AppShadow.light,
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 10, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}