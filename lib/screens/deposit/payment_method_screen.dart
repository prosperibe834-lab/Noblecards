// Location: lib/deposit/payment_method_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/theme_provider.dart';

import 'models/deposit_currency.dart';
import 'providers/payment_method_provider.dart';
import 'widgets/deposit_progress_indicator.dart';
import 'widgets/payment_method_intro_card.dart';
import 'widgets/payment_method_tile.dart';
import 'widgets/payment_method_security_card.dart';
import 'widgets/payment_method_help_bottom_sheet.dart';
import 'widgets/payment_method_shimmer.dart';

import '../card_payment_screen.dart';
import '../bank_transfer_screen.dart';
import '../gbp_bank_payment_screen.dart';

class PaymentMethodScreen extends StatelessWidget {
  final double amount;
  final DepositCurrency currency;
  final double amountInUsd;

  const PaymentMethodScreen({
    super.key,
    this.amount = 0.0,
    this.currency = const DepositCurrency(
      code: 'NGN',
      symbol: '₦',
      name: 'Nigerian Naira',
      flagAsset: '🇳🇬',
      exchangeRateToBase: 1650.0,
      isPopular: true,
      country: 'Nigeria',
      region: 'Africa',
    ),
    this.amountInUsd = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PaymentMethodProvider(),
      child: _PaymentMethodScreenContent(
        amount: amount,
        currency: currency,
        amountInUsd: amountInUsd,
      ),
    );
  }
}

class _PaymentMethodScreenContent extends StatelessWidget {
  final double amount;
  final DepositCurrency currency;
  final double amountInUsd;

  const _PaymentMethodScreenContent({
    required this.amount,
    required this.currency,
    required this.amountInUsd,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final theme = Theme.of(context);
    final provider = context.watch<PaymentMethodProvider>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? AppColors.darkText : AppColors.lightText),
          onPressed: () => Navigator.of(context).pop(), 
        ),
        title: Text('Payment Method', style: theme.textTheme.titleLarge?.copyWith(fontSize: 18)),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: isDark ? AppColors.darkSubText : AppColors.lightSubText),
            onPressed: () => showPaymentMethodHelpSheet(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const DepositProgressIndicator(),
            
            Expanded(
              child: provider.isLoading 
                ? const Padding(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: PaymentMethodShimmer(),
                  )
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppSpacing.md),
                        const PaymentMethodIntroCard(),
                        const SizedBox(height: AppSpacing.xl),
                        
                        Text('Recommended', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: AppSpacing.sm),
                        
                        // List of Payment Methods
                        ...provider.methods.map((method) => PaymentMethodTile(method: method)),
                        
                        const SizedBox(height: AppSpacing.sm),
                        const PaymentMethodSecurityCard(),
                        const SizedBox(height: AppSpacing.xxl),
                      ],
                    ),
                  ),
            ),
            
            // Fixed Bottom Continue Button
            Container(
              padding: const EdgeInsets.only(left: AppSpacing.lg, right: AppSpacing.lg, bottom: AppSpacing.md, top: AppSpacing.sm),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.05),
                    offset: const Offset(0, -10),
                    blurRadius: 20,
                  )
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: provider.hasValidSelection ? () {
                    final method = provider.selectedMethod!;
                    final effectiveUsd = amountInUsd > 0
                        ? amountInUsd
                        : (currency.code == 'USD'
                            ? amount
                            : (currency.exchangeRateToBase > 0 ? amount / currency.exchangeRateToBase : amount));

                    if (method.id == 'card') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CardPaymentScreen(
                            amount: amount,
                            currency: currency.code,
                            requestedUsdAmount: effectiveUsd,
                          ),
                        ),
                      );
                    } else if (method.id == 'bank_transfer') {
                      if (currency.code == 'GBP') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GbpBankPaymentScreen(
                              amount: amount,
                              currency: currency.code,
                              convertedUsd: effectiveUsd,
                            ),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BankTransferScreen(
                              amount: amount,
                              currency: currency.code,
                              convertedUsd: effectiveUsd,
                            ),
                          ),
                        );
                      }
                    } else {
                      // Apple Pay / Wire transfer routes through CardPaymentScreen with card/wallet options
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CardPaymentScreen(
                            amount: amount,
                            currency: currency.code,
                            requestedUsdAmount: effectiveUsd,
                          ),
                        ),
                      );
                    }
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.primary.withOpacity(0.3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.full)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: provider.hasValidSelection ? Colors.white : Colors.white.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Icon(Icons.arrow_forward, color: provider.hasValidSelection ? Colors.white : Colors.white.withOpacity(0.5), size: 20),
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
}
