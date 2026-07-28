import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class FavoriteCurrencyChip extends StatelessWidget {
  final String code;
  final String flag;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const FavoriteCurrencyChip({
    super.key,
    required this.code,
    required this.flag,
    required this.isSelected,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 8),
      child: Material(
        color: isSelected
            ? primaryColor
            : (isDark ? Colors.white.withOpacity(0.08) : Colors.white),
        borderRadius: BorderRadius.circular(25),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: isSelected
                    ? primaryColor
                    : (isDark ? Colors.white12 : Colors.black12),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(flag, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Text(
                  code,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.white : Colors.black87),
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 4),
                  const Icon(Boxicons.bx_check, size: 16, color: Colors.white),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}