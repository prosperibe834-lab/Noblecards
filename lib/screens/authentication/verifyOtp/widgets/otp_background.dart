import 'package:flutter/material.dart';
import '../../../../../theme/app_colors.dart';

class OtpBackground extends StatelessWidget {
  final Widget child;

  const OtpBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        Container(color: Theme.of(context).scaffoldBackgroundColor),
        
        // Top Right Glow matching the reference
        Positioned(
          top: -100,
          right: -80,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primaryDark.withOpacity(isDark ? 0.25 : 0.08),
                  Colors.transparent,
                ],
                stops: const [0.2, 1.0],
              ),
            ),
          ),
        ),

        // Bottom Left Glow
        Positioned(
          bottom: -120,
          left: -100,
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primary.withOpacity(isDark ? 0.15 : 0.05),
                  Colors.transparent,
                ],
                stops: const [0.2, 1.0],
              ),
            ),
          ),
        ),

        // Small decorative dots pattern placeholder
        Positioned(
          top: 80,
          right: 20,
          child: _buildDotPattern(isDark),
        ),
        
        Positioned(
          bottom: 40,
          left: 20,
          child: _buildDotPattern(isDark),
        ),

        // Content
        SafeArea(child: child),
      ],
    );
  }

  Widget _buildDotPattern(bool isDark) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      direction: Axis.vertical,
      children: List.generate(
        15,
        (index) => Container(
          width: 3,
          height: 3,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(isDark ? 0.1 : 0.05),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}