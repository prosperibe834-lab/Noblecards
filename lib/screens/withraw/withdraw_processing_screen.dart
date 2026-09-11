import 'dart:async';
import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../authentication/services/authentication_service.dart';
import 'models/withdrawal_transaction_model.dart';
import 'withdraw_success_screen.dart';

enum WithdrawalStatusRoute { success, pending, failed }

WithdrawalStatusRoute routeForWithdrawalStatus(String? rawStatus) {
  switch (rawStatus?.trim().toUpperCase()) {
    case 'SUCCESSFUL':
    case 'SUCCESS':
    case 'COMPLETED':
      return WithdrawalStatusRoute.success;
    case 'FAILED':
      return WithdrawalStatusRoute.failed;
    case 'PROCESSING':
    case 'PENDING':
    case 'NEW':
    case 'UNDER_REVIEW':
    default:
      return WithdrawalStatusRoute.pending;
  }
}

class WithdrawProcessingScreen extends StatefulWidget {
  final WithdrawalTransactionModel transaction;
  final String withdrawalId;

  const WithdrawProcessingScreen({
    super.key,
    required this.transaction,
    required this.withdrawalId,
  });

  @override
  State<WithdrawProcessingScreen> createState() =>
      _WithdrawProcessingScreenState();
}

class _WithdrawProcessingScreenState extends State<WithdrawProcessingScreen> {
  int _currentStage = 0;
  final List<String> _stages = [
    "Verifying payout account details...",
    "Checking withdrawal limits & fees...",
    "Initiating transfer with payment provider...",
    "Finalizing withdrawal request...",
  ];

  @override
  void initState() {
    super.initState();
    _startSequence();
  }

  Future<Map<String, dynamic>> _executeWithdrawal() async {
    return AuthenticationService().authenticatedPost(
      '/withdrawals/${widget.withdrawalId}/execute',
    );
  }

  Future<void> _startSequence() async {
    try {
      final result = await _executeWithdrawal();
      final status = result['status']?.toString().toUpperCase() ?? 'UNKNOWN';
      final route = routeForWithdrawalStatus(status);
      if (route == WithdrawalStatusRoute.pending) {
        if (!mounted) return;
        final statusAwareTransaction = WithdrawalTransactionModel(
          amount: widget.transaction.amount,
          sourceAmount: widget.transaction.sourceAmount,
          sourceCurrency: widget.transaction.sourceCurrency,
          destinationAmount: widget.transaction.destinationAmount,
          destinationCurrency: widget.transaction.destinationCurrency,
          amountToSend: widget.transaction.amountToSend,
          exchangeRate: widget.transaction.exchangeRate,
          convertedAmount: widget.transaction.convertedAmount,
          fee: widget.transaction.fee,
          amountToReceive: widget.transaction.amountToReceive,
          currency: widget.transaction.currency,
          method: widget.transaction.method,
          destinationCountry: widget.transaction.destinationCountry,
          countryFlag: widget.transaction.countryFlag,
          destinationBank: widget.transaction.destinationBank,
          destinationAccountMasked: widget.transaction.destinationAccountMasked,
          referenceId: widget.transaction.referenceId,
          timestamp: widget.transaction.timestamp,
          status: status,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => WithdrawSuccessScreen(
              transaction: statusAwareTransaction,
            ),
          ),
        );
        return;
      }
      if (route == WithdrawalStatusRoute.failed) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => WithdrawSuccessScreen(
              transaction: widget.transaction,
              hasError: true,
              errorMessage: 'Your withdrawal could not be completed.',
            ),
          ),
        );
        return;
      }
    } catch (error) {
      if (!mounted) return;
      final message = error.toString().replaceFirst('Exception: ', '').trim();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => WithdrawSuccessScreen(
            transaction: widget.transaction,
            hasError: true,
            errorMessage: message.isEmpty ? null : message,
            onRetry: _startSequence,
          ),
        ),
      );
      return;
    }

    Timer.periodic(const Duration(milliseconds: 1300), (timer) {
      if (_currentStage < _stages.length - 1) {
        if (mounted) setState(() => _currentStage++);
      } else {
        timer.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                WithdrawSuccessScreen(transaction: widget.transaction),
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
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const Icon(
                    Boxicons.bx_transfer,
                    size: 40,
                    color: Colors.blue,
                  ),
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
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Please do not close this screen",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
