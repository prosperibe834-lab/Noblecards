import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class LanguageSearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const LanguageSearchField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF141A21) : const Color(0xFFF5F6F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
        ),
      ),
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 16),
        decoration: InputDecoration(
          hintText: "Search languages...",
          hintStyle: TextStyle(
            color: isDark ? Colors.white54 : Colors.black45,
            fontSize: 16,
          ),
          prefixIcon: Icon(
            Boxicons.bx_search,
            color: isDark ? Colors.white54 : Colors.black45,
            size: 24,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}