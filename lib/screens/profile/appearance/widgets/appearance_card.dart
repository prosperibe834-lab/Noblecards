import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';
import '../models/appearance_option.dart';
import 'theme_preview_widget.dart';

class AppearanceCard extends StatelessWidget {
  final ThemeOption option;
  final bool isSelected;
  final VoidCallback onTap;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final bool isRecommended;

  const AppearanceCard({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    this.isRecommended = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? AppColors.success.withOpacity(0.08)
                  : AppColors.success.withOpacity(0.05))
              : (isDark ? AppColors.darkCard : AppColors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.success
                : (isDark ? Colors.white10 : Colors.black.withOpacity(0.04)),
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.success.withOpacity(0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  )
                ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 14),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  if (isRecommended) ...[
                    const SizedBox(height: 2),
                    Text(
                      '(Recommended)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.3,
                      color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // Mini App Preview
            ThemePreviewWidget(themeType: option),
            const SizedBox(width: 16),

            // Selection Indicator
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: isSelected
                  ? const Icon(
                      Boxicons.bxs_check_circle,
                      key: ValueKey('checked'),
                      color: AppColors.success,
                      size: 24,
                    )
                  : Icon(
                      Boxicons.bx_circle,
                      key: const ValueKey('unchecked'),
                      color: isDark ? Colors.white24 : Colors.grey.shade300,
                      size: 24,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}