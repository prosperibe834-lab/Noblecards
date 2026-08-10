import 'package:flutter/material.dart';

class QrScannerOverlay extends StatefulWidget {
  final Rect scanArea;
  final bool isDark;

  const QrScannerOverlay({
    Key? key,
    required this.scanArea,
    required this.isDark,
  }) : super(key: key);

  @override
  State<QrScannerOverlay> createState() => _QrScannerOverlayState();
}

class _QrScannerOverlayState extends State<QrScannerOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The frosted overlay and cutout
        CustomPaint(
          size: Size.infinite,
          painter: _QrOverlayPainter(
            scanArea: widget.scanArea,
            overlayColor: widget.isDark 
                ? Colors.black.withOpacity(0.7) 
                : Colors.white.withOpacity(0.85),
          ),
        ),
        // The animated scanning line
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final lineY = widget.scanArea.top + (widget.scanArea.height * _animation.value);
            return Positioned(
              top: lineY,
              left: widget.scanArea.left,
              width: widget.scanArea.width,
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withOpacity(0.6),
                      blurRadius: 12,
                      spreadRadius: 2,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _QrOverlayPainter extends CustomPainter {
  final Rect scanArea;
  final Color overlayColor;
  final double cornerLength = 30.0;
  final double cornerStrokeWidth = 4.0;
  final double borderRadius = 20.0;

  _QrOverlayPainter({required this.scanArea, required this.overlayColor});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw the semi-transparent overlay over the whole screen
    final backgroundPaint = Paint()..color = overlayColor;
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()
          ..addRRect(RRect.fromRectAndRadius(scanArea, Radius.circular(borderRadius)))
          ..close(),
      ),
      backgroundPaint,
    );

    // 2. Draw the green corners
    final cornerPaint = Paint()
      ..color = const Color(0xFF10B981)
      ..style = PaintingStyle.stroke
      ..strokeWidth = cornerStrokeWidth
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Top Left
    path.moveTo(scanArea.left, scanArea.top + cornerLength);
    path.lineTo(scanArea.left, scanArea.top + borderRadius);
    path.arcToPoint(
      Offset(scanArea.left + borderRadius, scanArea.top),
      radius: Radius.circular(borderRadius),
      clockwise: true,
    );
    path.lineTo(scanArea.left + cornerLength, scanArea.top);

    // Top Right
    path.moveTo(scanArea.right - cornerLength, scanArea.top);
    path.lineTo(scanArea.right - borderRadius, scanArea.top);
    path.arcToPoint(
      Offset(scanArea.right, scanArea.top + borderRadius),
      radius: Radius.circular(borderRadius),
      clockwise: true,
    );
    path.lineTo(scanArea.right, scanArea.top + cornerLength);

    // Bottom Right
    path.moveTo(scanArea.right, scanArea.bottom - cornerLength);
    path.lineTo(scanArea.right, scanArea.bottom - borderRadius);
    path.arcToPoint(
      Offset(scanArea.right - borderRadius, scanArea.bottom),
      radius: Radius.circular(borderRadius),
      clockwise: true,
    );
    path.lineTo(scanArea.right - cornerLength, scanArea.bottom);

    // Bottom Left
    path.moveTo(scanArea.left + cornerLength, scanArea.bottom);
    path.lineTo(scanArea.left + borderRadius, scanArea.bottom);
    path.arcToPoint(
      Offset(scanArea.left, scanArea.bottom - borderRadius),
      radius: Radius.circular(borderRadius),
      clockwise: true,
    );
    path.lineTo(scanArea.left, scanArea.bottom - cornerLength);

    canvas.drawPath(path, cornerPaint);
  }

  @override
  bool shouldRepaint(covariant _QrOverlayPainter oldDelegate) {
    return oldDelegate.scanArea != scanArea || oldDelegate.overlayColor != overlayColor;
  }
}