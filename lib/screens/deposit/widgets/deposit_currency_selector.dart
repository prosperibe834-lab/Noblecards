// Location: lib/deposit/widgets/deposit_currency_selector.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme_provider.dart';
import '../providers/deposit_provider.dart';
import '../models/deposit_currency.dart';
import '../select_deposit_currency_screen.dart';
import '../favourite_currencies_screen.dart';

class DepositCurrencySelector extends StatelessWidget {
  const DepositCurrencySelector({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DepositProvider>();
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    // First 4 currencies matching the reference image: NGN, USD, GBP, CAD
    final displayCurrencies = supportedCurrencies.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Clickable Select Currency header with star boxicon
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FavouriteCurrenciesScreen()),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Select Currency',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Boxicons.bxs_star,
                    size: 16,
                    color: Color(0xFF10B981),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                final selected = await Navigator.push<DepositCurrency>(
                  context,
                  MaterialPageRoute(builder: (_) => const SelectDepositCurrencyScreen()),
                );
                if (selected != null) {
                  provider.setCurrency(selected);
                }
              },
              child: const Text(
                'Manage',
                style: TextStyle(
                  color: Color(0xFF10B981),
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: displayCurrencies.map((currency) {
            final isSelected = provider.selectedCurrency.code == currency.code;

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: GestureDetector(
                  onTap: () => provider.setCurrency(currency),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isDark ? const Color(0xFF10B981) : const Color(0xFFE8FDF3))
                          : (isDark ? const Color(0xFF13222E) : const Color(0xFFF8FAFC)),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF10B981)
                            : (isDark ? const Color(0xFF263545) : const Color(0xFFE2E8F0)),
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              currency.flagAsset,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          currency.code,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: isSelected
                                ? (isDark ? Colors.white : const Color(0xFF065F46))
                                : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155)),
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
