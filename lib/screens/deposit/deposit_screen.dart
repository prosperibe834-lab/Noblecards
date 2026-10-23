// Location: lib/deposit/deposit_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_colors.dart';
import '../../theme/theme_provider.dart';
import '../../providers/wallet_provider.dart';

import 'providers/deposit_provider.dart';
import 'payment_method_screen.dart';
import 'widgets/deposit_balance_card.dart';
import 'widgets/deposit_currency_selector.dart';
import 'widgets/deposit_amount_input.dart';
import 'widgets/deposit_quick_amounts.dart';
import 'widgets/deposit_info_card.dart';
import 'widgets/recent_deposits_section.dart';
import 'widgets/deposit_help_bottom_sheet.dart';
import 'widgets/deposit_header_graphic.dart';

class DepositScreen extends StatelessWidget {
  const DepositScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    final initialBalance = walletProvider.balance;

    return ChangeNotifierProvider(
      create: (_) => DepositProvider(initialWalletBalanceUsd: initialBalance),
      child: const _DepositScreenContent(),
    );
  }
}

class _DepositScreenContent extends StatefulWidget {
  const _DepositScreenContent();

  @override
  State<_DepositScreenContent> createState() => _DepositScreenContentState();
}

class _DepositScreenContentState extends State<_DepositScreenContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final balance = context.read<WalletProvider>().balance;
      context.read<DepositProvider>().updateWalletBalance(balance);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final provider = context.watch<DepositProvider>();
    final balance = context.watch<WalletProvider>().balance;

    if (balance != provider.baseWalletBalanceUsd) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          provider.updateWalletBalance(balance);
        }
      });
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar (Circular back & help buttons)
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? const Color(0xFF13222E) : Colors.white,
                        border: Border.all(
                          color: isDark ? const Color(0xFF263545) : const Color(0xFFE2E8F0),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.arrow_back,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => showDepositHelpBottomSheet(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? const Color(0xFF13222E) : Colors.white,
                        border: Border.all(
                          color: isDark ? const Color(0xFF263545) : const Color(0xFFE2E8F0),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.help_outline,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Intro Section: "Deposit Funds" & 3D wallet graphic
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Deposit Funds',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w800,
                                  fontSize: 26,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Add funds to your NobleCards wallet and get started.',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DepositHeaderGraphic(isDark: isDark),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // 1. Wallet Balance Card
                    const DepositBalanceCard(),
                    const SizedBox(height: 22),

                    // 2. Currency Selector
                    const DepositCurrencySelector(),
                    const SizedBox(height: 20),

                    // 3. Deposit Amount Input
                    const DepositAmountInput(),
                    const SizedBox(height: 18),

                    // 4. Quick Amounts
                    const DepositQuickAmounts(),
                    const SizedBox(height: 20),

                    // 4. Fast & Secure Deposits Card
                    const DepositInfoCard(),
                    const SizedBox(height: 20),

                    // 5. Recent Deposits Section
                    const RecentDepositsSection(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom Action Button: "Continue to Payment ->"
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.35 : 0.04),
                    offset: const Offset(0, -4),
                    blurRadius: 16,
                  )
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PaymentMethodScreen(
                          amount: provider.manualAmount,
                          currency: provider.selectedCurrency,
                          amountInUsd: provider.amountInUsd,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF10B981),
                          Color(0xFF059669),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF10B981).withOpacity(isDark ? 0.45 : 0.35),
                          blurRadius: isDark ? 20 : 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Continue to Payment',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                      ],
                    ),
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
