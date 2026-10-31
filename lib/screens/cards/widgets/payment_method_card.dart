import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'package:noble_cards/theme/app_colors.dart';
import 'package:noble_cards/theme/app_radius.dart';
import 'package:noble_cards/theme/app_spacing.dart';
import 'package:noble_cards/services/wallet_service.dart';

class PaymentMethodCard extends StatefulWidget {
  const PaymentMethodCard({Key? key}) : super(key: key);

  @override
  State<PaymentMethodCard> createState() => _PaymentMethodCardState();
}

class _PaymentMethodCardState extends State<PaymentMethodCard> {
  double _balance = WalletService.cachedBalances?.availableBalance ?? 0.0;
  bool _isLoading = WalletService.cachedBalances == null;

  @override
  void initState() {
    super.initState();
    _loadBalance();
  }

  Future<void> _loadBalance() async {
    try {
      final balances = await WalletService().getUsdWalletBalances();
      if (mounted) {
        setState(() {
          _balance = balances.availableBalance;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subTextColor = isDark
        ? AppColors.darkSubText
        : AppColors.lightSubText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Icon(Boxicons.bx_wallet, color: AppColors.primary),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NobleCards Wallet',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _isLoading
                          ? 'Available Balance: Loading...'
                          : 'Available Balance: \$${_balance.toStringAsFixed(2)}',
                      style: TextStyle(color: subTextColor, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Boxicons.bxs_check_circle, color: AppColors.primary),
            ],
          ),
        ),
      ],
    );
  }
}
