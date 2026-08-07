import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class EmptyLanguageWidget extends StatelessWidget {
  const EmptyLanguageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: TweenAnimationBuilder(
        duration: const Duration(milliseconds: 500),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, double value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Boxicons.bx_search_alt,
                      size: 64,
                      color: isDark ? Colors.white54 : Colors.black38,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "No language found",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Try searching for another language",
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white54 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}