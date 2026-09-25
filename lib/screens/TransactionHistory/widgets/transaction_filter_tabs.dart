import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_theme.dart';
import '../../../theme/app_animation.dart';

class TransactionFilterTabs extends StatelessWidget {
  final String activeTab;
  final Function(String) onTabChanged;

  const TransactionFilterTabs({
    Key? key,
    required this.activeTab,
    required this.onTabChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tabs = ['All', 'Deposits', 'Withdrawals'];
    
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        children: tabs.map((tab) {
          final isActive = activeTab == tab;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(tab),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: AppAnimation.fast,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                alignment: Alignment.center,
                child: Text(
                  tab,
                  style: AppTextTheme.light.bodyMedium?.copyWith(
                    color: isActive 
                        ? AppColors.white 
                        : (isDark ? AppColors.darkSubText : AppColors.lightSubText),
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}