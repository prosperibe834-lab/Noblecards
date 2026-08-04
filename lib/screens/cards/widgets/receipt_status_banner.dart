import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../models/sell_receipt_model.dart';

class ReceiptStatusBanner extends StatelessWidget {
  final VerificationStatus status;
  
  const ReceiptStatusBanner({super.key, required this.status});

  Color _getStatusColor() {
    switch (status) {
      case VerificationStatus.approved:
      case VerificationStatus.completed:
        return AppColors.success;
      case VerificationStatus.rejected:
        return AppColors.error;
      case VerificationStatus.needsReview:
        return AppColors.warning;
      case VerificationStatus.pending:
        return AppColors.success; // Following the design image for pending
    }
  }

  String _getStatusText() {
    switch (status) {
      case VerificationStatus.approved: return 'APPROVED';
      case VerificationStatus.rejected: return 'REJECTED';
      case VerificationStatus.needsReview: return 'NEEDS REVIEW';
      case VerificationStatus.completed: return 'COMPLETED';
      case VerificationStatus.pending: return 'PENDING VERIFICATION';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomPaint(
      painter: _DashedRectPainter(color: color.withValues(alpha: 0.5)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDark ? 0.05 : 0.02),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.circle, size: 8, color: color),
            const SizedBox(width: 8),
            Text(
              'STATUS: ${_getStatusText()}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  final Color color;
  _DashedRectPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 4.0;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(8)));

    Path dashPath = Path();
    for (PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        dashPath.addPath(metric.extractPath(distance, distance + dashWidth), Offset.zero);
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}