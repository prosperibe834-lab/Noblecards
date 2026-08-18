import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';

class LoginBackground extends StatelessWidget {
  final Widget child;

  const LoginBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        // Background Color
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        
        // Top Right Fintech Gradient Blob
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primary.withOpacity(isDark ? 0.15 : 0.1),
                  Colors.transparent,
                ],
                stops: const [0.2, 1.0],
              ),
            ),
          ),
        ),

        // Bottom Left Fintech Gradient Blob
        Positioned(
          bottom: -100,
          left: -100,
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primaryDark.withOpacity(isDark ? 0.2 : 0.15),
                  Colors.transparent,
                ],
                stops: const [0.2, 1.0],
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