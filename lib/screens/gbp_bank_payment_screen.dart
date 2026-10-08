import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../models/deposit_model.dart';
import '../services/deposits_service.dart';
import '../widgets/glass_card.dart';
import '../widgets/deposit_step_indicator.dart';
import 'authentication/services/authentication_service.dart';
import 'deposit_screen.dart';

class GbpBankPaymentScreen extends StatefulWidget {
  final double amount;
  final String currency;
  final double convertedUsd;

  const GbpBankPaymentScreen({
    super.key,
    required this.amount,
    required this.currency,
    required this.convertedUsd,
  });

  @override
  State<GbpBankPaymentScreen> createState() => _GbpBankPaymentScreenState();
}

class _GbpBankPaymentScreenState extends State<GbpBankPaymentScreen> {
  late DepositsService _depositsService;
  late Future<Deposit> _depositFuture;
  String? _authorizationUrl;
  bool _isOpeningUrl = false;
  String _authToken = '';

  @override
  void initState() {
    super.initState();
    _initializeAndCreateDeposit();
  }

  Future<void> _initializeAndCreateDeposit() async {
    print('[GBP DEPOSIT] Original entered amount: ${widget.amount}');
    print('[GBP DEPOSIT] Selected currency: ${widget.currency}');
    print('[GBP DEPOSIT] Converted USD: ${widget.convertedUsd}');
    print('[GBP DEPOSIT] GBP amount sent to Flutterwave: ${widget.amount}');

    if (widget.currency == 'GBP' && widget.amount > 3719) {
      _depositFuture = Future.error(
        'GBP bank transfer supports amounts up to £3,719 per transaction.',
      );
      if (mounted) setState(() {});
      return;
    }

    final authService = AuthenticationService();
    _authToken = (await authService.getAccessToken()) ?? '';

    _depositsService = DepositsService(
      httpClient: http.Client(),
      getAuthToken: () => _authToken,
    );

    _depositFuture = _depositsService
        .createDeposit(
          amount: widget.amount,
          currency: widget.currency,
          paymentMethod: 'BANK_TRANSFER',
          country: 'United Kingdom',
          countryCode: 'GB',
          idempotencyKey: '${widget.currency}-${widget.amount}-${DateTime.now().millisecondsSinceEpoch}',
        )
        .then((deposit) {
          if (mounted) {
            setState(() {
              _authorizationUrl = deposit.authorizationUrl;
            });
          }
          return deposit;
        });

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _openAuthorizationUrl() async {
    if (_authorizationUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authorization URL not available')),
      );
      return;
    }

    setState(() {
      _isOpeningUrl = true;
    });

    try {
      final Uri url = Uri.parse(_authorizationUrl!);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open authorization URL')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isOpeningUrl = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'UK Bank Payment',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<Deposit>(
        future: _depositFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  const Text('Setting up your payment...'),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            final errorText = snapshot.error.toString();
            final isAmountLimit = errorText.contains('£3,719') || errorText.contains('3,719');

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const DepositStepIndicator(currentStep: 3),
                  const SizedBox(height: 32),
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    isAmountLimit
                        ? 'Amount Limit Exceeded'
                        : 'Payment Setup Failed',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    errorText.replaceFirst('Exception: ', '').replaceFirst('Error: ', ''),
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  GlassCard(
                    onTap: () => Navigator.of(context).pop(),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 24,
                    ),
                    child: const Text(
                      'Go Back',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          final deposit = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DepositStepIndicator(currentStep: 3),
                const SizedBox(height: 32),
                Expanded(
                  child: ListView(
                    children: [
                      const Text(
                        'Complete Your Payment',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'You will be redirected to securely authorize your UK bank account payment',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 32),
                      GlassCard(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Payment Details',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Amount:'),
                                Text(
                                  '${deposit.currency} ${deposit.amount}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Payment Method:'),
                                Text(
                                  'UK Bank Account',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Status:'),
                                Text(
                                  deposit.status.toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange[400],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.info_outline, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'What happens next:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              '1. Click "Complete Payment" below\n'
                              '2. You will be securely redirected to authorize the payment\n'
                              '3. Follow the bank authorization process\n'
                              '4. Return to NobleCards when complete\n'
                              '5. Your GBP will be instantly credited',
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: GlassCard(
                    onTap: _isOpeningUrl ? null : _openAuthorizationUrl,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Center(
                      child: _isOpeningUrl
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'Complete Payment',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
