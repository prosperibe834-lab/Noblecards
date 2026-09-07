import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'package:intl/intl.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../TransactionPin/pin_auth_dialog.dart';
import 'models/withdrawal_transaction_model.dart';
import 'providers/withdraw_bank_provider.dart';
import 'widgets/withdraw_stepper.dart';
import 'withdraw_processing_screen.dart';

// IMPORTANT: Import your existing PinAuthDialog here.
// import '../../widgets/pin_auth_dialog.dart';

class WithdrawReviewScreen extends StatelessWidget {
  final WithdrawBankProvider provider;

  const WithdrawReviewScreen({super.key, required this.provider});

  Future<void> _showPinDialog(BuildContext context) async {
    final authorized = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => PinAuthDialog(onSuccess: (_) {}),
    );

    if (!context.mounted || authorized != true) return;

    final transaction = WithdrawalTransactionModel(
      amount: provider.amountToReceive,
      sourceAmount: provider.amountToSend,
      sourceCurrency: 'USD',
      destinationAmount: provider.convertedAmount,
      destinationCurrency: provider.destination.currency,
      amountToSend: provider.amountToSend,
      exchangeRate: provider.exchangeRate,
      convertedAmount: provider.convertedAmount,
      fee: provider.fee,
      amountToReceive: provider.amountToReceive,
      currency: provider.destination.currency,
      method: 'Bank Transfer',
      destinationCountry: provider.destination.countryName,
      countryFlag: provider.destination.flag,
      destinationBank: provider.selectedBank?.name ?? 'Bank Transfer',
      destinationAccountMasked: provider.maskedAccountNumber,
      referenceId: 'WD-${DateTime.now().millisecondsSinceEpoch}',
      timestamp: DateTime.now(),
      status: 'completed',
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WithdrawProcessingScreen(transaction: transaction),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final formatCurrency = NumberFormat.currency(symbol: '', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Boxicons.bx_chevron_left, color: textColor, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Review Withdrawal",
          style: TextStyle(
            fontFamily: "Poppins",
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Boxicons.bx_help_circle, color: textColor),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const WithdrawStepper(currentStep: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    children: [
                      _buildReviewRow(
                        context,
                        "You send",
                        "\$${formatCurrency.format(provider.amountToSend)} USD",
                      ),
                      _buildDivider(borderColor),

                      _buildReviewRow(
                        context,
                        "Destination",
                        "${provider.destination.countryName} ${provider.destination.flag}",
                      ),
                      _buildDivider(borderColor),

                      _buildReviewRow(context, "Method", "Bank Transfer"),
                      _buildDivider(borderColor),

                      if (provider.selectedBank != null) ...[
                        _buildReviewRow(
                          context,
                          "Bank",
                          provider.selectedBank!.name,
                        ),
                        _buildDivider(borderColor),
                      ],

                      _buildReviewRow(
                        context,
                        "Account",
                        provider.maskedAccountNumber,
                      ),
                      _buildDivider(borderColor),

                      if (provider.destination.countryCode != 'US') ...[
                        _buildReviewRow(
                          context,
                          "Exchange rate",
                          "1 USD = ${provider.destination.currency}${formatCurrency.format(provider.exchangeRate)}",
                        ),
                        _buildDivider(borderColor),
                      ],

                      _buildReviewRow(
                        context,
                        "Converted amount",
                        "${provider.destination.currency} ${formatCurrency.format(provider.convertedAmount)}",
                      ),
                      _buildDivider(borderColor),

                      _buildReviewRow(
                        context,
                        "Withdrawal fee",
                        "${provider.destination.currency} ${formatCurrency.format(provider.fee)}",
                      ),
                      _buildDivider(borderColor),

                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "You will receive",
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(fontSize: 16),
                          ),
                          Text(
                            "${provider.destination.currency} ${formatCurrency.format(provider.amountToReceive)}",
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontSize: 18,
                                  color: AppColors.success,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: [
                  const Icon(
                    Boxicons.bx_check_shield,
                    color: AppColors.success,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    "Please review all details carefully before confirming.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.md,
                bottom: AppSpacing.lg,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _showPinDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Confirm & Continue",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Icon(Boxicons.bx_right_arrow_alt, color: AppColors.white),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(Color color) {
    return Divider(color: color.withOpacity(0.5), height: AppSpacing.md);
  }
}
