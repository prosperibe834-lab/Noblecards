import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'package:intl/intl.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';

class DepositReceiptAmountCard extends StatelessWidget {
  final double amount;
  final String currency;
  final double creditedUsd;
  final String? status;

  const DepositReceiptAmountCard({
    super.key,
    required this.amount,
    required this.currency,
    required this.creditedUsd,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final amountFormat = NumberFormat.currency(symbol: '', decimalDigits: 2);
    final symbol = _currencySymbol(currency);
    final statusMessage = switch (status?.toUpperCase()) {
      'SUCCESSFUL' || 'COMPLETED' => 'Funds credited to your wallet',
      'PENDING' => 'Deposit is pending',
      'PROCESSING' => 'Deposit is being processed',
      'FAILED' || 'REJECTED' => 'Deposit failed',
      'CANCELLED' || 'CANCELED' => 'Deposit was cancelled',
      _ => 'Deposit details',
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [AppColors.darkInput, AppColors.primaryDark.withOpacity(0.2)]
              : [AppColors.primary.withOpacity(0.05), AppColors.primary.withOpacity(0.15)],
        ),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.primary.withOpacity(0.1),
        ),
      ),
      child: CustomPaint(
        painter: _DepositWavePainter(
          isDark ? AppColors.primary.withOpacity(0.05) : AppColors.primary.withOpacity(0.1),
        ),
        child: Column(
          children: [
            Text(
              'You deposited',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                  ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$symbol${amountFormat.format(amount)}',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 28),
                ),
                const SizedBox(width: AppSpacing.xs),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    currency,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(isDark ? 0.2 : 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Boxicons.bx_up_arrow_alt,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(height: AppSpacing.s),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${amountFormat.format(creditedUsd)}',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontSize: 28,
                        color: AppColors.primary,
                      ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    'USD',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 16,
                          color: AppColors.primary,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              statusMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  String _currencySymbol(String code) {
    switch (code.toUpperCase()) {
      case 'NGN': return '₦';
      case 'GBP': return '£';
      case 'GHS': return 'GH₵';
      case 'CAD': return 'C\$';
      case 'EUR': return '€';
      case 'USD': return '\$';
      default: return '$code ';
    }
  }
}

class _DepositWavePainter extends CustomPainter {
  final Color color;

  const _DepositWavePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final first = Path()
      ..moveTo(0, size.height * 0.4)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.2, size.width * 0.5, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.8, size.width, size.height * 0.6);
    final second = Path()
      ..moveTo(0, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.4, size.width * 0.5, size.height * 0.6)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.9, size.width, size.height * 0.7);
    canvas
      ..drawPath(first, paint)
      ..drawPath(second, paint);
  }

  @override
  bool shouldRepaint(covariant _DepositWavePainter oldDelegate) => oldDelegate.color != color;
}