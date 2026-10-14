import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class ReferralProgress extends StatelessWidget {
  final int current;
  final int target;

  const ReferralProgress({
    super.key,
    required this.current,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final borderColor = isDark ? Colors.grey[800]! : Colors.grey[200]!;

    final progress = target == 0 ? 0.0 : (current / target).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Referral Progress',
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$current / $target Invited',
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF00B94A),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  target == 0
                      ? 'Invite a friend to get started'
                      : '$current of your invited ${target == 1 ? 'friend has' : 'friends have'} qualified',
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ),
              Icon(Boxicons.bxs_gift, color: const Color(0xFF00B94A), size: 20),
            ],
          ),
        ],
      ),
    );
  }
}
