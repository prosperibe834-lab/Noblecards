import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';

class GiftCardSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final VoidCallback onFilterTap;
  final bool isDark;

  const GiftCardSearchBar({
    Key? key,
    required this.controller,
    required this.onChanged,
    required this.onFilterTap,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            style: TextStyle(color: isDark ? AppColors.darkText : AppColors.lightText),
            decoration: InputDecoration(
              hintText: 'Search for brands (e.g. Amazon, Apple...)',
              hintStyle: TextStyle(color: isDark ? AppColors.darkSubText : AppColors.lightSubText, fontSize: 14),
              prefixIcon: Icon(Boxicons.bx_search, color: isDark ? AppColors.darkSubText : AppColors.lightSubText),
              filled: true,
              fillColor: isDark ? AppColors.darkInput : AppColors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.full),
                borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.full),
                borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        InkWell(
          onTap: onFilterTap,
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.s),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkInput : AppColors.white,
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              shape: BoxShape.circle,
            ),
            child: Icon(Boxicons.bx_slider_alt, color: isDark ? AppColors.darkText : AppColors.lightText),
          ),
        ),
      ],
    );
  }
}