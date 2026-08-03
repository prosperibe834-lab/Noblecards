import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:noble_cards/theme/app_animation.dart';
import 'package:noble_cards/theme/app_colors.dart';
import 'package:noble_cards/theme/app_radius.dart';
import 'package:noble_cards/theme/app_spacing.dart';
import '../providers/region_provider.dart';

class RegionSelectorCard extends StatelessWidget {
  final VoidCallback onTap;

  const RegionSelectorCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subTextColor = isDark ? AppColors.darkSubText : AppColors.lightSubText;

    return Consumer<RegionProvider>(
      builder: (context, provider, child) {
        final region = provider.selectedRegion;

        return AnimatedContainer(
          duration: AppAnimation.fast,
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Text(
                        region?.flag ?? '🌍',
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: AppAnimation.fast,
                        child: region == null
                            ? const SizedBox.shrink(key: ValueKey('loading'))
                            : Column(
                                key: ValueKey(region.id),
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    region.countryName,
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${region.currencyCode} (${region.currencySymbol})',
                                    style: TextStyle(color: subTextColor, fontSize: 12),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down_rounded, color: subTextColor),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
} 
