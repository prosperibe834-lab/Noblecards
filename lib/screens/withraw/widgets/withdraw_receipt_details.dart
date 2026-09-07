import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'package:intl/intl.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../models/withdrawal_transaction_model.dart';

class WithdrawReceiptDetails extends StatelessWidget {
  final WithdrawalTransactionModel transaction;

  const WithdrawReceiptDetails({Key? key, required this.transaction}) : super(key: key);

  String _getCurrencySymbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'NGN': return '₦';
      case 'GBP': return '£';
      case 'CAD': return 'C\$';
      case 'GHS': return 'GH₵';
      case 'USD': default: return '\$';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final destSymbol = _getCurrencySymbol(transaction.destinationCurrency);
    final numFormat = NumberFormat.currency(symbol: '', decimalDigits: 2);
    final formattedDate = DateFormat('MMM dd, yyyy • hh:mm a').format(transaction.timestamp);

    return Column(
      children: [
        _buildRow(context, Boxicons.bx_check_circle, 'Status', transaction.status, isDark: isDark, isStatus: true),
        _buildRow(context, Boxicons.bx_calendar, 'Date & Time', formattedDate, isDark: isDark),
        _buildRow(context, Boxicons.bx_hash, 'Reference ID', transaction.referenceId, isDark: isDark),
        _buildRow(context, Boxicons.bx_building_house, 'Withdrawal Method', transaction.method, isDark: isDark),
        _buildRow(context, Boxicons.bx_globe, 'Country', '${transaction.countryFlag} ${transaction.destinationCountry}', isDark: isDark),
        _buildRow(context, Boxicons.bx_buildings, 'Bank', transaction.destinationBank, isDark: isDark),
        _buildRow(context, Boxicons.bx_credit_card_front, 'Account Number', transaction.destinationAccountMasked, isDark: isDark),
        
        const Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Divider(height: 1, thickness: 1),
        ),
        
        _buildRow(context, Boxicons.bx_transfer, 'Exchange Rate', '1 ${transaction.sourceCurrency} = $destSymbol${numFormat.format(transaction.exchangeRate)}', isDark: isDark),
        _buildRow(context, Boxicons.bx_purchase_tag, 'Withdrawal Fee', '$destSymbol${numFormat.format(transaction.fee)}', isDark: isDark),
        
        const Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Divider(height: 1, thickness: 1),
        ),

        _buildRow(context, Boxicons.bx_wallet, 'Amount Received', '$destSymbol${numFormat.format(transaction.destinationAmount)}', isDark: isDark, isHighlight: true),
      ],
    );
  }

  Widget _buildRow(BuildContext context, IconData icon, String label, String value, {required bool isDark, bool isStatus = false, bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
      child: Row(
        children: [
          Icon(icon, size: 18, color: isHighlight ? AppColors.primary : (isDark ? AppColors.darkSubText : AppColors.lightSubText)),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isHighlight ? AppColors.primary : (isDark ? AppColors.darkSubText : AppColors.lightSubText),
              fontWeight: isHighlight ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          const Spacer(),
          if (isStatus) 
            Row(
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                const Icon(Boxicons.bxs_circle, size: 8, color: AppColors.primary),
              ],
            )
          else
            Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isHighlight 
                    ? AppColors.primary 
                    : (isDark ? AppColors.darkText : AppColors.lightText),
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
        ],
      ),
    );
  }
}