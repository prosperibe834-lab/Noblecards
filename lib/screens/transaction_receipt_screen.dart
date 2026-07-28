import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../models/transaction_model.dart';
import '../widgets/download_receipt_button.dart';
import '../widgets/report_transaction_button.dart';
import '../widgets/share_receipt_button.dart';
import '../widgets/transaction_receipt_card.dart';
import '../widgets/transaction_timeline.dart';

class TransactionReceiptScreen extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionReceiptScreen({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Boxicons.bx_arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Official Receipt', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Boxicons.bx_share_alt),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TransactionReceiptCard(transaction: transaction),
            const SizedBox(height: 20),
            TransactionTimeline(steps: transaction.timelineSteps),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: DownloadReceiptButton(onPressed: () {}),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ShareReceiptButton(onPressed: () {}),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ReportTransactionButton(onPressed: () {}),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}