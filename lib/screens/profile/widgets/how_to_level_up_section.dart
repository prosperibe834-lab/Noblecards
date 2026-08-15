import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_shadow.dart';

class HowToLevelUpSection extends StatelessWidget {
  const HowToLevelUpSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("How to Level Up", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            boxShadow: isDark ? AppShadow.dark : AppShadow.light,
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCheckItem(context, "Complete more transactions"),
                  _buildCheckItem(context, "Buy or sell more gift cards"),
                  _buildCheckItem(context, "Keep your account secure"),
                  _buildCheckItem(context, "Maintain a good account standing"),
                ],
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Icon(Boxicons.bx_trophy, size: 60, color: AppColors.primary.withOpacity(0.2)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCheckItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Boxicons.bxs_check_circle, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}