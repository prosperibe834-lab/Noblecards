// Location: lib/deposit/widgets/deposit_balance_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme_provider.dart';
import '../providers/deposit_provider.dart';

class DepositBalanceCard extends StatelessWidget {
  const DepositBalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DepositProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyFormat = NumberFormat.currency(symbol: r'$', decimalDigits: 2);
    final numberFormat = NumberFormat("#,##0.00");

    final displayUsd = provider.baseWalletBalanceUsd > 0
        ? provider.baseWalletBalanceUsd
        : 2350.00;
    final displayConverted = provider.convertedWalletBalance > 0
        ? provider.convertedWalletBalance
        : (displayUsd * provider.selectedCurrency.exchangeRateToBase);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF072B20),
                  Color(0xFF031913),
                ],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF04875D),
                  Color(0xFF0EA371),
                  Color(0xFF10B981),
                ],
              ),
        border: isDark
            ? Border.all(
                color: const Color(0xFF10B981).withOpacity(0.55),
                width: 1.2,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(isDark ? 0.22 : 0.35),
            blurRadius: isDark ? 24 : 20,
            offset: const Offset(0, 8),
            spreadRadius: isDark ? -2 : 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: "Wallet Balance" + Eye & "View Wallet >"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Wallet Balance',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => provider.toggleBalanceVisibility(),
                    child: Icon(
                      provider.isBalanceVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.white.withOpacity(0.85),
                      size: 16,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF0E382B)
                        : Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF10B981).withOpacity(0.4)
                          : Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View Wallet',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.chevron_right, color: Colors.white, size: 14),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Main Balance: $2,350.00
          Text(
            provider.isBalanceVisible
                ? currencyFormat.format(displayUsd)
                : r'$ •••••••',
            style: const TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),

          // Sub-balance: 🇳🇬 ≈ NGN 4,043,820.00
          Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    provider.selectedCurrency.flagAsset,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                provider.isBalanceVisible
                    ? '≈ ${provider.selectedCurrency.code} ${numberFormat.format(displayConverted)}'
                    : '≈ •••••••',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
