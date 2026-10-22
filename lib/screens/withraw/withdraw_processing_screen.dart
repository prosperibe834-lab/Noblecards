import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../authentication/services/authentication_service.dart';
import 'models/withdrawal_transaction_model.dart';
import 'withdraw_success_screen.dart';

import 'providers/withdraw_bank_provider.dart';

enum WithdrawalStatusRoute { success, pending, failed }

WithdrawalStatusRoute routeForWithdrawalStatus(String? rawStatus) {
  switch (rawStatus?.trim().toUpperCase()) {
    case 'SUCCESSFUL':
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
  final WithdrawalTransactionModel? transaction;
  final String? withdrawalId;
  final WithdrawBankProvider? provider;
  final String? pin;
  final AuthenticationService? authService;

  const WithdrawProcessingScreen({
    super.key,
    this.transaction,
    this.withdrawalId,
    this.provider,
    this.pin,
    this.authService,
  });

  @override
  State<WithdrawProcessingScreen> createState() =>
      _WithdrawProcessingScreenState();
}

class _WithdrawProcessingScreenState extends State<WithdrawProcessingScreen> {
  static const _statusChecks = 3;
  int _currentStage = 0;
  late final AuthenticationService _authService;
  final List<String> _stages = [
    "Verifying payout account details...",
    "Checking withdrawal limits & fees...",
    "Initiating transfer with payment provider...",
    "Finalizing withdrawal request...",
  ];

  @override
  void initState() {
    super.initState();
    _authService = widget.authService ?? AuthenticationService();
    _startSequence();
  }

  Future<Map<String, dynamic>> _executeWithdrawal(String withdrawalId) async {
    return _authService.authenticatedPost(
      '/withdrawals/$withdrawalId/execute',
    );
  }

  WithdrawalTransactionModel _withStatus(
    WithdrawalTransactionModel baseTransaction,
    String status, {
    String? failureReason,
  }) {
    return WithdrawalTransactionModel(
      amount: baseTransaction.amount,
      sourceAmount: baseTransaction.sourceAmount,
      sourceCurrency: baseTransaction.sourceCurrency,
      destinationAmount: baseTransaction.destinationAmount,
      destinationCurrency: baseTransaction.destinationCurrency,
      amountToSend: baseTransaction.amountToSend,
      exchangeRate: baseTransaction.exchangeRate,
      convertedAmount: baseTransaction.convertedAmount,
      fee: baseTransaction.fee,
      amountToReceive: baseTransaction.amountToReceive,
      currency: baseTransaction.currency,
      method: baseTransaction.method,
      destinationCountry: baseTransaction.destinationCountry,
      countryFlag: baseTransaction.countryFlag,
      destinationBank: baseTransaction.destinationBank,
      destinationAccountMasked: baseTransaction.destinationAccountMasked,
      referenceId: baseTransaction.referenceId,
      timestamp: baseTransaction.timestamp,
      status: status,
      failureReason: failureReason ?? baseTransaction.failureReason,
    );
  }

  double _requiredAmount(Map<String, dynamic> json, String key) {
    final value = json[key];
    final amount = value is num
        ? value.toDouble()
        : double.tryParse(value?.toString() ?? '');
    if (amount == null || !amount.isFinite) {
      throw FormatException('The backend returned an invalid withdrawal $key.');
    }
    return amount;
  }

  double? _optionalAmount(Object? value) {
    final amount = value is num
        ? value.toDouble()
        : double.tryParse(value?.toString() ?? '');
    return amount != null && amount.isFinite ? amount : null;
  }

  Future<String> _pollWithdrawalStatus({
    required String withdrawalId,
    String? knownStatus,
  }) async {
    var status = knownStatus?.toUpperCase() ?? 'UNDER_REVIEW';
    for (var attempt = 0; attempt < _statusChecks; attempt++) {
      try {
        final record = await _authService.authenticatedGet(
          '/withdrawals/$withdrawalId',
        );
        status = record['status']?.toString().toUpperCase() ?? status;
        final route = routeForWithdrawalStatus(status);
        if (route != WithdrawalStatusRoute.pending) return status;

        if (status == 'PROCESSING' || status == 'UNDER_REVIEW') {
          try {
            final result = await _authService.authenticatedPost(
              '/withdrawals/$withdrawalId/reconcile',
            );
            status = result['status']?.toString().toUpperCase() ?? status;
            if (routeForWithdrawalStatus(status) !=
                WithdrawalStatusRoute.pending) {
              return status;
            }
          } catch (error) {
            debugPrint('Withdrawal reconciliation is still pending: $error');
          }
        }
      } catch (error) {
        debugPrint('Unable to confirm withdrawal status yet: $error');
      }

      if (attempt + 1 < _statusChecks) {
        await Future<void>.delayed(const Duration(seconds: 1));
      }
    }
    return status == 'PENDING' || status == 'NEW' ? 'UNDER_REVIEW' : status;
  }

  Future<void> _showStatus(
    WithdrawalTransactionModel tx,
    String status, {
    String? failureReason,
  }) async {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => WithdrawSuccessScreen(
          transaction: _withStatus(
            tx,
            status,
            failureReason: failureReason,
          ),
        ),
      ),
    );
  }

  Future<void> _startSequence() async {
    WithdrawalTransactionModel? activeTx = widget.transaction;
    String? activeWithdrawalId = widget.withdrawalId;
    String status = 'UNDER_REVIEW';
    String? failureReason;

    try {
      if (widget.provider != null && widget.pin != null) {
        if (mounted) setState(() => _currentStage = 0);
        final withdrawal =
            await widget.provider!.createWithdrawal(widget.pin!);
        final withdrawalId = withdrawal['id']?.toString();
        final reference = withdrawal['reference']?.toString();
        final timestamp = DateTime.tryParse(
          withdrawal['createdAt']?.toString() ?? '',
        );
        final initialStatus = withdrawal['status']?.toString();
        final sourceCurrency = withdrawal['sourceCurrency']?.toString();
        final destinationCurrency =
            withdrawal['destinationCurrency']?.toString();
        final destinationCountry =
            withdrawal['destinationCountry']?.toString();

        if (withdrawalId == null ||
            withdrawalId.isEmpty ||
            reference == null ||
            reference.isEmpty ||
            timestamp == null ||
            initialStatus == null ||
            initialStatus.isEmpty ||
            sourceCurrency == null ||
            sourceCurrency.isEmpty ||
            destinationCurrency == null ||
            destinationCurrency.isEmpty ||
            destinationCountry == null ||
            destinationCountry.isEmpty) {
          throw const FormatException(
            'The backend returned incomplete withdrawal details.',
          );
        }

        activeWithdrawalId = withdrawalId;
        activeTx = WithdrawalTransactionModel(
          amount: _requiredAmount(withdrawal, 'recipientAmount'),
          sourceAmount: _requiredAmount(withdrawal, 'sourceAmount'),
          sourceCurrency: sourceCurrency,
          destinationAmount: _requiredAmount(withdrawal, 'destinationAmount'),
          destinationCurrency: destinationCurrency,
          amountToSend: _requiredAmount(withdrawal, 'sourceAmount'),
          exchangeRate: _requiredAmount(withdrawal, 'exchangeRate'),
          convertedAmount: _requiredAmount(withdrawal, 'destinationAmount'),
          fee: _optionalAmount(withdrawal['destinationFee']),
          amountToReceive: _requiredAmount(withdrawal, 'recipientAmount'),
          currency: destinationCurrency,
          method: 'Bank Transfer',
          destinationCountry: destinationCountry,
          countryFlag: widget.provider!.destination.flag,
          destinationBank:
              widget.provider!.selectedBank?.name ?? 'Bank Transfer',
          destinationAccountMasked: widget.provider!.maskedAccountNumber,
          referenceId: reference,
          timestamp: timestamp,
          status: initialStatus,
        );
      }
    } catch (error) {
      debugPrint('Withdrawal creation failed: $error');
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => WithdrawSuccessScreen(
            hasError: true,
            errorMessage: error.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
      return;
    }

    if (mounted) setState(() => _currentStage = 1);
    await Future<void>.delayed(const Duration(milliseconds: 300));

    if (mounted) setState(() => _currentStage = 2);
    try {
      final result = await _executeWithdrawal(activeWithdrawalId!);
      status = result['status']?.toString().toUpperCase() ?? 'UNDER_REVIEW';
      failureReason = result['failureReason']?.toString();
    } catch (error) {
      debugPrint('Withdrawal execution response is uncertain: $error');
      status = 'UNDER_REVIEW';
    }

    if (mounted) setState(() => _currentStage = 3);
    if (routeForWithdrawalStatus(status) == WithdrawalStatusRoute.pending) {
      status = await _pollWithdrawalStatus(
        withdrawalId: activeWithdrawalId!,
        knownStatus: status,
      );
    }

    await _showStatus(activeTx!, status, failureReason: failureReason);
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
