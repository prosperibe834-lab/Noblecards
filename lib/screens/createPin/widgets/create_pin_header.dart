import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';

class CreatePinHeader extends StatelessWidget {
  const CreatePinHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md, 
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: Icon(
              Boxicons.bx_arrow_back,
              color: isDarkMode ? AppColors.darkText : AppColors.lightText,
            ),
            splashRadius: 24,
          ),
          Image.asset(
            isDarkMode 
                ? 'lib/assets/logos/MainDarkLogo.png.png' 
                : 'lib/assets/logos/MainLightLogo.png.png',
            height: 28,
            errorBuilder: (context, error, stackTrace) {
              // Fallback if asset path differs slightly in your local env
              return Text(
                'NobleCards',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                ),
              );
            },
          ),
          const SizedBox(width: 48), // Balance for the back button
        ],
      ),
    );
  }
}