import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';

class ReceiptDetailTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final Widget? customValueWidget;
  final bool isHighlighted;
  final bool isGreen;

  const ReceiptDetailTile({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.customValueWidget,
    this.isHighlighted = false,
    this.isGreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.success),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
            ],
          ),
          if (customValueWidget != null)
            customValueWidget!
          else
            Text(
              value ?? '',
              style: TextStyle(
                fontSize: 13,
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w600,
                color: isGreen 
                    ? AppColors.success 
                    : (isDark ? Colors.white : Colors.black),
              ),
            ),
        ],
      ),
    );
  }
}