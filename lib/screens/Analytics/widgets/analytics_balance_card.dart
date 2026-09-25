import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_animation.dart';

class AnalyticsBalanceCard extends StatelessWidget {
  final double balance;
  final double changePercent;
  final String periodLabel;
  final bool isVisible;
  final VoidCallback onToggleVisibility;

  const AnalyticsBalanceCard({
    Key? key,
    required this.balance,
    required this.changePercent,
    required this.periodLabel,
    required this.isVisible,
    required this.onToggleVisibility,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF059669), // Rich Emerald Green
            Color(0xFF0D9488), // Teal Transition
            Color(0xFF2563EB), // Deep Royal Blue
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.35),
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Total Balance',
                    style: TextStyle(
                      color: AppColors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  GestureDetector(
                    onTap: onToggleVisibility,
                    child: AnimatedSwitcher(
                      duration: AppAnimation.fast,
                      child: Icon(
                        isVisible ? Boxicons.bx_show : Boxicons.bx_hide,
                        key: ValueKey(isVisible),
                        color: AppColors.white70,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  AnimatedSwitcher(
                    duration: AppAnimation.normal,
                    child: Text(
                      isVisible ? '\$${balance.toStringAsFixed(2)}' : '••••••••',
                      key: ValueKey(isVisible),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppRadius.xs),
                    ),
                    child: const Text(
                      'USD',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Boxicons.bx_up_arrow_alt, color: AppColors.white, size: 14),
                        const SizedBox(width: 2),
                        Text(
                          '+${changePercent.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    periodLabel,
                    style: const TextStyle(
                      color: AppColors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // 3D Visual NobleCards Logo Container matching reference
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: Transform.rotate(
                angle: 0.15,
                child: Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: Colors.white.withOpacity(0.35), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'N',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: AppColors.white,
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