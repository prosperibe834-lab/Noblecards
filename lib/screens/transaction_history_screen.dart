import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/wallet_transaction_tile.dart';
import 'transaction_details_screen.dart';

import '../theme/app_colors.dart';

import '../theme/app_spacing.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: const CustomAppBar(title: 'Transaction History'),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          WalletTransactionTile(
            title: 'Deposit USD',
            date: 'Today, 2:30 PM',
            amount: 400.0,
            isDeposit: true,
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
    );
  }
}
