import 'dart:async';
import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'deposit_success_screen.dart';
import 'cards/giftcard_submission_received_screen.dart';

class DepositProcessingScreen extends StatefulWidget {
  final double amount;
  final String currency;
  final double convertedUsd;
  final bool returnToPreviousScreen;
  final bool navigateToSubmissionReceived;
  final String transactionId;

  const DepositProcessingScreen({
    super.key,
    required this.amount,
    required this.currency,
    required this.convertedUsd,
    this.returnToPreviousScreen = false,
    this.navigateToSubmissionReceived = false,
    this.transactionId = '',
  });

  @override
  State<DepositProcessingScreen> createState() => _DepositProcessingScreenState();
}

class _DepositProcessingScreenState extends State<DepositProcessingScreen> {
  int _currentStage = 0;
  final List<String> _stages = [
    "Checking bank settlement...",
    "Verifying payment reference...",
    "Confirming deposit amount...",
    "Crediting USD Wallet..."
  ];

  @override
  void initState() {
    super.initState();
    _startSequence();
  }

  void _startSequence() {
    Timer.periodic(const Duration(milliseconds: 1200), (timer) {
      if (_currentStage < _stages.length - 1) {
        if (mounted) setState(() => _currentStage++);
      } else {
        timer.cancel();
        if (widget.navigateToSubmissionReceived) {
          final transactionId = widget.transactionId.isNotEmpty
              ? widget.transactionId
              : 'sale-${DateTime.now().millisecondsSinceEpoch}';
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => GiftcardSubmissionReceivedScreen(transactionId: transactionId),
            ),
          );
          return;
        }
        if (widget.returnToPreviousScreen) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          return;
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DepositSuccessScreen(
              amount: widget.amount,
              currency: widget.currency,
              convertedUsd: widget.convertedUsd,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      strokeWidth: 6,
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                    ),
                  ),
                  const Icon(Boxicons.bx_transfer, size: 40, color: Colors.blue),
                ],
              ),
              const SizedBox(height: 32),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  _stages[_currentStage],
                  key: ValueKey<int>(_currentStage),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Please do not close this screen",
                style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.grey),
              )
            ],
          ),
        ),
      ),
    );
  }
}