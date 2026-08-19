import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../../theme/app_colors.dart';

class OtpHeader extends StatefulWidget {
  final String email;

  const OtpHeader({super.key, required this.email});

  @override
  State<OtpHeader> createState() => _OtpHeaderState();
}

class _OtpHeaderState extends State<OtpHeader> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String _maskEmail(String email) {
    if (!email.contains('@')) return email;
    final parts = email.split('@');
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 4) return email;
    return '${name.substring(0, 4)}*****@$domain';
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Logo Integration
        Center(
          child: Image.asset(
            isDark 
                ? 'lib/assets/logos/MainDarkLogo.png.png' 
                : 'lib/assets/logos/MainLightLogo.png.png',
            height: 48,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Boxicons.bx_wallet_alt, size: 48, color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Animated Envelope Illustration matching the reference
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 + (_pulseController.value * 0.05),
              child: child,
            );
          },
          child: Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark 
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : AppColors.successLight.withValues(alpha: 0.15),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Inner solid circle
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? AppColors.primaryDark : AppColors.primary,
                  ),
                  child: const Center(
                    child: Icon(
                      Boxicons.bx_envelope,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
                // Security Shield Badge
                Positioned(
                  top: 25,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.lightCard,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Boxicons.bx_check_shield,
                      color: isDark ? AppColors.primary : AppColors.success,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        Text(
          'Verify OTP',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 12),
        
        Text(
          'Enter the 6-digit code we sent to\n${_maskEmail(widget.email)}',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            height: 1.5,
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}