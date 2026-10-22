import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../widgets/transaction_loading.dart';
import '../authentication/services/authentication_service.dart';
import 'models/withdrawal_transaction_model.dart';

class WithdrawalHistoryScreen extends StatefulWidget {
  final AuthenticationService? authService;

  const WithdrawalHistoryScreen({super.key, this.authService});

  @override
  State<WithdrawalHistoryScreen> createState() =>
      _WithdrawalHistoryScreenState();
}

class _WithdrawalHistoryScreenState extends State<WithdrawalHistoryScreen> {
  late final AuthenticationService _authService;
  bool _isLoading = true;
  String? _error;
  List<WithdrawalTransactionModel> _withdrawals = [];

  @override
  void initState() {
    super.initState();
    _authService = widget.authService ?? AuthenticationService();
    _loadWithdrawals();
  }

  Future<void> _loadWithdrawals() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final records = await _authService.authenticatedGetList('/withdrawals');
      _withdrawals = records.map((record) {
        if (record is! Map) {
          throw const FormatException(
            'Withdrawal history contains an invalid record.',
          );
        }
        return WithdrawalTransactionModel.fromBackendJson(
          Map<String, dynamic>.from(record),
        );
      }).toList();
    } catch (error) {
      _withdrawals = [];
      _error = error.toString().replaceFirst('Exception: ', '');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Boxicons.bx_arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Withdrawal History",
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _isLoading
            ? const TransactionLoading()
            : _error != null
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_error!, textAlign: TextAlign.center),
                    TextButton(
                      onPressed: _loadWithdrawals,
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              )
            : _withdrawals.isEmpty
            ? const Center(child: Text('No withdrawals yet.'))
            : ListView.separated(
                itemCount: _withdrawals.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final withdrawal = _withdrawals[index];
                  final formatter = NumberFormat('#,##0.00', 'en_US');
                  final beneficiary = withdrawal.destinationBank.isEmpty
                      ? 'Bank'
                      : withdrawal.destinationBank;
                  final account = withdrawal.destinationAccountMasked;

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    tileColor: Theme.of(context).cardColor,
                    leading: const CircleAvatar(
                      backgroundColor: Colors.redAccent,
                      child: Icon(
                        Boxicons.bx_up_arrow_alt,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      withdrawal.method == 'Bank Transfer'
                          ? 'Bank Withdrawal'
                          : '${withdrawal.method} Withdrawal',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      account.isEmpty ? beneficiary : '$beneficiary • $account',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '-${withdrawal.sourceCurrency} '
                          '${formatter.format(withdrawal.sourceAmount)}',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                        Text(
                          _displayStatus(withdrawal.status),
                          style:
                              const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 11,
                              ).copyWith(
                                color:
                                    const {
                                      'SUCCESSFUL',
                                      'SUCCESS',
                                      'COMPLETED',
                                    }.contains(withdrawal.status.toUpperCase())
                                    ? Colors.green
                                    : null,
                              ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  String _displayStatus(String status) => status
      .replaceAll('_', ' ')
      .toLowerCase()
      .split(' ')
      .map(
        (word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1)}',
      )
      .join(' ');
}
