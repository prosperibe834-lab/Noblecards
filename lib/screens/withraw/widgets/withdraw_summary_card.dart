import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'package:intl/intl.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../models/withdrawal_transaction_model.dart';
import '../providers/withdraw_provider.dart';
import 'dashed_divider.dart';

class WithdrawSummaryCard extends StatelessWidget {
  final WithdrawProvider? provider;
  final WithdrawalTransactionModel? transaction;

  const WithdrawSummaryCard({super.key, this.provider, this.transaction})
    : assert(provider != null || transaction != null);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subTextColor = isDark
        ? AppColors.darkSubText
        : AppColors.lightSubText;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final formatter = NumberFormat("#,##0.00", "en_US");
    final currency =
        provider?.selectedCountry.currency ?? transaction!.currency;
    final symbol = provider?.selectedCountry.currencySymbol ?? '';
    final exchangeRate =
        provider?.selectedCountry.exchangeRate ??
        transaction!.exchangeRate ??
        1.0;
    final convertedAmount =
        provider?.convertedAmount ??
        transaction!.convertedAmount ??
        transaction!.amount;
    final fee = provider?.withdrawalFee ?? transaction!.fee ?? 0.0;
    final amountReceived =
        provider?.amountReceived ??
        transaction!.amountToReceive ??
        transaction!.amount;
    final amountSent =
        provider?.parsedAmount ??
        transaction!.amountToSend ??
        transaction!.amount;
    final exchangeText = '1 USD = $symbol${formatter.format(exchangeRate)}';
    final convertedAmountText =
        '$currency $symbol${formatter.format(convertedAmount)}';
    final feeText = '$currency $symbol${formatter.format(fee)}';
    final receiveText = '$currency $symbol${formatter.format(amountReceived)}';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Withdrawal Summary',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildRow(
            'You send',
            '\$${formatter.format(amountSent)} USD',
            textColor,
            subTextColor,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildRowWithInfo(
            'Exchange rate',
            exchangeText,
            textColor,
            subTextColor,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildRow(
            'Converted amount',
            convertedAmountText,
            textColor,
            subTextColor,
            isBoldValue: true,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildRow('Withdrawal fee', feeText, textColor, subTextColor),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: DashedDivider(color: borderColor),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'You will receive',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                receiveText,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    String label,
    String value,
    Color textColor,
    Color subTextColor, {
    bool isBoldValue = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: subTextColor, fontSize: 13)),
        Text(
          value,
          style: TextStyle(
            color: textColor,
            fontSize: 13,
            fontWeight: isBoldValue ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildRowWithInfo(
    String label,
    String value,
    Color textColor,
    Color subTextColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: subTextColor, fontSize: 13)),
        Row(
          children: [
            Text(value, style: TextStyle(color: textColor, fontSize: 13)),
            const SizedBox(width: AppSpacing.xs),
            Icon(Boxicons.bx_info_circle, color: subTextColor, size: 16),
          ],
        ),
      ],
    );
  }
}
