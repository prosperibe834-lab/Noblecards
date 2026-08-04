import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';
import 'dart:math' as math;

class AnimatedSubmissionSuccess extends StatefulWidget {
  const AnimatedSubmissionSuccess({super.key});

  @override
  State<AnimatedSubmissionSuccess> createState() => _AnimatedSubmissionSuccessState();
}

class _AnimatedSubmissionSuccessState extends State<AnimatedSubmissionSuccess> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);

    _scaleAnimation = CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut);
    _scaleController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      width: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Confetti/Sparkles
          ...List.generate(6, (index) => _buildSparkle(index)),
          
          // Pulsing Background Glow
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_pulseController.value * 0.15),
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.success.withOpacity(0.15),
                  ),
                ),
              );
            },
          ),
          
          // Main Checkmark Circle
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              height: 85,
              width: 85,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.success,
                boxShadow: [
                  BoxShadow(color: Color(0x4000C853), blurRadius: 20, spreadRadius: 2, offset: Offset(0, 8)),
                ],
              ),
              child: const Icon(Boxicons.bx_check, color: Colors.white, size: 55),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSparkle(int index) {
    final double angle = (index * 60) * (math.pi / 180);
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Transform.translate(
        offset: Offset(math.cos(angle) * 65, math.sin(angle) * 65),
        child: Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: index % 2 == 0 ? AppColors.success : AppColors.success.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}