import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../theme/app_radius.dart';
import '../widgets/wallet_balance_card.dart';
import '../widgets/wallet_action_button.dart';
import '../widgets/wallet_transaction_tile.dart';
import 'deposit_screen.dart';
import 'withraw/withdraw_screen.dart';
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
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Balance Card ---
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

            // --- 2. Quick Actions Container ---
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.sm,
                horizontal: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.05),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
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
                        MaterialPageRoute(
                          builder: (_) => const TransactionHistoryScreen(),
                        ),
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
            ),

            const SizedBox(height: AppSpacing.lg),

            // --- 3. Exchange Rate Card ---
            _buildExchangeRateCard(context, isDark),

            const SizedBox(height: AppSpacing.lg),

            // --- 4. Recent Transactions Header ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TransactionHistoryScreen(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'See All',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          Boxicons.bx_chevron_right,
                          size: 18,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.sm),

            // --- 5. Grouped Transactions Surface ---
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.05),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Column(
                children: [
                  WalletTransactionTile(
                    title: 'USD Wallet Deposit',
                    date: 'Today, 2:30 PM',
                    amount: 400.00,
                    isDeposit: true,
                    status: 'Successful',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TransactionDetailsScreen(),
                        ),
                      );
                    },
                  ),
                  Divider(
                    height: 1,
                    thickness: 0.8,
                    indent: 16,
                    endIndent: 16,
                    color: isDark ? Colors.white10 : Colors.black12,
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
                        MaterialPageRoute(
                          builder: (_) => const TransactionDetailsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
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
