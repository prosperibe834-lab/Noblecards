// Where to paste: lib/screens/notification/widgets/notification_banner.dart

import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class NotificationBanner extends StatelessWidget {
  final VoidCallback onMarkAllRead;

  const NotificationBanner({super.key, required this.onMarkAllRead});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF062D19), const Color(0xFF0B1B15)]
              : [const Color(0xFFEBF9F0), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: isDark ? const Color(0xFF00C853).withOpacity(0.12) : Colors.black.withOpacity(0.04),
        ),
      ),
      child: Row(
        children: [
          // Bell Graphic
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF00C853).withOpacity(0.15),
            ),
            child: const Center(
              child: Icon(Boxicons.bxs_bell_ring, color: Color(0xFF00C853), size: 24),
            ),
          ),
          const SizedBox(width: 14),
          // Text Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Stay updated",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "We'll notify you about important updates and activities.",
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white54 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}