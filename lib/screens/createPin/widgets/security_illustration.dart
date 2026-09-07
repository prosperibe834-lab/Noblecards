import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_animation.dart';

class SecurityIllustration extends StatefulWidget {
  const SecurityIllustration({super.key});

  @override
  State<SecurityIllustration> createState() => _SecurityIllustrationState();
}

class _SecurityIllustrationState extends State<SecurityIllustration> with SingleTickerProviderStateMixin {
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
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Glow
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.1),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),
          
          // Shield and Lock Icon
          const Stack(
            alignment: Alignment.center,
            children: [
              Icon(Boxicons.bxs_shield, size: 72, color: AppColors.primary),
              Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Icon(Boxicons.bxs_lock_alt, size: 28, color: AppColors.white),
              ),
            ],
          ),

          // Animated Floating Particles
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final offset = math.sin(_controller.value * math.pi * 2) * 5;
              return Stack(
                children: [
                  _buildParticle(top: 20, left: 30, color: AppColors.warning, size: 6, offset: offset),
                  _buildParticle(top: 80, left: 20, color: AppColors.accentViolet, size: 4, offset: -offset),
                  _buildParticle(top: 10, right: 40, color: AppColors.success, size: 5, offset: offset * 1.2),
                  _buildParticle(top: 90, right: 30, color: AppColors.warning, size: 7, offset: -offset * 0.8),
                  _buildParticle(top: 40, right: 10, color: AppColors.primary, size: 4, offset: offset * 1.5, isDiamond: true),
                  _buildParticle(top: 50, left: 10, color: AppColors.success, size: 5, offset: -offset, isDiamond: true),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildParticle({
    required double top,
    double? left,
    double? right,
    required Color color,
    required double size,
    required double offset,
    bool isDiamond = false,
  }) {
    return Positioned(
      top: top + offset,
      left: left,
      right: right,
      child: Transform.rotate(
        angle: isDiamond ? math.pi / 4 : 0,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: isDiamond ? BoxShape.rectangle : BoxShape.circle,
          ),
        ),
      ),
    );
  }
}