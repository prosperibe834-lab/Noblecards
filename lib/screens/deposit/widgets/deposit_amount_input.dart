// Location: lib/deposit/widgets/deposit_amount_input.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/theme_provider.dart';
import '../providers/deposit_provider.dart';

class DepositAmountInput extends StatefulWidget {
  const DepositAmountInput({super.key});

  @override
  State<DepositAmountInput> createState() => _DepositAmountInputState();
}

class _DepositAmountInputState extends State<DepositAmountInput> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    // Initialize with provider's initial amount if available
    final initialAmt = context.read<DepositProvider>().manualAmount;
    if (initialAmt > 0) {
      _controller.text = initialAmt.toStringAsFixed(initialAmt.truncateToDouble() == initialAmt ? 0 : 2);
    }

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DepositProvider>();
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final numberFormat = NumberFormat("#,##0.00");

    // Keep text controller in sync if quick amount selection changes externally
    if (provider.selectedQuickAmount != null && provider.manualAmount > 0) {
      final formatted = provider.manualAmount.toStringAsFixed(
        provider.manualAmount.truncateToDouble() == provider.manualAmount ? 0 : 2,
      );
      if (_controller.text != formatted && !_focusNode.hasFocus) {
        _controller.text = formatted;
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
      }
    }

    // Equivalent conversion calculation
    final equivalentValue = provider.manualAmount > 0
        ? (provider.manualAmount * 1650.0 / provider.selectedCurrency.exchangeRateToBase)
        : 0.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF13222E) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _isFocused
              ? const Color(0xFF10B981)
              : (isDark ? const Color(0xFF263545) : const Color(0xFFE2E8F0)),
          width: _isFocused ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: _isFocused
                ? const Color(0xFF10B981).withOpacity(isDark ? 0.18 : 0.12)
                : Colors.black.withOpacity(isDark ? 0.2 : 0.03),
            blurRadius: _isFocused ? 12 : 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Label & Currency Pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Deposit Amount',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1C2D3B) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      provider.selectedCurrency.flagAsset,
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      provider.selectedCurrency.code,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Main Input Field Row: Symbol + Amount + Clear Button
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                provider.selectedCurrency.symbol,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    letterSpacing: 0.5,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: '0.00',
                    hintStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.2),
                    ),
                  ),
                  onChanged: (val) {
                    final amount = double.tryParse(val) ?? 0.0;
                    provider.setManualAmount(amount);
                  },
                ),
              ),
              if (_controller.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    _controller.clear();
                    provider.setManualAmount(0.0);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Boxicons.bx_x_circle,
                      size: 20,
                      color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),

          // Sub-row: Equivalent in NGN + Fee tag
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Boxicons.bx_transfer_alt,
                    size: 13,
                    color: Color(0xFF10B981),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    provider.manualAmount > 0
                        ? '≈ ₦ ${numberFormat.format(equivalentValue)}'
                        : 'Enter amount to calculate rate',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Instant Deposit',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF10B981),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
