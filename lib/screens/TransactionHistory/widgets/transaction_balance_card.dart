import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_theme.dart';
import '../../../theme/app_animation.dart';

class TransactionBalanceCard extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onToggleVisibility;
  final double balance;

  const TransactionBalanceCard({
    Key? key,
    required this.isVisible,
    required this.onToggleVisibility,
    required this.balance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Total Balance',
                    style: AppTextTheme.light.bodyMedium?.copyWith(
                      color: AppColors.white70,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onToggleVisibility,
                    child: AnimatedSwitcher(
                      duration: AppAnimation.fast,
                      child: Icon(
                        isVisible ? Boxicons.bx_show : Boxicons.bx_hide,
                        key: ValueKey(isVisible),
                        color: AppColors.white70,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AnimatedSwitcher(
                    duration: AppAnimation.normal,
                    child: Text(
                      isVisible ? '\$${balance.toStringAsFixed(2)}' : '••••••••',
                      key: ValueKey(isVisible),
                      style: AppTextTheme.light.headlineLarge?.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      'USD',
                      style: AppTextTheme.light.bodyMedium?.copyWith(
                        color: AppColors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Available Balance',
                style: AppTextTheme.light.bodyMedium?.copyWith(
                  color: AppColors.white70,
                ),
              ),
            ],
          ),
          // Decorative Abstract NobleCards Logo
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: Transform.rotate(
                angle: 0.2,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
                  ),
                  child: const Center(
                    child: Text(
                      'N',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}