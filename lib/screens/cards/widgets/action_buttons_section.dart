import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../sell_receipt_screen.dart';

class ActionButtonsSection extends StatelessWidget {
  const ActionButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildButton(
          context,
          icon: Boxicons.bx_receipt,
          label: 'View Receipt',
          isPrimary: true,
          showChevron: true,
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SellReceiptScreen(transactionId: 'sale-submission-001'),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildButton(
          context,
          icon: Boxicons.bx_box,
          label: 'View Orders',
          isPrimary: false,
          showChevron: true,
          onTap: () {
            HapticFeedback.lightImpact();
            // Navigator.push(context, MaterialPageRoute(builder: (_) => OrdersScreen()));
          },
        ),
        const SizedBox(height: 12),
        _buildButton(
          context,
          icon: Boxicons.bx_check_circle,
          label: 'Done',
          isPrimary: false,
          isGhost: true,
          showChevron: false,
          onTap: () {
            HapticFeedback.mediumImpact();
            Navigator.popUntil(context, (route) => route.isFirst); // Returns to root
          },
        ),
      ],
    );
  }

  Widget _buildButton(BuildContext context, {
    required IconData icon,
    required String label,
    required bool isPrimary,
    required VoidCallback onTap,
    bool showChevron = false,
    bool isGhost = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final bg = isPrimary ? AppColors.success : (isGhost ? Colors.transparent : (isDark ? AppColors.darkCard : AppColors.white));
    final textColor = isPrimary ? Colors.white : (isDark ? Colors.white : Colors.black);
    final borderColor = isPrimary ? Colors.transparent : (isGhost ? (isDark ? Colors.white24 : Colors.black12) : (isDark ? AppColors.darkBorder : AppColors.lightBorder));

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      splashColor: isPrimary ? Colors.white24 : AppColors.success.withValues(alpha: 0.1),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!showChevron || isGhost) const Spacer(),
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textColor),
            ),
            if (showChevron) ...[
              const Spacer(),
              Icon(Boxicons.bx_chevron_right, color: textColor.withValues(alpha: 0.7), size: 20),
            ] else const Spacer(),
          ],
        ),
      ),
    );
  }
}