import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import 'transaction_receipt_screen.dart';

/// Legacy redirect to the newly designed TransactionReceiptScreen
class TransactionDetailsScreen extends StatelessWidget {
  final TransactionModel? transaction;

  const TransactionDetailsScreen({Key? key, this.transaction})
    : super(key: key);

  static final TransactionModel _fallbackTransaction = TransactionModel(
    id: 'TXN-0000000000',
    receiptNumber: 'REC-DEFAULT-001',
    referenceNumber: 'REF-DEFAULT-001',
    walletId: 'NC-WAL-DEFAULT',
    title: 'Wallet Activity',
    category: TransactionCategory.deposits,
    amount: 0.00,
    currency: 'USD',
    amountSent: 0.00,
    currencySent: 'USD',
    amountReceived: 0.00,
    currencyReceived: 'USD',
    exchangeRate: '1:1',
    status: TransactionStatus.successful,
    date: DateTime.utc(2024, 1, 1),
    fees: 0.00,
    processingFee: 0.00,
    networkFee: 0.00,
    previousBalance: 0.00,
    currentBalance: 0.00,
    sender: 'NobleCards',
    receiver: 'Wallet',
    country: 'Nigeria',
    device: 'App',
    processingTime: 'Instant',
    completedBy: 'System',
  );

  @override
  Widget build(BuildContext context) {
    final resolvedTransaction = transaction ?? _fallbackTransaction;
    return TransactionReceiptScreen(transaction: resolvedTransaction);
  }
}
