import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'package:noble_cards/theme/app_colors.dart';
import 'package:noble_cards/theme/app_radius.dart';
import 'package:noble_cards/theme/app_spacing.dart';
import 'package:noble_cards/theme/app_animation.dart';

class VerificationNotice extends StatelessWidget {
  final bool accepted;
  final ValueChanged<bool> onChanged;

  const VerificationNotice({super.key, required this.accepted, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.15),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: AppAnimation.normal,
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
            ),
            child: const Icon(Boxicons.bx_shield_alt_2, color: Colors.white, size: 28),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('I understand that every submitted gift card will be verified by NobleCards before approval.', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                SizedBox(height: AppSpacing.xs),
                Text('Processing time may vary depending on the verification result.', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          GestureDetector(
            onTap: () => onChanged(!accepted),
            child: AnimatedContainer(
              duration: AppAnimation.fast,
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accepted ? Colors.white : Colors.transparent,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: accepted ? const Icon(Icons.check, color: Color(0xFF059669), size: 18) : null,
            ),
          ),
        ],
      ),
    );
  }
}
