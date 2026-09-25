import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';

class AnalyticsErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const AnalyticsErrorState({Key? key, required this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            const Icon(Boxicons.bx_error_circle, size: 56, color: AppColors.error),
            const SizedBox(height: AppSpacing.sm),
            const Text('Failed to load analytics', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: onRetry,
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}