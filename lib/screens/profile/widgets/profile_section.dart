import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';

class ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Color? titleColor;

  const ProfileSection({
    super.key,
    required this.title,
    required this.children,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: titleColor ?? (isDark ? Colors.white : Colors.black87),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.04)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final Color? trailingTextColor;
  final Color? iconColor;
  final Color? textColor;
  final bool showBorder;
  final bool hideChevron;
  final VoidCallback onTap;

  const ProfileTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailingText,
    this.trailingTextColor,
    this.iconColor,
    this.textColor,
    this.showBorder = true,
    this.hideChevron = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultIconColor = isDark ? AppColors.success : AppColors.success; 
    // ^ Assuming your standard list icon color is the primary/success color based on the design.

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: showBorder
              ? Border(
                  bottom: BorderSide(
                    color: isDark ? Colors.white10 : Colors.grey.shade100,
                    width: 1,
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? defaultIconColor, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? (isDark ? Colors.white : Colors.black87),
                ),
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText!,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: trailingTextColor ?? (isDark ? Colors.white70 : Colors.black54),
                ),
              ),
              const SizedBox(width: 8),
            ],
            if (!hideChevron)
              Icon(
                Boxicons.bx_chevron_right,
                color: isDark ? Colors.white30 : Colors.black38,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}