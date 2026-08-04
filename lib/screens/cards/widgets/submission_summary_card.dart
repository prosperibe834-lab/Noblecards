import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../models/submission_model.dart';

class SubmissionSummaryCard extends StatelessWidget {
  final SubmissionModel data;
  const SubmissionSummaryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          _buildRow(context, Boxicons.bx_hash, 'Reference ID', data.referenceId, isHighlighted: true),
          _buildDivider(isDark),
          _buildRow(context, Boxicons.bx_layer, 'Cards Submitted', '${data.cardsSubmitted}'),
          _buildDivider(isDark),
          _buildRow(context, Boxicons.bx_dollar_circle, 'Total Face Value', '\$${data.totalFaceValue.toStringAsFixed(2)}'),
          _buildDivider(isDark),
          _buildRow(context, Boxicons.bx_line_chart, 'Sell Rate', '${data.sellRate.toStringAsFixed(2)}%', isHighlighted: true),
          _buildDivider(isDark),
          _buildRow(context, Boxicons.bx_wallet, 'Estimated You Receive', '\$${data.estimatedReceive.toStringAsFixed(2)}', isHighlighted: true),
          _buildDivider(isDark),
          _buildRow(context, Boxicons.bx_time_five, 'Verification Time', data.verificationTime),
          _buildDivider(isDark),
          _buildRow(context, Boxicons.bx_calendar, 'Submitted On', data.submittedOn),
          _buildDivider(isDark),
          _buildRow(context, Boxicons.bx_credit_card, 'Payment Method', data.paymentMethod),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, IconData icon, String label, String value, {bool isHighlighted = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppColors.success),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkText : AppColors.lightText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w600,
            color: isHighlighted 
                ? AppColors.success 
                : (isDark ? AppColors.darkText : AppColors.lightText),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.constrainWidth();
          const dashWidth = 4.0;
          const dashSpace = 4.0;
          final dashCount = (width / (dashWidth + dashSpace)).floor();
          return Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: dashWidth,
                height: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: isDark ? Colors.white12 : Colors.black12),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}