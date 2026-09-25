import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_animation.dart';

class AnalyticsPeriodSelector extends StatelessWidget {
  final String selectedPeriod;
  final Function(String) onPeriodSelected;

  const AnalyticsPeriodSelector({
    Key? key,
    required this.selectedPeriod,
    required this.onPeriodSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final periods = ['7D', '30D', '3M', '6M', '1Y'];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        children: periods.map((period) {
          final isSelected = selectedPeriod == period;
          return Expanded(
            child: GestureDetector(
              onTap: () => onPeriodSelected(period),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: AppAnimation.fast,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                alignment: Alignment.center,
                child: Text(
                  period,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.white
                        : (isDark ? AppColors.darkSubText : AppColors.lightSubText),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 13,
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