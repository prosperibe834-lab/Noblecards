import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noble_cards/theme/app_radius.dart';

class NotificationCategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;
  final int? count;

  const NotificationCategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final unselectedBg = isDark ? const Color(0xFF121E27) : Colors.white;
    final unselectedBorder = isDark ? const Color(0xFF1E313D) : const Color(0xFFE2E8F0);
    final unselectedTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF00D084), Color(0xFF00A86B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : unselectedBg,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(
            color: isSelected ? Colors.transparent : unselectedBorder,
            width: 1.1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF00D084).withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : unselectedTextColor,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : unselectedTextColor,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                fontSize: 13,
                letterSpacing: -0.2,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.25)
                      : (isDark
                          ? const Color(0xFF1E313D)
                          : const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : unselectedTextColor,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class CategoryMatrixTile extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryMatrixTile({
    super.key,
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBg = isDark
        ? (isSelected ? const Color(0xFF142728) : const Color(0xFF121E27))
        : (isSelected ? const Color(0xFFE8FDF3) : Colors.white);

    final borderColor = isSelected
        ? const Color(0xFF00D084)
        : (isDark ? const Color(0xFF1E313D) : const Color(0xFFE2E8F0));

    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 1.5 : 1.1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFF00D084).withValues(alpha: isDark ? 0.22 : 0.15)
                  : Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
              blurRadius: isSelected ? 10 : 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Colored Squircle Icon
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withValues(alpha: isDark ? 0.2 : 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: color.withValues(alpha: 0.35),
                  width: 1,
                ),
              ),
              child: Center(
                child: Icon(icon, color: color, size: 17),
              ),
            ),
            const SizedBox(height: 5),

            // Category Label
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? const Color(0xFF00D084) : textColor,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 2),

            // Count Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: color.withValues(alpha: isDark ? 0.25 : 0.12),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: color,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

