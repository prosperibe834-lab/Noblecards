import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_radius.dart';
import 'models/withdraw_bank_models.dart';
import 'providers/withdraw_provider.dart';
import 'widgets/withdraw_balance_card.dart';
import 'widgets/withdraw_amount_section.dart';
import 'widgets/withdraw_destination_section.dart';
import 'widgets/withdraw_method_section.dart';
import 'widgets/withdraw_summary_card.dart';
import 'withdraw_bank_details_screen.dart';
import '../BottomNavigation/main_navigation_screen.dart';
import '../../localization/app_localizations.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  late WithdrawProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = WithdrawProvider();
    _provider.reloadData(); // Triggers initial loading state simulation
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  void _showHelpDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('withdrawal_help', fallback: 'Withdrawal Help'),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Withdrawals usually take 5-15 minutes depending on the chosen method. The applicable fees and exchange rate are shown in your quote.',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkSubText
                        : AppColors.lightSubText,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                    ),
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(context.tr('understood', fallback: 'Understood')),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleContinue() async {
    if (_provider.parsedAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid amount'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    final availableBalance = _provider.availableBalance;
    if (availableBalance == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to load your available balance.')),
      );
      return;
    }
    if (_provider.parsedAmount > availableBalance) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Amount exceeds available balance'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (_provider.selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a withdrawal method'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (_provider.isIndicativeRoute) {
      if (!_provider.isIndicativePreview) {
        await _provider.refreshIndicativePreviewNow();
      }
      if (!mounted) return;
      if (!_provider.isIndicativePreview) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _provider.dataError ?? 'Unable to generate indicative estimate.',
            ),
          ),
        );
        return;
      }
      final methodId = _provider.selectedMethod?.id ?? 'bank';
      final paymentMethod =
          methodId == 'bank' ? 'BANK_TRANSFER' : 'MOBILE_MONEY';
      final destination = WithdrawalDestination(
        countryCode: _provider.selectedCountry.id,
        countryName: _provider.selectedCountry.name,
        currency: _provider.selectedCountry.currency,
        flag: _provider.selectedCountry.flagInitials,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WithdrawBankDetailsScreen(
            destination: destination,
            paymentMethod: paymentMethod,
            sourceAmount: _provider.parsedAmount,
            initialQuoteId: null,
          ),
        ),
      );
      return;
    }

    await _provider.refreshQuoteNow();
    if (!mounted) return;
    if (!_provider.hasQuote || _provider.quoteId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _provider.dataError ?? 'Unable to create a withdrawal quote.',
          ),
        ),
      );
      return;
    }

    final methodId = _provider.selectedMethod?.id ?? 'bank';
    final paymentMethod = methodId == 'bank' ? 'BANK_TRANSFER' : 'MOBILE_MONEY';
    final destination = WithdrawalDestination(
      countryCode: _provider.selectedCountry.id,
      countryName: _provider.selectedCountry.name,
      currency: _provider.selectedCountry.currency,
      flag: _provider.selectedCountry.flagInitials,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WithdrawBankDetailsScreen(
          destination: destination,
          paymentMethod: paymentMethod,
          sourceAmount: _provider.parsedAmount,
          initialQuoteId: _provider.quoteId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final bgColor = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: borderColor),
            ),
            child: Icon(Boxicons.bx_chevron_left, color: textColor, size: 20),
          ),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => MainNavigationScreen(),
                ),
                (route) => false,
              );
            }
          },
        ),
        title: Text(
          context.tr('withdraw_funds', fallback: 'Withdraw Funds'),
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: AppSpacing.md,
              top: 8,
              bottom: 8,
            ),
            child: InkWell(
              onTap: () => _showHelpDialog(context),
              borderRadius: BorderRadius.circular(AppRadius.full),
              child: Container(
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor),
                ),
                child: Icon(
                  Boxicons.bx_question_mark,
                  color: textColor,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _provider,
        builder: (context, _) {
          if (_provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        // Logo
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Boxicons.bx_cube_alt,
                              color: AppColors.primary,
                              size: 28,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              'NOBLECARDS',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Balance Card
                        WithdrawBalanceCard(provider: _provider),
                        const SizedBox(height: AppSpacing.lg),

                        // Section 1: Amount
                        WithdrawAmountSection(provider: _provider),
                        const SizedBox(height: AppSpacing.lg),

                        // Section 2: Destination
                        WithdrawDestinationSection(provider: _provider),
                        const SizedBox(height: AppSpacing.lg),

                        // Section 3: Method
                        WithdrawMethodSection(provider: _provider),
                        const SizedBox(height: AppSpacing.lg),

                        // Summary
                        WithdrawSummaryCard(provider: _provider),
                        const SizedBox(height: AppSpacing.xl),
                      ],
                    ),
                  ),
                ),
                // Bottom Continue Button
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: _provider.isQuoteLoading
                          ? null
                          : _handleContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            context.tr('continue', fallback: 'Continue'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          const Icon(
                            Boxicons.bx_right_arrow_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
