import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'package:intl/intl.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../providers/withdraw_provider.dart';

class WithdrawBalanceCard extends StatelessWidget {
  final WithdrawProvider provider;

  const WithdrawBalanceCard({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat("#,##0.00", "en_US");
    final equivalentFormatter = NumberFormat("#,##0.00", "en_US");

    // Calculate total equivalent for display
    final totalEquivalent =
        provider.availableBalance * provider.selectedCountry.exchangeRate;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Subtle decorative curves
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            left: -30,
            bottom: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Available Balance',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    GestureDetector(
                      onTap: provider.toggleBalanceVisibility,
                      child: Icon(
                        provider.isBalanceVisible
                            ? Boxicons.bx_show
                            : Boxicons.bx_hide,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      provider.isBalanceVisible
                          ? '\$${formatter.format(provider.availableBalance)}'
                          : '••••••',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.xs),
                      ),
                      child: const Text(
                        'USD',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: provider.setMaxAmount,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        child: const Text(
                          'Max',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Equivalent in ${provider.selectedCountry.currency} ${provider.selectedCountry.currency == 'NGN' ? '₦' : ''}${equivalentFormatter.format(totalEquivalent)}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
