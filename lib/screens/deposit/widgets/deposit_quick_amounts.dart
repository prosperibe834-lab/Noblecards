// Location: lib/deposit/widgets/deposit_quick_amounts.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme_provider.dart';
import '../providers/deposit_provider.dart';

class DepositQuickAmounts extends StatelessWidget {
  const DepositQuickAmounts({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DepositProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Exact quick amounts from reference image: $10, $25, $50, $100
    final quickAmounts = [10.0, 25.0, 50.0, 100.0];
    final currencyFormat = NumberFormat.currency(symbol: r'$', decimalDigits: 0);
    final ngnFormat = NumberFormat.currency(symbol: '₦', decimalDigits: 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Amount',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: quickAmounts.map((amount) {
            final isSelected = provider.selectedQuickAmount == amount;
            final nairAmount = amount * 1650.0;

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: GestureDetector(
                  onTap: () => provider.setQuickAmount(amount),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isDark ? const Color(0xFF0D3B2E) : const Color(0xFFE8FDF3))
                          : (isDark ? const Color(0xFF13222E) : Colors.white),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF10B981)
                            : (isDark ? const Color(0xFF263545) : const Color(0xFFE2E8F0)),
                        width: isSelected ? 1.5 : 1.0,
                      ),
                      boxShadow: isDark
                          ? null
                          : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              )
                            ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          currencyFormat.format(amount),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: isSelected
                                ? (isDark ? Colors.white : const Color(0xFF065F46))
                                : (isDark ? Colors.white : const Color(0xFF0F172A)),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '≈ ${ngnFormat.format(nairAmount)}',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? (isDark ? const Color(0xFF34D399) : const Color(0xFF047857))
                                : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
