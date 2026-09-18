import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../models/submission_model.dart';

class SubmissionStatusCard extends StatelessWidget {
  final SubmissionModel data;

  const SubmissionStatusCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.success.withOpacity(0.15)
            : AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.success.withOpacity(isDark ? 0.3 : 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Boxicons.bx_time_five, color: AppColors.success, size: 16),
          const SizedBox(width: 8),
          Text(
            'Status: ${_statusLabel(data.status)}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.success : Colors.green[800],
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'APPROVED':
      case 'PAID':
      case 'SUCCESSFUL':
        return 'Successful';
      case 'FAILED':
      case 'REJECTED':
        return 'Failed';
      case 'UNDER_REVIEW':
        return 'Under Review';
      case 'PROCESSING':
        return 'Processing';
      default:
        return 'Pending Verification';
    }
  }
}
