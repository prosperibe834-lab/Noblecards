import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';

class AnalyticsOverviewGrid extends StatelessWidget {
  final double totalDeposits;
  final double depositsChange;
  final double totalWithdrawals;
  final double withdrawalsChange;
  final double giftCardsBought;
  final double boughtChange;
  final double giftCardsSold;
  final double soldChange;

  const AnalyticsOverviewGrid({
    Key? key,
    required this.totalDeposits,
    required this.depositsChange,
    required this.totalWithdrawals,
    required this.withdrawalsChange,
    required this.giftCardsBought,
    required this.boughtChange,
    required this.giftCardsSold,
    required this.soldChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _OverviewCard(
                title: 'Total Deposits',
                amount: '\$${totalDeposits.toStringAsFixed(2)}',
                changePercent: '+${depositsChange.toStringAsFixed(1)}%',
                icon: Boxicons.bx_download,
                iconColor: AppColors.primary,
                chartColor: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _OverviewCard(
                title: 'Total Withdrawals',
                amount: '\$${totalWithdrawals.toStringAsFixed(2)}',
                changePercent: '+${withdrawalsChange.toStringAsFixed(1)}%',
                icon: Boxicons.bx_upload,
                iconColor: AppColors.accentViolet,
                chartColor: AppColors.accentViolet,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _OverviewCard(
                title: 'Gift Cards Bought',
                amount: '\$${giftCardsBought.toStringAsFixed(2)}',
                changePercent: '+${boughtChange.toStringAsFixed(1)}%',
                icon: Boxicons.bx_gift,
                iconColor: AppColors.secondary,
                chartColor: AppColors.secondary,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _OverviewCard(
                title: 'Gift Cards Sold',
                amount: '\$${soldChange.toStringAsFixed(2)}',
                changePercent: '+${soldChange.toStringAsFixed(1)}%',
                icon: Boxicons.bx_tag_alt,
                iconColor: AppColors.accent,
                chartColor: AppColors.accent,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final String title;
  final String amount;
  final String changePercent;
  final IconData icon;
  final Color iconColor;
  final Color chartColor;

  const _OverviewCard({
    Key? key,
    required this.title,
    required this.amount,
    required this.changePercent,
    required this.icon,
    required this.iconColor,
    required this.chartColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subTextColor = isDark ? AppColors.darkSubText : AppColors.lightSubText;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(color: subTextColor, fontSize: 11, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            amount,
            style: TextStyle(
              color: textColor,
              fontSize: 17,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                changePercent,
                style: const TextStyle(
                  color: AppColors.success,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 42,
                height: 18,
                child: CustomPaint(
                  painter: _SparklinePainter(color: chartColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final Color color;

  _SparklinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.9, size.width * 0.5, size.height * 0.4);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.2, size.width, size.height * 0.1);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}