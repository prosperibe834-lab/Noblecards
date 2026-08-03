import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boxicons/boxicons.dart';
import 'package:noble_cards/theme/app_colors.dart';
import 'package:noble_cards/theme/app_radius.dart';

class ContinuePaymentButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ContinuePaymentButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.md),
          onTap: () {
            HapticFeedback.mediumImpact();
            onPressed();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Boxicons.bx_lock_alt, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Continue to Payment', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              SizedBox(width: 8),
              Icon(Boxicons.bx_right_arrow_alt, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
