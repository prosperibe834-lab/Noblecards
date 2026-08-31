import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'package:http/http.dart' as http;
import '../models/deposit_model.dart';
import '../services/deposits_service.dart';
import '../widgets/glass_card.dart';
import '../widgets/copy_button.dart';
import '../widgets/countdown_timer_card.dart';
import 'authentication/services/authentication_service.dart';
import 'deposit_processing_screen.dart';
import 'deposit_screen.dart';

class BankTransferScreen extends StatefulWidget {
  final double amount;
  final String currency;
  final double convertedUsd;

  const BankTransferScreen({
    super.key,
    required this.amount,
    required this.currency,
    required this.convertedUsd,
  });

  @override
  State<BankTransferScreen> createState() => _BankTransferScreenState();
}

class _BankTransferScreenState extends State<BankTransferScreen> {
  late DepositsService _depositsService;
  Deposit? _deposit;
  bool _isLoading = true;
  bool _isVerifying = false;
  String? _errorMessage;
  String _authToken = '';

  @override
  void initState() {
    super.initState();
    _initializeAndCreateDeposit();
  }

  Future<void> _initializeAndCreateDeposit() async {
    try {
      final authService = AuthenticationService();
      _authToken = (await authService.getAccessToken()) ?? '';

      if (_authToken.isEmpty) {
        if (!mounted) return;
        setState(() {
          _errorMessage = 'Your login session has expired. Please log in again.';
          _isLoading = false;
        });
        return;
      }

      _depositsService = DepositsService(
        httpClient: http.Client(),
        getAuthToken: () => _authToken,
      );

      final deposit = await _depositsService.createDeposit(
        amount: widget.amount,
        currency: widget.currency,
        paymentMethod: 'BANK_TRANSFER',
        country: 'Nigeria',
        countryCode: 'NG',
        idempotencyKey: '${widget.currency}-${widget.amount}-${DateTime.now().millisecondsSinceEpoch}',
      );

      if (mounted) {
        setState(() {
          _deposit = deposit;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _onPaymentConfirmed() async {
    if (_deposit == null || _isVerifying) return;

    setState(() => _isVerifying = true);

    try {
      final navigator = Navigator.of(context);
      var foundDepositScreen = false;

      navigator.popUntil((route) {
        if (route is DepositScreen) {
          foundDepositScreen = true;
          return true;
        }
        return false;
      });

      if (!foundDepositScreen) {
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const DepositScreen()),
          (route) => false,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isVerifying = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Pay via Bank Transfer", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null || _deposit == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Pay via Bank Transfer", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Boxicons.bx_error_circle, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: ${_errorMessage ?? 'Failed to create virtual account'}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final bankDetails = _deposit!.bankTransfer;
    if (bankDetails == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Pay via Bank Transfer", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        ),
        body: const Center(
          child: Text('No bank details available'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pay via Bank Transfer", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Countdown Timer
            CountdownTimerCard(
              expiryTime: bankDetails.expiresAt,
              onExpired: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Virtual Account Expired. Please generate a new one.")),
                );
              },
            ),

            const SizedBox(height: 16),

            // Details Card - Using Real Data from Backend
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildDetailRow(context, "Bank Name", bankDetails.bankName),
                  const Divider(height: 24),
                  _buildDetailRow(context, "Account Number", bankDetails.accountNumber, isCopyable: true),
                  const Divider(height: 24),
                  _buildDetailRow(context, "Account Name", bankDetails.accountName),
                  const Divider(height: 24),
                  _buildDetailRow(context, "Amount", "${bankDetails.currency} ${bankDetails.amount.toStringAsFixed(2)}", isBold: true),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Instruction Note
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Boxicons.bx_info_circle, color: Colors.amber, size: 22),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Transfer the EXACT amount above. Deposit is credited automatically within 60 seconds.",
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.amber),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Payment Confirmation CTA
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: _isVerifying ? null : _onPaymentConfirmed,
                child: _isVerifying
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        "I Have Made The Transfer",
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, {bool isCopyable = false, bool isBold = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            color: isDark ? Colors.white60 : Colors.black54,
          ),
        ),
        Row(
          children: [
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: isBold ? 16 : 14,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              ),
            ),
            if (isCopyable) ...[
              const SizedBox(width: 8),
              CopyButton(textToCopy: value),
            ]
          ],
        )
      ],
    );
  }
}