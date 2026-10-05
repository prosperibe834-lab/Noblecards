import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'package:intl/intl.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';

class DepositReceiptDetails extends StatelessWidget {
  final String? depositId;
  final String? transactionId;
  final String? reference;
  final String? status;
  final DateTime? date;
  final String? paymentMethod;
  final String? provider;
  final String currency;
  final double amount;
  final double? fee;
  final double netAmountUsd;
  final String? providerReference;
  final String? providerTransactionId;

  const DepositReceiptDetails({
    super.key,
    this.depositId,
    this.transactionId,
    this.reference,
    this.status,
    this.date,
    this.paymentMethod,
    this.provider,
    required this.currency,
    required this.amount,
    this.fee,
    required this.netAmountUsd,
    this.providerReference,
    this.providerTransactionId,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final moneyFormat = NumberFormat.currency(symbol: '', decimalDigits: 2);
    final rows = <Widget>[
      if (_hasValue(status))
        _row(context, Boxicons.bx_check_circle, 'Status', _formatStatus(status!), isDark, isStatus: true),
      if (date != null)
        _row(context, Boxicons.bx_calendar, 'Date & Time', DateFormat('MMM dd, yyyy • hh:mm a').format(date!.toLocal()), isDark),
      if (_hasValue(depositId))
        _row(context, Boxicons.bx_hash, 'Deposit ID', depositId!, isDark),
      if (_hasValue(transactionId))
        _row(context, Boxicons.bx_hash, 'Transaction ID', transactionId!, isDark),
      if (_hasValue(reference))
        _row(context, Boxicons.bx_hash, 'Reference ID', reference!, isDark),
      if (_hasValue(paymentMethod))
        _row(context, Boxicons.bx_credit_card_front, 'Deposit Method', _formatStatus(paymentMethod!), isDark),
      if (_hasValue(provider))
        _row(context, Boxicons.bx_transfer, 'Provider', _formatStatus(provider!), isDark),
      _row(context, Boxicons.bx_wallet, 'Currency', currency, isDark),
      _row(context, Boxicons.bx_wallet, 'Deposit Amount', '${_currencySymbol(currency)}${moneyFormat.format(amount)}', isDark),
      if (fee != null)
        _row(context, Boxicons.bx_purchase_tag, 'Fee', '${_currencySymbol(currency)}${moneyFormat.format(fee)}', isDark),
      _row(context, Boxicons.bx_wallet, 'Net Amount Credited', '\$${moneyFormat.format(netAmountUsd)} USD', isDark, isHighlight: true),
      if (_hasValue(providerReference))
        _row(context, Boxicons.bx_hash, 'Provider Reference', providerReference!, isDark),
      if (_hasValue(providerTransactionId))
        _row(context, Boxicons.bx_hash, 'Provider Transaction ID', providerTransactionId!, isDark),
    ];
    return Column(
      children: [
        for (var index = 0; index < rows.length; index++) ...[
          if (index == 1 || index == 7)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Divider(height: 1, thickness: 1),
            ),
          rows[index],
        ],
      ],
    );
  }

  Widget _row(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    bool isDark, {
    bool isStatus = false,
    bool isHighlight = false,
  }) {
    final rowColor = isHighlight
        ? AppColors.primary
        : isDark
            ? AppColors.darkSubText
            : AppColors.lightSubText;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
      child: Row(
        children: [
          Icon(icon, size: 18, color: rowColor),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: rowColor,
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
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isHighlight
                          ? AppColors.primary
                          : isDark
                              ? AppColors.darkText
                              : AppColors.lightText,
                      fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
                      fontSize: 14,
                    ),
              ),
            ),
        ],
      ),
    );
  }

  bool _hasValue(String? value) => value != null && value.trim().isNotEmpty;

  String _formatStatus(String value) => value
      .split('_')
      .map((part) => part.isEmpty ? part : '${part[0]}${part.substring(1).toLowerCase()}')
      .join(' ');

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