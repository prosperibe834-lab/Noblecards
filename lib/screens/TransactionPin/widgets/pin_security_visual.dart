import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class PinSecurityVisual extends StatefulWidget {
  const PinSecurityVisual({super.key});

  @override
  State<PinSecurityVisual> createState() => _PinSecurityVisualState();
}

class _PinSecurityVisualState extends State<PinSecurityVisual>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext meContext) {
    final isDark = Theme.of(meContext).brightness == Brightness.dark;

    return SizedBox(
      width: 160,
      height: 100,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final pulse = math.sin(_controller.value * math.pi) * 0.08 + 1.0;
          final floatOffset = math.sin(_controller.value * math.pi * 2) * 3.0;

          return Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Floating decorative particles
              Positioned(
                top: 15 + floatOffset,
                left: 18,
                child: _ParticleDot(
                  color: const Color(0xFF8B5CF6).withOpacity(0.7),
                  size: 6,
                ),
              ),
              Positioned(
                top: 45 - floatOffset,
                left: 28,
                child: _ParticleDot(
                  color: AppColors.primary.withOpacity(0.8),
                  size: 4,
                ),
              ),
              Positioned(
                top: 22 - floatOffset,
                right: 22,
                child: _ParticleDot(
                  color: const Color(0xFFF59E0B).withOpacity(0.8),
                  size: 5,
                ),
              ),
              Positioned(
                top: 55 + floatOffset,
                right: 30,
                child: _ParticleDot(
                  color: AppColors.secondary.withOpacity(0.7),
                  size: 4,
                ),
              ),
              Positioned(
                bottom: 12 + floatOffset,
                left: 42,
                child: _ParticleDot(
                  color: const Color(0xFFF59E0B).withOpacity(0.6),
                  size: 3,
                ),
              ),
              Positioned(
                bottom: 18 - floatOffset,
                right: 40,
                child: _ParticleDot(
                  color: AppColors.primary.withOpacity(0.7),
                  size: 5,
                ),
              ),

              // Radial background aura
              Transform.scale(
                scale: pulse,
                child: Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: isDark
                          ? [
                              AppColors.primary.withOpacity(0.35),
                              AppColors.primary.withOpacity(0.08),
                              Colors.transparent,
                            ]
                          : [
                              AppColors.primary.withOpacity(0.22),
                              AppColors.primary.withOpacity(0.05),
                              Colors.transparent,
                            ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                  ),
                ),
              ),

              // Central Shield Emblem
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? const Color(0xFF0F2E23) : const Color(0xFFE6F7F0),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(isDark ? 0.4 : 0.25),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(isDark ? 0.3 : 0.15),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Shield outline icon
                      Icon(
                        Icons.shield_outlined,
                        size: 38,
                        color: AppColors.primary,
                      ),
                      // Inner lock icon
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Icon(
                          Icons.lock_rounded,
                          size: 16,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ParticleDot extends StatelessWidget {
  final Color color;
  final double size;

  const _ParticleDot({
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}