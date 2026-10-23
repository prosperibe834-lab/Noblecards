// Location: lib/deposit/widgets/bank_transfer_header_graphic.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class BankTransferHeaderGraphic extends StatelessWidget {
  final bool isDark;

  const BankTransferHeaderGraphic({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 104,
      height: 94,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Radiant Glowing Halo Rings in Background
          Container(
            width: 94,
            height: 94,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: isDark
                    ? [
                        const Color(0xFF10B981).withOpacity(0.38),
                        const Color(0xFF059669).withOpacity(0.15),
                        Colors.transparent,
                      ]
                    : [
                        const Color(0xFF10B981).withOpacity(0.22),
                        const Color(0xFF34D399).withOpacity(0.08),
                        Colors.transparent,
                      ],
              ),
            ),
          ),

          // Translucent tilted ellipse ring
          Transform.rotate(
            angle: -math.pi / 7,
            child: Container(
              width: 86,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF34D399).withOpacity(0.35)
                      : const Color(0xFF10B981).withOpacity(0.25),
                  width: 1.5,
                ),
              ),
            ),
          ),

          // 2. 3D Bank Building Illustration
          Transform.rotate(
            angle: -0.12,
            child: SizedBox(
              width: 72,
              height: 64,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Bank Building Body
                  Positioned(
                    top: 4,
                    left: 4,
                    right: 4,
                    bottom: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isDark
                              ? [
                                  const Color(0xFF10B981),
                                  const Color(0xFF047857),
                                  const Color(0xFF064E3B),
                                ]
                              : [
                                  const Color(0xFF34D399),
                                  const Color(0xFF10B981),
                                  const Color(0xFF059669),
                                ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF10B981).withOpacity(isDark ? 0.45 : 0.3),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Pediment Roof Triangle
                          CustomPaint(
                            size: const Size(54, 12),
                            painter: _TriangleRoofPainter(
                              color: isDark ? const Color(0xFFD1FAE5) : Colors.white,
                            ),
                          ),

                          // Columns / Pillars Row
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: List.generate(
                                3,
                                (index) => Container(
                                  width: 6,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Base Step
                          Container(
                            width: 58,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 3. Shield Badge with Checkmark at Front Right
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Boxicons.bx_check,
                          color: Colors.white,
                          size: 18,
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
    );
  }
}

class _TriangleRoofPainter extends CustomPainter {
  final Color color;

  _TriangleRoofPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TriangleRoofPainter oldDelegate) =>
      oldDelegate.color != color;
}
