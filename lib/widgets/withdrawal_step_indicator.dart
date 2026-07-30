import 'package:flutter/material.dart';

class WithdrawalStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const WithdrawalStepIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 5,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = (currentStep + 1) / totalSteps;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Step ${currentStep + 1} of $totalSteps",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            Text(
              "${(progress * 100).toInt()}% Completed",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: theme.primaryColor.withOpacity(0.12),
            valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
          ),
        ),
      ],
    );
  }
}