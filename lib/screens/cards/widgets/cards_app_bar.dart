import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';

class CardsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CardsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      titleSpacing: AppSpacing.m,
      title: RichText(
        text: TextSpan(
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
          children: const [
            TextSpan(text: 'Noble'),
            TextSpan(
              text: 'Cards',
              style: TextStyle(color: AppColors.accentViolet),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Favorites screen placeholder')),
            );
          },
          icon: Icon(
            Icons.favorite_outline_rounded,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notifications screen placeholder')),
                );
              },
              icon: Icon(
                Icons.notifications_none_rounded,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.accentViolet,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: AppSpacing.xs),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}