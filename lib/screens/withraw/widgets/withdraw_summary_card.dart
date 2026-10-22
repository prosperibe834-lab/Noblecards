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
    final isIndicativePreview = provider?.isIndicativePreview ?? false;
    final currency =
        provider?.selectedCountry.currency ?? transaction!.currency;
    final symbol = provider?.selectedCountry.currencySymbol ?? '';
    final hasQuote = provider?.hasQuote ?? true;
    final exchangeRate = isIndicativePreview
        ? provider?.indicativeExchangeRate
        : provider?.exchangeRate ?? transaction?.exchangeRate;
    final convertedAmount = isIndicativePreview
        ? provider?.indicativeConvertedAmount
        : provider?.convertedAmount ?? transaction?.convertedAmount;
    final providerFee = provider?.providerFee;
    final nobleCardsFee = provider?.nobleCardsFee;
    final indicativeNobleCardsFee = provider?.indicativeNobleCardsFee;
    final indicativeNobleCardsFeePercent =
        provider?.indicativeNobleCardsFeePercent;
    final indicativeProviderFeeMessage = provider?.indicativeProviderFeeMessage;
    final indicativeProviderFeeAmount = provider?.indicativeProviderFeeAmount;
    final indicativeProviderFeeCurrency =
        provider?.indicativeProviderFeeCurrency;
    final indicativeProviderFeeFundingCurrency =
        provider?.indicativeProviderFeeFundingCurrency;
    final indicativeTotalFeeUsd = provider?.indicativeTotalFeeUsd;
    final indicativeTransferAmount = provider?.indicativeTransferAmount;
    final indicativeExchangeRateSource = provider?.indicativeExchangeRateSource;
    final totalFee = provider?.totalFee;
    final fee = provider?.withdrawalFee ?? transaction?.fee;
    final amountReceived =
        provider?.amountReceived ?? transaction?.amountToReceive;
    final amountSent =
        provider?.parsedAmount ??
        transaction!.amountToSend ??
        transaction!.amount;
    final exchangeText =
        (hasQuote || isIndicativePreview) && exchangeRate != null
        ? '1 USD = $symbol${formatter.format(exchangeRate)}'
        : 'Unavailable';
    final convertedAmountText =
        (hasQuote || isIndicativePreview) && convertedAmount != null
        ? '$currency $symbol${formatter.format(convertedAmount)}${isIndicativePreview ? ' (before fees)' : ''}'
        : 'Unavailable';
    final feeText = hasQuote && fee != null
        ? '$currency $symbol${formatter.format(fee)}'
        : 'Unavailable';
    final receiveText =
        !isIndicativePreview && hasQuote && amountReceived != null
        ? '$currency $symbol${formatter.format(amountReceived)}'
        : isIndicativePreview && provider?.indicativeRecipientAmount != null
        ? '$currency $symbol${formatter.format(provider!.indicativeRecipientAmount!)} (Indicative)'
        : isIndicativePreview
        ? 'Not confirmed'
        : 'Unavailable';
    // Format the provider fee amount as a currency string only when meaningful.
    // Always use NumberFormat — never interpolate a raw double.
    final indicativeProviderFeeValue =
        indicativeProviderFeeAmount != null &&
            indicativeProviderFeeCurrency != null
        ? '${formatter.format(indicativeProviderFeeAmount)} $indicativeProviderFeeCurrency'
        : null;
    final providerFeeText = isIndicativePreview
        ? switch (provider?.indicativeProviderFeeStatus) {
            'CONFIRMED' => indicativeProviderFeeValue ?? 'Confirmed',
            'ESTIMATED' => indicativeProviderFeeValue != null
                ? '$indicativeProviderFeeValue (Published Indicative)'
                : 'Published Indicative',
            'NO_RECORD' => 'Not confirmed',
            _ => 'Not confirmed',
          }
        : hasQuote && providerFee != null
        ? '\$${formatter.format(providerFee)} USD'
        : 'Unavailable';
    final nobleCardsFeeText =
        isIndicativePreview && indicativeNobleCardsFee != null
        ? '\$${formatter.format(indicativeNobleCardsFee)} USD'
        : hasQuote && nobleCardsFee != null
        ? '\$${formatter.format(nobleCardsFee)} USD'
        : 'Unavailable';
    final totalFeeText = isIndicativePreview
        ? indicativeTotalFeeUsd != null
            ? '\$${formatter.format(indicativeTotalFeeUsd)} USD (Indicative)'
            : 'Not confirmed'
        : hasQuote && totalFee != null
        ? '\$${formatter.format(totalFee)} USD'
        : 'Unavailable';
    final withdrawalFeeText = isIndicativePreview
        ? indicativeProviderFeeFundingCurrency != null
              ? '$indicativeProviderFeeFundingCurrency wallet${indicativeProviderFeeFundingCurrency == 'USD' ? ' (same currency as source)' : ' (separate wallet)'}'
              : 'Unconfirmed'
        : feeText;
    final nobleCardsFeeLabel =
        isIndicativePreview && indicativeNobleCardsFeePercent != null
        ? 'NobleCards fee (${NumberFormat('0.##').format(indicativeNobleCardsFeePercent)}%)'
        : 'NobleCards fee';
    final quoteProvider = provider;
    final quoteError = quoteProvider?.dataError;
    final showQuoteError =
        quoteProvider != null &&
        !hasQuote &&
        !quoteProvider.isQuoteLoading &&
        quoteError != null &&
        quoteError.trim().isNotEmpty;

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
          Text(
            isIndicativePreview
                ? 'Withdrawal Summary (Estimate)'
                : 'Withdrawal Summary',
            style: const TextStyle(
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
            isIndicativePreview && indicativeExchangeRateSource != null
                ? '$exchangeText ($indicativeExchangeRateSource)'
                : exchangeText,
            textColor,
            subTextColor,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildRow(
            isIndicativePreview
                ? 'Destination before fees'
                : 'Converted amount',
            convertedAmountText,
            textColor,
            subTextColor,
            isBoldValue: true,
          ),
          if (isIndicativePreview && indicativeTransferAmount != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _buildRow(
              'Transfer principal after NobleCards fee',
              '$currency $symbol${formatter.format(indicativeTransferAmount)}',
              textColor,
              subTextColor,
              isBoldValue: true,
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          if (provider != null) ...[
            _buildRow(
              isIndicativePreview
                  ? 'Flutterwave provider fee'
                  : 'Provider fee',
              providerFeeText,
              textColor,
              subTextColor,
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildRow(
              nobleCardsFeeLabel,
              nobleCardsFeeText,
              textColor,
              subTextColor,
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildRow(
              isIndicativePreview
                  ? 'Costs (USD equivalent)'
                  : 'Total fee (USD)',
              totalFeeText,
              textColor,
              subTextColor,
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          _buildRow(
            isIndicativePreview ? 'Provider fee wallet' : 'Withdrawal fee',
            withdrawalFeeText,
            textColor,
            subTextColor,
          ),
          if (isIndicativePreview) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppRadius.xs),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Boxicons.bx_info_circle,
                        color: AppColors.error,
                        size: 16,
                      ),
                      SizedBox(width: AppSpacing.xs),
                      Text(
                        'Estimate Only — Payouts Disabled',
                        style: TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    [
                      ?indicativeProviderFeeMessage,
                      if (provider?.selectedCountry.id == 'CA')
                        'Canada (CAD) bank transfers are not currently supported by our payout integration.',
                      'Live payouts to this destination are disabled until provider corridor and account requirements are verified.',
                    ].join(' '),
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (showQuoteError) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${quoteProvider.isIndicativeRoute ? 'Estimate' : 'Quote'} unavailable: $quoteError',
              style: const TextStyle(color: AppColors.error, fontSize: 12),
            ),
          ],

          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: DashedDivider(color: borderColor),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  isIndicativePreview
                      ? 'Indicative recipient amount'
                      : 'You will receive',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
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
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: subTextColor, fontSize: 13),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: textColor,
              fontSize: 13,
              fontWeight: isBoldValue ? FontWeight.w600 : FontWeight.normal,
            ),
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
