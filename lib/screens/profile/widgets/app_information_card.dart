import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';

class AppInformationCard extends StatelessWidget {
  const AppInformationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'App Information',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "You're using the latest version",
              style: TextStyle(
                fontSize: 11,
                color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              'Up to date',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.success,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Boxicons.bx_check_circle,
              color: AppColors.success,
              size: 20,
            ),
          ],
        ),
      ],
    );
  }
}