import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';

class BuySubmissionActionButtons extends StatelessWidget {
  final VoidCallback onViewGiftCard;
  final VoidCallback onViewReceipt;
  final VoidCallback onDone;

  const BuySubmissionActionButtons({
    super.key,
    required this.onViewGiftCard,
    required this.onViewReceipt,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Button 1: Primary - View Gift Card
        _buildActionButton(
          context,
          label: 'View Gift Card',
          icon: Boxicons.bx_credit_card_front,
          isPrimary: true,
          onTap: onViewGiftCard,
        ),
        
        const SizedBox(height: 12),
        
        // Button 2: Secondary / Outlined - View Receipt
        _buildActionButton(
          context,
          label: 'View Receipt',
          icon: Boxicons.bx_receipt,
          isPrimary: false,
          onTap: onViewReceipt,
        ),
        
        const SizedBox(height: 12),
        
        // Button 3: Text / Ghost - Done
        _buildActionButton(
          context,
          label: 'Done',
          icon: Boxicons.bx_check_circle,
          isPrimary: false,
          isGhost: true,
          onTap: onDone,
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool isPrimary,
    required VoidCallback onTap,
    bool isGhost = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Color Logic strictly mapping to requested theme layout
    final bg = isPrimary 
        ? AppColors.success 
        : (isGhost ? Colors.transparent : (isDark ? AppColors.darkCard : AppColors.white));
        
    final textColor = isPrimary 
        ? Colors.white 
        : (isDark ? Colors.white : Colors.black);
        
    final borderColor = isPrimary 
        ? Colors.transparent 
        : (isGhost 
            ? (isDark ? Colors.white10 : Colors.black.withOpacity(0.05)) 
            : (isDark ? Colors.white24 : Colors.black12));

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        splashColor: isPrimary ? Colors.white24 : AppColors.success.withOpacity(0.1),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: textColor, size: 20),
              const SizedBox(width: 8),
              Text(
                label, 
                style: TextStyle(
                  fontSize: 15, 
                  fontWeight: FontWeight.w600, 
                  color: textColor
                )
              ),
              if (isPrimary || !isGhost) ...[
                 const SizedBox(width: 8),
                 Icon(Boxicons.bx_chevron_right, color: textColor, size: 18),
              ]
            ],
          ),
        ),
      ),
    );
  }
}