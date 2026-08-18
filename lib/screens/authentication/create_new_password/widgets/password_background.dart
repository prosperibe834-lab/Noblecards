import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';

class PasswordBackground extends StatelessWidget {
  final Widget child;

  const PasswordBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        Container(color: Theme.of(context).scaffoldBackgroundColor),
        
        // Top Right Glow matching "ChatGPT Image Aug 17, 2026, 03_46_46 PM.png"
        Positioned(
          top: -80,
          right: -80,
          child: Container(
            width: 250,
            height: 250,
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
          bottom: -100,
          left: -100,
          child: Container(
            width: 300,
            height: 300,
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

        // Content
        SafeArea(child: child),
      ],
    );
  }
}