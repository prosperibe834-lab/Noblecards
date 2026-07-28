import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../theme/app_colors.dart';

class AnalyticsQuickActions extends StatelessWidget {
  const AnalyticsQuickActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _btn(context, Boxicons.bx_plus_circle, 'Deposit'),
        _btn(context, Boxicons.bx_minus_circle, 'Withdraw'),
        _btn(context, Boxicons.bx_refresh, 'Trade Cards'),
        _btn(context, Boxicons.bx_share_alt, 'Share'),
      ],
    );
  }

  Widget _btn(BuildContext ctx, IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }
}