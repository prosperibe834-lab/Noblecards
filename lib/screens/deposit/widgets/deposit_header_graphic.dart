// Location: lib/deposit/widgets/deposit_header_graphic.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';

class DepositHeaderGraphic extends StatelessWidget {
  final bool isDark;

  const DepositHeaderGraphic({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 90,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Ambient Background Glowing Halo Rings
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: isDark
                    ? [
                        const Color(0xFF10B981).withOpacity(0.35),
                        const Color(0xFF059669).withOpacity(0.15),
                        Colors.transparent,
                      ]
                    : [
                        const Color(0xFF10B981).withOpacity(0.20),
                        const Color(0xFF34D399).withOpacity(0.08),
                        Colors.transparent,
                      ],
              ),
            ),
          ),

          // Translucent decorative outer ring
          Transform.rotate(
            angle: -math.pi / 6,
            child: Container(
              width: 82,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF34D399).withOpacity(0.4)
                      : const Color(0xFF10B981).withOpacity(0.3),
                  width: 1.5,
                ),
              ),
            ),
          ),

          // 2. 3D Tilted Wallet
          Transform.rotate(
            angle: -0.15,
            child: SizedBox(
              width: 64,
              height: 54,
              child: Stack(
                children: [
                  // Card peeking out of slot
                  Positioned(
                    top: 2,
                    right: 8,
                    left: 12,
                    height: 22,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF064E3B),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: const Color(0xFF34D399).withOpacity(0.6),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6, top: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 6,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFD700),
                                borderRadius: BorderRadius.circular(1.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Wallet Main Body
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 46,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF10B981),
                            Color(0xFF059669),
                            Color(0xFF047857),
                          ],
                        ),
                        border: Border.all(
                          color: const Color(0xFF6EE7B7).withOpacity(0.7),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF10B981).withOpacity(isDark ? 0.45 : 0.3),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Top strap / flap stitch line
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            height: 14,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF047857).withOpacity(0.35),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(11),
                                ),
                              ),
                            ),
                          ),

                          // Center Embossed Noble "N" Logo
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                'N',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18,
                                  color: Colors.white.withOpacity(0.95),
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 3,
                                      offset: const Offset(0, 1.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
