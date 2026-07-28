import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import 'custom_status_badge.dart';

class ReceiptHeader extends StatelessWidget {
  final TransactionModel transaction;

  const ReceiptHeader({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final logoPath = isDark
        ? 'assets/logos/DarkmodeLogo.png'
        : 'assets/logos/LightmodeLogo.png';

    return Column(
      children: [
        Image.asset(
          logoPath,
          height: 36,
          errorBuilder: (_, __, ___) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'NOBLE',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const Text(
                'CARDS',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          transaction.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          '${transaction.currency} ${transaction.amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Theme.of(context).primaryColor,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 16),
        CustomStatusBadge(
          label: transaction.status.name,
          color: Theme.of(context).primaryColor,
          icon: Icons.check_circle_outline,
        ),
      ],
    );
  }
}