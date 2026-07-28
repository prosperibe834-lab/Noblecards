import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../models/transaction_model.dart';

class TransactionStatusChip extends StatelessWidget {
  final TransactionStatus status;
  final bool isCompact;

  const TransactionStatusChip({
    Key? key,
    required this.status,
    this.isCompact = false,
  }) : super(key: key);

  Color _getStatusColor(BuildContext context) {
    switch (status) {
      case TransactionStatus.successful:
        return const Color(0xFF10B981);
      case TransactionStatus.pending:
        return const Color(0xFFF59E0B);
      case TransactionStatus.processing:
        return const Color(0xFF8B5CF6);
      case TransactionStatus.failed:
        return const Color(0xFFEF4444);
      case TransactionStatus.cancelled:
        return const Color(0xFF6B7280);
      case TransactionStatus.refunded:
        return const Color(0xFF3B82F6);
      case TransactionStatus.expired:
        return const Color(0xFF9CA3AF);
      case TransactionStatus.reversed:
        return const Color(0xFFEC4899);
      case TransactionStatus.underReview:
        return const Color(0xFF6366F1);
    }
  }

  IconData _getStatusIcon() {
    switch (status) {
      case TransactionStatus.successful:
        return Boxicons.bx_check_circle;
      case TransactionStatus.pending:
        return Boxicons.bx_time_five;
      case TransactionStatus.processing:
        return Boxicons.bx_loader_alt;
      case TransactionStatus.failed:
        return Boxicons.bx_x_circle;
      case TransactionStatus.cancelled:
        return Boxicons.bx_block;
      case TransactionStatus.refunded:
        return Boxicons.bx_refresh;
      case TransactionStatus.expired:
        return Boxicons.bx_alarm_off;
      case TransactionStatus.reversed:
        return Boxicons.bx_undo;
      case TransactionStatus.underReview:
        return Boxicons.bx_shield_quarter;
    }
  }

  String _getStatusText() {
    switch (status) {
      case TransactionStatus.successful:
        return 'Successful';
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.processing:
        return 'Processing';
      case TransactionStatus.failed:
        return 'Failed';
      case TransactionStatus.cancelled:
        return 'Cancelled';
      case TransactionStatus.refunded:
        return 'Refunded';
      case TransactionStatus.expired:
        return 'Expired';
      case TransactionStatus.reversed:
        return 'Reversed';
      case TransactionStatus.underReview:
        return 'Under Review';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 12,
        vertical: isCompact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getStatusIcon(), size: isCompact ? 12 : 14, color: color),
          const SizedBox(width: 4),
          Text(
            _getStatusText(),
            style: TextStyle(
              color: color,
              fontSize: isCompact ? 10 : 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}