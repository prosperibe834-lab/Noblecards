import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';

class ResetPasswordBackground extends StatelessWidget {
  final Widget child;

  const ResetPasswordBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        // Base Background Color
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        
        // Top Right Dotted/Gradient Blob Overlay
        Positioned(
          top: -100,
          right: -50,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primary.withOpacity(isDark ? 0.1 : 0.05),
                  Colors.transparent,
                ],
                stops: const [0.2, 1.0],
              ),
            ),
          ),
        ),

        // Bottom Left Deep Green Dotted/Gradient Overlay
        Positioned(
          bottom: -100,
          left: -80,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primaryDark.withOpacity(isDark ? 0.15 : 0.05),
                  Colors.transparent,
                ],
                stops: const [0.1, 1.0],
              ),
            ),
          ),
        ),

        // Main Content Layer
        SafeArea(child: child),
      ],
    );
  }
}