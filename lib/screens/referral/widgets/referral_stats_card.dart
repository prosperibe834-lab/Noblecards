import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class ReferralStatsCard extends StatelessWidget {
  final int invited;
  final int qualified;
  final double earned;

  const ReferralStatsCard({
    Key? key,
    required this.invited,
    required this.qualified,
    required this.earned,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final dividerColor = isDark ? Colors.grey[800] : Colors.grey[200];
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: dividerColor!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            icon: Boxicons.bxs_group,
            title: 'Friends Invited',
            value: invited.toString(),
            textColor: textColor,
            subTextColor: subTextColor!,
          ),
          Container(width: 1, height: 40, color: dividerColor),
          _buildStatItem(
            icon: Boxicons.bxs_user_check,
            title: 'Qualified Friends',
            value: qualified.toString(),
            textColor: textColor,
            subTextColor: subTextColor,
          ),
          Container(width: 1, height: 40, color: dividerColor),
          _buildStatItem(
            icon: Boxicons.bxs_briefcase,
            title: 'Rewards Earned',
            value: '\$${earned.toStringAsFixed(2)}',
            textColor: textColor,
            subTextColor: subTextColor,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String title,
    required String value,
    required Color textColor,
    required Color subTextColor,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF00B94A), size: 16),
            const SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(color: subTextColor, fontSize: 11),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}