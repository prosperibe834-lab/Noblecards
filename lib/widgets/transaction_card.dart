import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../models/transaction_model.dart';
import '../screens/transaction_receipt_screen.dart';
import 'transaction_amount_widget.dart';
import 'transaction_status_chip.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionCard({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  IconData _getCategoryIcon() {
    switch (transaction.category) {
      case TransactionCategory.deposits:
        return Boxicons.bx_down_arrow_alt;
      case TransactionCategory.withdrawals:
        return Boxicons.bx_up_arrow_alt;
      case TransactionCategory.giftCardPurchases:
      case TransactionCategory.giftCardSales:
        return Boxicons.bx_gift;
      case TransactionCategory.refunds:
        return Boxicons.bx_undo;
      case TransactionCategory.rewards:
      case TransactionCategory.bonuses:
      case TransactionCategory.cashback:
        return Boxicons.bx_trophy;
      case TransactionCategory.transfers:
        return Boxicons.bx_transfer_alt;
      case TransactionCategory.exchange:
        return Boxicons.bx_refresh;
      default:
        return Boxicons.bx_receipt;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TransactionReceiptScreen(transaction: transaction),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    _getCategoryIcon(),
                    color: theme.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${transaction.id} • ${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TransactionAmountWidget(
                      amount: transaction.amount,
                      currency: transaction.currency,
                      category: transaction.category,
                      fontSize: 15,
                    ),
                    const SizedBox(height: 6),
                    TransactionStatusChip(
                      status: transaction.status,
                      isCompact: true,
                    ),
                  ],
                ),
                const SizedBox(width: 6),
                Icon(
                  Boxicons.bx_chevron_right,
                  color: isDark ? Colors.grey[600] : Colors.grey[400],
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}