import 'dart:async';
import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'models/withdrawal_request_model.dart';
import 'withdraw_success_screen.dart';

class WithdrawProcessingScreen extends StatefulWidget {
  final WithdrawalRequestModel request;

  const WithdrawProcessingScreen({
    super.key,
    required this.request,
  });

  @override
  State<WithdrawProcessingScreen> createState() => _WithdrawProcessingScreenState();
}

class _WithdrawProcessingScreenState extends State<WithdrawProcessingScreen> {
  int _currentStage = 0;
  final List<String> _stages = [
    "Verifying payout account details...",
    "Checking withdrawal limits & fees...",
    "Initiating transfer with payment provider...",
    "Finalizing withdrawal request..."
  ];

  @override
  void initState() {
    super.initState();
    _startSequence();
  }

  void _startSequence() {
    Timer.periodic(const Duration(milliseconds: 1300), (timer) {
      if (_currentStage < _stages.length - 1) {
        if (mounted) setState(() => _currentStage++);
      } else {
        timer.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => WithdrawSuccessScreen(request: widget.request),
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
                  textAlign: TextAlign.center,
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