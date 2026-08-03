import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';

class BuySellButtons extends StatelessWidget {
  final VoidCallback onBuy;
  final VoidCallback onSell;

  const BuySellButtons({
    super.key,
    required this.onBuy,
    required this.onSell,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onBuy,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: AppColors.accentViolet,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
            child: const Text(
              'Buy',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton(
            onPressed: onSell,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.accentViolet),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
            child: const Text(
              'Sell',
              style: TextStyle(
                color: AppColors.accentViolet,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}