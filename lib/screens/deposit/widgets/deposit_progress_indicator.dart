// Location: lib/deposit/widgets/deposit_progress_indicator.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/theme_provider.dart';

class DepositProgressIndicator extends StatelessWidget {
  const DepositProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      child: Row(
        children: [
          // Step 1: Amount (Completed)
          _buildStep(context, 'Amount', isActive: true, isCompleted: true, isDark: isDark),
          _buildLine(isActive: true, isDark: isDark),
          
          // Step 2: Method (Active)
          _buildStep(context, 'Method', stepNumber: '2', isActive: true, isCompleted: false, isDark: isDark),
          _buildLine(isActive: false, isDark: isDark),
          
          // Step 3: Confirm (Pending)
          _buildStep(context, 'Confirm', stepNumber: '3', isActive: false, isCompleted: false, isDark: isDark),
        ],
      ),
    );
  }

  Widget _buildStep(BuildContext context, String label, {String? stepNumber, required bool isActive, required bool isCompleted, required bool isDark}) {
    final Color activeColor = AppColors.primary;
    final Color inactiveBgColor = isDark ? AppColors.darkCard : AppColors.lightBorder;
    final Color inactiveTextColor = isDark ? AppColors.darkSubText : AppColors.lightSubText;

    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveBgColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : Text(
                    stepNumber ?? '',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isActive ? Colors.white : inactiveTextColor,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? activeColor : inactiveTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildLine({required bool isActive, required bool isDark}) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        color: isActive 
            ? AppColors.primary.withOpacity(0.5) 
            : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
    );
  }
}
