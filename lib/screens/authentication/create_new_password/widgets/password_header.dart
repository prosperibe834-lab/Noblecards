import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';

class PasswordHeader extends StatefulWidget {
  const PasswordHeader({super.key});

  @override
  State<PasswordHeader> createState() => _PasswordHeaderState();
}

class _PasswordHeaderState extends State<PasswordHeader> with SingleTickerProviderStateMixin {
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
        const SizedBox(height: 24),
        
        Text(
          'Create New Password',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 12),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            'Your new password must be different\nfrom previous used passwords.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ),
        const SizedBox(height: 32),

        // Animated Security Illustration matching the reference
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 + (_pulseController.value * 0.05),
              child: child,
            );
          },
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark 
                  ? AppColors.primary.withOpacity(0.1) 
                  : AppColors.successLight.withOpacity(0.15),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Inner solid circle
                Container(
                  width: 65,
                  height: 65,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                ),
                // Lock Icon
                const Positioned(
                  top: 22,
                  child: Icon(
                    Boxicons.bx_lock_alt,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                // Asterisks
                const Positioned(
                  bottom: 24,
                  child: Text(
                    '*****',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                // Small decorative dots
                Positioned(top: 10, left: 10, child: _buildDot(isDark)),
                Positioned(bottom: 15, right: 10, child: _buildDot(isDark)),
                Positioned(top: 20, right: 15, child: _buildDot(isDark)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDot(bool isDark) {
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryDark : AppColors.success,
        shape: BoxShape.circle,
      ),
    );
  }
}