import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../models/language_model.dart';

class CurrentLanguageCard extends StatelessWidget {
  final LanguageModel language;

  const CurrentLanguageCard({super.key, required this.language});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF06301A), const Color(0xFF0F1A15)]
              : [const Color(0xFFE8F7ED), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: isDark ? const Color(0xFF00C853).withOpacity(0.1) : Colors.black.withOpacity(0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Current Language",
                  style: TextStyle(
                    color: const Color(0xFF00C853),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  language.name,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00C853).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Default",
                    style: TextStyle(
                      color: Color(0xFF00C853),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Glowing Background
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF00C853).withOpacity(0.1),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00C853).withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                ),
                // Globe Icon
                const Icon(
                  Boxicons.bx_globe,
                  color: Color(0xFF00C853),
                  size: 60,
                ),
                // Particles
                Positioned(
                  top: 0,
                  right: 10,
                  child: Icon(Boxicons.bxs_star, color: const Color(0xFF00C853).withOpacity(0.6), size: 10),
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  child: Icon(Boxicons.bxs_star, color: const Color(0xFF00C853).withOpacity(0.8), size: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}