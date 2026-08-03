import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class AvailabilityBadge extends StatelessWidget {
  final bool isAvailable;

  const AvailabilityBadge({super.key, this.isAvailable = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: (isAvailable ? AppColors.success : AppColors.error).withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isAvailable ? AppColors.success : AppColors.error,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            isAvailable ? 'Available' : 'Out of stock',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: isAvailable ? AppColors.success : AppColors.error,
            ),
          ),
        ],
      ),
    );
  }
}