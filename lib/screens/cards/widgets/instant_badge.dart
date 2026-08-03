import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class InstantBadge extends StatelessWidget {
  const InstantBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.accentViolet.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flash_on_rounded, size: 10, color: AppColors.accentViolet),
          SizedBox(width: 2),
          Text(
            'Instant',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: AppColors.accentViolet,
            ),
          ),
        ],
      ),
    );
  }
}