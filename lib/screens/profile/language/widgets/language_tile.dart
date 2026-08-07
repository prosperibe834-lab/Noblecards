import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../models/language_model.dart';

class LanguageTile extends StatelessWidget {
  final LanguageModel language;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageTile({
    super.key,
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: const Color(0xFF00C853).withOpacity(0.1),
          highlightColor: const Color(0xFF00C853).withOpacity(0.05),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: isSelected
                  ? (isDark ? const Color(0xFF00C853).withOpacity(0.1) : const Color(0xFFE8F7ED))
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF00C853).withOpacity(0.5)
                    : Colors.transparent,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Text(language.flag, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    language.name,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: isSelected
                      ? const Icon(
                          Boxicons.bxs_check_circle,
                          key: ValueKey('selected'),
                          color: Color(0xFF00C853),
                          size: 24,
                        )
                      : Icon(
                          Boxicons.bx_circle,
                          key: const ValueKey('unselected'),
                          color: isDark ? Colors.white24 : Colors.black26,
                          size: 24,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}