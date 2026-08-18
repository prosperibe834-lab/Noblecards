import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';

class ResetPasswordIllustration extends StatefulWidget {
  const ResetPasswordIllustration({super.key});

  @override
  State<ResetPasswordIllustration> createState() => _ResetPasswordIllustrationState();
}

class _ResetPasswordIllustrationState extends State<ResetPasswordIllustration> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: SizedBox(
        height: 180,
        width: 180,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background Glowing Circle
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark 
                    ? AppColors.primary.withOpacity(0.1) 
                    : AppColors.primary.withOpacity(0.05),
              ),
            ),
            // Floating Envelope Animation
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _animation.value),
                  child: child,
                );
              },
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // White Card sticking out
                  Positioned(
                    top: -20,
                    child: Container(
                      width: 60,
                      height: 70,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.lightBackground : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Boxicons.bx_lock_alt,
                          color: AppColors.primary,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                  // Green Envelope Body
                  Container(
                    width: 100,
                    height: 65,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        )
                      ],
                    ),
                  ),
                  // Envelope Flap Overlay Simulation (Fold)
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: 100,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primaryDark.withOpacity(0.3),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Subtle floating particles
            Positioned(top: 20, left: 20, child: _buildParticle()),
            Positioned(bottom: 40, right: 10, child: _buildParticle()),
            Positioned(top: 60, right: 20, child: _buildParticle()),
            Positioned(bottom: 20, left: 30, child: _buildParticle()),
          ],
        ),
      ),
    );
  }

  Widget _buildParticle() {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Transform.rotate(
      angle: 0.785398, // 45 degrees
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: isDark ? AppColors.primaryDark : AppColors.successLight.withOpacity(0.5),
        ),
      ),
    );
  }
}