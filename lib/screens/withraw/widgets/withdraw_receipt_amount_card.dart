import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'package:intl/intl.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../models/withdrawal_transaction_model.dart';

class WithdrawReceiptAmountCard extends StatelessWidget {
  final WithdrawalTransactionModel transaction;

  const WithdrawReceiptAmountCard({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final sourceFormat = NumberFormat.currency(symbol: '', decimalDigits: 2);
    final destFormat = NumberFormat.currency(symbol: '', decimalDigits: 2);

    // Dynamic currency formatting based on country
    String getCurrencySymbol(String currency) {
      switch (currency.toUpperCase()) {
        case 'NGN': return '₦';
        case 'GBP': return '£';
        case 'CAD': return 'C\$';
        case 'GHS': return 'GH₵';
        case 'USD': default: return '\$';
      }
    }

    final destSymbol = getCurrencySymbol(transaction.destinationCurrency);

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
          width: 1,
        ),
      ),
      child: CustomPaint(
        painter: _WavePainter(isDark ? AppColors.primary.withOpacity(0.05) : AppColors.primary.withOpacity(0.1)),
        child: Column(
          children: [
            Text(
              'You withdrew',
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
                  '\$${sourceFormat.format(transaction.sourceAmount)}',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 28),
                ),
                const SizedBox(width: AppSpacing.xs),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    transaction.sourceCurrency,
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
              child: const Icon(Boxicons.bx_down_arrow_alt, color: AppColors.primary, size: 20),
            ),
            const SizedBox(height: AppSpacing.s),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$destSymbol${destFormat.format(transaction.destinationAmount)}',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 28, 
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    transaction.destinationCurrency,
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
              'Successfully sent to your bank',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final Color color;
  _WavePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final path1 = Path();
    path1.moveTo(0, size.height * 0.4);
    path1.quadraticBezierTo(size.width * 0.25, size.height * 0.2, size.width * 0.5, size.height * 0.5);
    path1.quadraticBezierTo(size.width * 0.75, size.height * 0.8, size.width, size.height * 0.6);
    
    final path2 = Path();
    path2.moveTo(0, size.height * 0.5);
    path2.quadraticBezierTo(size.width * 0.25, size.height * 0.4, size.width * 0.5, size.height * 0.6);
    path2.quadraticBezierTo(size.width * 0.75, size.height * 0.9, size.width, size.height * 0.7);

    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}