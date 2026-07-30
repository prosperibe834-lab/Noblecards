import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../models/transaction_model.dart';
import '../../widgets/animated_success_widget.dart';
import '../../widgets/glass_card.dart';
import 'models/withdrawal_request_model.dart';
import 'withdrawal_receipt_screen.dart';

class WithdrawSuccessScreen extends StatelessWidget {
  final WithdrawalRequestModel request;

  const WithdrawSuccessScreen({
    super.key,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const AnimatedSuccessWidget(size: 100),
              const SizedBox(height: 24),
              const Text(
                "Withdrawal Requested!",
                style: TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "Your payout request is being processed.",
                style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildRow("Requested Amount", "${request.currency} ${request.amount.toStringAsFixed(2)}"),
                    const Divider(height: 20),
                    _buildRow("Payout Method", request.method.name),
                    const Divider(height: 20),
                    _buildRow("Destination Account", request.destinationAccount, isHighlight: true),
                    const Divider(height: 20),
                    _buildRow("Transaction Ref", request.referenceNumber, isBold: true),
                  ],
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  icon: const Icon(Boxicons.bx_receipt),
                  label: const Text(
                    "View Official Receipt",
                    style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    final transactionModel = TransactionModel(
                      id: request.referenceNumber,
                      receiptNumber: 'REC-${request.referenceNumber}',
                      referenceNumber: request.referenceNumber,
                      walletId: 'NC-WAL-USD',
                      title: 'Wallet Withdrawal',
                      category: TransactionCategory.withdrawals,
                      amount: request.amount,
                      currency: request.currency,
                      amountSent: request.amount,
                      currencySent: request.currency,
                      amountReceived: request.netAmount,
                      currencyReceived: request.currency,
                      exchangeRate: '1:1',
                      status: TransactionStatus.successful,
                      date: DateTime.now(),
                      fees: request.fee,
                      processingFee: request.fee,
                      networkFee: 0.00,
                      previousBalance: 1000.00,
                      currentBalance: 1000.00 - request.amount,
                      sender: 'NobleCards USD Wallet',
                      receiver: '${request.method.name} (${request.destinationAccount})',
                      country: 'Nigeria',
                      device: 'Mobile App',
                      processingTime: 'Instant',
                      completedBy: 'System',
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WithdrawalReceiptScreen(transaction: transactionModel),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                  child: const Text("Done", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isHighlight = false, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.grey)),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: isHighlight ? 15 : 14,
            fontWeight: (isHighlight || isBold) ? FontWeight.bold : FontWeight.w600,
            color: isHighlight ? Colors.blue : null,
          ),
        ),
      ],
    );
  }
}