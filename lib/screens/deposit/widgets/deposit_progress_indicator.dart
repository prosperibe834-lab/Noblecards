// Location: lib/deposit/widgets/deposit_progress_indicator.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/theme_provider.dart';

class DepositProgressIndicator extends StatelessWidget {
  final int currentStep;

  const DepositProgressIndicator({
    super.key,
    this.currentStep = 2,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isStep1Completed = currentStep > 1;
    final isStep1Active = currentStep >= 1;

    final isStep2Completed = currentStep > 2;
    final isStep2Active = currentStep >= 2;

    final isStep3Completed = currentStep > 3;
    final isStep3Active = currentStep >= 3;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      child: Row(
        children: [
          // Step 1: Amount
          _buildStep(
            context,
            'Amount',
            stepNumber: '1',
            isActive: isStep1Active,
            isCompleted: isStep1Completed,
            isDark: isDark,
          ),
          _buildLine(isActive: isStep1Completed, isDark: isDark),

          // Step 2: Method
          _buildStep(
            context,
            'Method',
            stepNumber: '2',
            isActive: isStep2Active,
            isCompleted: isStep2Completed,
            isDark: isDark,
          ),
          _buildLine(isActive: isStep2Completed, isDark: isDark),

          // Step 3: Confirm
          _buildStep(
            context,
            'Confirm',
            stepNumber: '3',
            isActive: isStep3Active,
            isCompleted: isStep3Completed,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildStep(
    BuildContext context,
    String label, {
    String? stepNumber,
    required bool isActive,
    required bool isCompleted,
    required bool isDark,
  }) {
    const Color activeColor = AppColors.primary;
    final Color inactiveBgColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final Color inactiveTextColor = isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8);

    return Row(
      mainAxisSize: MainAxisSize.min,
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
                ? const Icon(Icons.check, color: Colors.white, size: 15)
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
        const SizedBox(width: AppSpacing.xs + 2),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? (isDark ? Colors.white : AppColors.lightText) : inactiveTextColor,
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
            ? AppColors.primary
            : (isDark ? const Color(0xFF263545) : const Color(0xFFE2E8F0)),
      ),
    );
  }
}
