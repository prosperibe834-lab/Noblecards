import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_shadow.dart';

class AccountLevelCard extends StatelessWidget {
  const AccountLevelCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: Navigate to Tier Benefits
      },
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          gradient: const LinearGradient(
            colors: [Color(0xFF0F9B0F), Color(0xFF0A6C0A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: AppShadow.light,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Gold Badge Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Boxicons.bxs_medal, color: Color(0xFFFFD700), size: 32),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Account Level',
                      style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Gold',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'Daily Limit',
                  style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                const Text(
                  '\$10,000',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Text(
                      'View Benefits',
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 4),
                    Icon(Boxicons.bx_chevron_right, color: Colors.white, size: 14),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}