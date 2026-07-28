import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import 'receipt_footer.dart';
import 'receipt_header.dart';
import 'receipt_information_tile.dart';

class TransactionReceiptCard extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionReceiptCard({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          ReceiptHeader(transaction: transaction),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),
          ReceiptInformationTile(label: 'Receipt No.', value: transaction.receiptNumber, isCopyable: true),
          ReceiptInformationTile(label: 'Transaction ID', value: transaction.id, isCopyable: true),
          ReceiptInformationTile(label: 'Reference No.', value: transaction.referenceNumber, isCopyable: true),
          ReceiptInformationTile(label: 'Wallet ID', value: transaction.walletId, isCopyable: true),
          ReceiptInformationTile(label: 'Exchange Rate', value: transaction.exchangeRate),
          ReceiptInformationTile(label: 'Total Fee', value: '${transaction.currency} ${transaction.fees}'),
          ReceiptInformationTile(label: 'Prev. Balance', value: '${transaction.currency} ${transaction.previousBalance}'),
          ReceiptInformationTile(label: 'New Balance', value: '${transaction.currency} ${transaction.currentBalance}'),
          ReceiptInformationTile(label: 'Completed By', value: transaction.completedBy),
          ReceiptFooter(supportEmail: 'support@noblecards.com', supportPhone: '+1 (800) 892-0192'),
        ],
      ),
    );
  }
}