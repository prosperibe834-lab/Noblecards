import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';

class ForgotPasswordBackground extends StatelessWidget {
  final Widget child;

  const ForgotPasswordBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        // Base Theme Background
        Container(color: Theme.of(context).scaffoldBackgroundColor),

        // Top Right Organic Glow
        Positioned(
          top: -80,
          right: -80,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primary.withOpacity(isDark ? 0.22 : 0.12),
                  Colors.transparent,
                ],
                stops: const [0.2, 1.0],
              ),
            ),
          ),
        ),

        // Bottom Left Organic Glow
        Positioned(
          bottom: -100,
          left: -80,
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primaryDark.withOpacity(isDark ? 0.18 : 0.08),
                  Colors.transparent,
                ],
                stops: const [0.2, 1.0],
              ),
            ),
          ),
        ),

        // Top-Right Dotted Pattern Matrix
        Positioned(
          top: 70,
          right: 16,
          child: _buildDotGrid(isDark),
        ),

        // Bottom-Left Dotted Pattern Matrix
        Positioned(
          bottom: 30,
          left: 16,
          child: _buildDotGrid(isDark),
        ),

        // Foreground Content
        SafeArea(child: child),
      ],
    );
  }

  Widget _buildDotGrid(bool isDark) {
    final Color dotColor = AppColors.primary.withOpacity(isDark ? 0.25 : 0.15);
    return SizedBox(
      width: 70,
      height: 70,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: 25,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          );
        },
      ),
    );
  }
}