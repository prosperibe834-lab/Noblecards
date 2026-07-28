import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class ReceiptFooter extends StatelessWidget {
  final String supportEmail;
  final String supportPhone;

  const ReceiptFooter({
    Key? key,
    this.supportEmail = 'support@noblecards.com',
    this.supportPhone = '+1 (800) 892-0192',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        const Divider(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Boxicons.bx_lock_alt, size: 14, color: isDark ? Colors.grey[400] : Colors.grey[600]),
            const SizedBox(width: 6),
            Text(
              'Official Electronic Receipt • NobleCards Inc.',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Support: $supportEmail | $supportPhone',
          style: TextStyle(
            fontSize: 11,
            color: isDark ? Colors.grey[500] : Colors.grey[500],
          ),
        ),
      ],
    );
  }
}