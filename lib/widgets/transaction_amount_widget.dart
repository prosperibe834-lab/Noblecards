import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

class TransactionAmountWidget extends StatelessWidget {
  final double amount;
  final String currency;
  final TransactionCategory category;
  final double fontSize;
  final bool showSymbol;

  const TransactionAmountWidget({
    Key? key,
    required this.amount,
    required this.currency,
    required this.category,
    this.fontSize = 16,
    this.showSymbol = true,
  }) : super(key: key);

  bool get _isIncome {
    return category == TransactionCategory.deposits ||
        category == TransactionCategory.giftCardSales ||
        category == TransactionCategory.refunds ||
        category == TransactionCategory.rewards ||
        category == TransactionCategory.bonuses ||
        category == TransactionCategory.cashback;
  }

  String _getCurrencySymbol() {
    switch (currency.toUpperCase()) {
      case 'USD':
        return '\$';
      case 'NGN':
        return '₦';
      case 'GBP':
        return '£';
      case 'EUR':
        return '€';
      case 'CAD':
        return 'CA\$';
      case 'AUD':
        return 'A\$';
      default:
        return currency;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final prefix = _isIncome ? '+' : '-';
    final amountColor = _isIncome
        ? const Color(0xFF10B981)
        : (isDark ? Colors.white : Colors.black87);

    final formattedAmount = amount.toStringAsFixed(2);

    return Text(
      '$prefix${showSymbol ? _getCurrencySymbol() : ''}$formattedAmount',
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: amountColor,
        letterSpacing: -0.5,
      ),
    );
  }
}