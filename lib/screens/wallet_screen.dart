import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../theme/app_theme.dart';
import '../theme/app_radius.dart';
import '../widgets/wallet_balance_card.dart';
import '../widgets/wallet_action_button.dart';
import '../widgets/wallet_transaction_tile.dart';
import 'deposit_screen.dart';
import 'withdraw_screen.dart';
import 'transaction_history_screen.dart';
import 'transaction_details_screen.dart';
import 'analytics_screen.dart';
import 'favorite_currencies_screen.dart';

import '../theme/app_colors.dart';

import '../theme/app_spacing.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Wallet',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Boxicons.bx_bell),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Boxicons.bx_history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TransactionHistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WalletBalanceCard(
              balance: 2350.00,
              onDeposit: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DepositScreen()),
                );
              },
              onWithdraw: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WithdrawScreen()),
                );
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                WalletActionButton(
                  icon: Boxicons.bx_plus,
                  label: 'Deposit',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DepositScreen()),
                    );
                  },
                ),
                WalletActionButton(
                  icon: Boxicons.bx_minus,
                  label: 'Withdraw',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WithdrawScreen()),
                    );
                  },
                ),
                WalletActionButton(
                  icon: Boxicons.bx_receipt,
                  label: 'History',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TransactionHistoryScreen()),
                    );
                  },
                ),
                WalletActionButton(
                  icon: Boxicons.bx_pie_chart_alt_2,
                  label: 'Analytics',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildExchangeRateCard(context, isDark),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TransactionHistoryScreen()),
                    );
                  },
                  child: const Text('See All'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            WalletTransactionTile(
              title: 'USD Wallet Deposit',
              date: 'Today, 2:30 PM',
              amount: 400.00,
              isDeposit: true,
              status: 'Successful',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TransactionDetailsScreen()),
                );
              },
            ),
            WalletTransactionTile(
              title: 'Bank Withdrawal',
              date: 'Yesterday, 10:15 AM',
              amount: 150.00,
              isDeposit: false,
              status: 'Successful',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TransactionDetailsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExchangeRateCard(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Boxicons.bx_refresh, color: AppColors.primary),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '1 USD = ₦1,620.00',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  Text(
                    'Live Exchange Rate',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Boxicons.bx_star, size: 20),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoriteCurrenciesScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
