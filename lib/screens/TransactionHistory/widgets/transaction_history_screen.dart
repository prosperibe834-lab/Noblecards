import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../services/wallet_service.dart';
import '../../deposit_receipt_screen.dart';
import '../../withraw/models/withdrawal_transaction_model.dart';
import '../../withraw/withdrawal_receipt_screen.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_text_theme.dart';

import '../models/transaction_history_model.dart';
import '../services/transaction_history_service.dart';
import 'transaction_balance_card.dart';
import 'transaction_summary_cards.dart';
import 'transaction_filter_tabs.dart';
import 'transaction_list_item.dart';
import 'transaction_filter_sheet.dart';
import 'transaction_history_shimmer.dart';
import 'transaction_history_empty_state.dart';
import 'transaction_history_error.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final TransactionHistoryService _service = TransactionHistoryService();
  final WalletService _walletService = WalletService();

  List<TransactionHistoryModel> _transactions = [];
  bool _isLoading = true;
  bool _hasError = false;

  bool _isBalanceVisible = true;
  TransactionHistoryFilter _filter = const TransactionHistoryFilter();
  double _walletBalance = 0;
  double _totalDeposits = 0;
  double _totalWithdrawals = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final results = await Future.wait<dynamic>([
        _walletService.getUsdBalance(),
        _service.fetchTransactions(),
      ]);
      final walletBalance = results[0] as double;
      final transactions = results[1] as List<TransactionHistoryModel>;

      final deposits = transactions.where((t) => t.type == TransactionType.deposit).toList();
      final withdrawals = transactions.where((t) => t.type == TransactionType.withdrawal).toList();

      setState(() {
        _walletBalance = walletBalance;
        _transactions = transactions;
        _totalDeposits = deposits.fold<double>(0, (sum, item) => sum + item.amount);
        _totalWithdrawals = withdrawals.fold<double>(0, (sum, item) => sum + item.amount);
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _openFilterSheet() async {
    final selectedType = await TransactionFilterSheet.show(
      context,
      initialFilter: _filter,
    );
    if (!mounted || selectedType == null) return;
    setState(() => _filter = selectedType);
  }

  List<TransactionHistoryModel> get _filteredTransactions {
    final now = DateTime.now();
    DateTime? startDate;
    DateTime? endDate;
    switch (_filter.dateRange) {
      case 'Today':
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case '7 Days':
        startDate = now.subtract(const Duration(days: 7));
        break;
      case '30 Days':
        startDate = now.subtract(const Duration(days: 30));
        break;
      case 'Custom':
        startDate = _filter.customDateRange?.start;
        endDate = _filter.customDateRange == null
            ? null
            : DateTime(
                _filter.customDateRange!.end.year,
                _filter.customDateRange!.end.month,
                _filter.customDateRange!.end.day,
                23,
                59,
                59,
                999,
              );
    }

    final filtered = _transactions.where((transaction) {
      final matchesType = _filter.type == 'All' ||
          (_filter.type == 'Deposits' && transaction.type == TransactionType.deposit) ||
          (_filter.type == 'Withdrawals' && transaction.type == TransactionType.withdrawal);
      final matchesStatus = _filter.status == 'All' ||
          (_filter.status == 'Completed' && transaction.status == TransactionStatus.completed) ||
          (_filter.status == 'Pending' &&
              (transaction.status == TransactionStatus.pending || transaction.status == TransactionStatus.processing)) ||
          (_filter.status == 'Failed' &&
              (transaction.status == TransactionStatus.failed || transaction.status == TransactionStatus.cancelled));
      final matchesDate = (startDate == null || !transaction.date.isBefore(startDate)) &&
          (endDate == null || !transaction.date.isAfter(endDate));
      return matchesType && matchesStatus && matchesDate;
    }).toList();

    switch (_filter.sortBy) {
      case 'Oldest':
        filtered.sort((left, right) => left.date.compareTo(right.date));
        break;
      case 'Highest Amount':
        filtered.sort((left, right) => right.amount.compareTo(left.amount));
        break;
      default:
        filtered.sort((left, right) => right.date.compareTo(left.date));
    }
    return filtered;
  }

  Future<void> _openTransaction(TransactionHistoryModel transaction) async {
    if (transaction.id.trim().isEmpty) {
      _showReceiptError('This transaction has no receipt ID.');
      return;
    }

    try {
      if (transaction.type == TransactionType.deposit) {
        final details = await _service.fetchDepositDetails(transaction.id);
        final date = DateTime.tryParse(
          (details['createdAt'] ?? details['updatedAt'] ?? '').toString(),
        );
        final amount = _requiredAmount(details, 'amount');
        final convertedUsd = _requiredAmount(details, 'netAmount');
        final currency = (details['currencyCode'] ?? details['currency'] ?? '')
            .toString();
        final reference = (details['transactionReference'] ??
                details['transactionId'] ??
                details['id'] ??
                '')
            .toString();
        final status = (details['transactionStatus'] ?? details['status'] ?? '')
            .toString();
        final paymentMethod =
            (details['paymentMethod'] ?? details['provider'] ?? '').toString();
        if (date == null || currency.isEmpty || reference.isEmpty || status.isEmpty || paymentMethod.isEmpty) {
          throw const FormatException('Deposit details are incomplete.');
        }
        if (!mounted) return;
        await Navigator.of(context).push<void>(
          MaterialPageRoute(
            builder: (_) => DepositReceiptScreen(
              amount: amount,
              currency: currency,
              convertedUsd: convertedUsd,
              depositId: details['id']?.toString(),
              transactionId: details['transactionId']?.toString(),
              transactionReference: reference,
              status: status,
              fee: _requiredAmount(details, 'fee'),
              paymentMethod: _formatLabel(paymentMethod),
              provider: details['provider']?.toString(),
              providerReference: details['providerReference']?.toString(),
              providerTransactionId: details['providerTransactionId']?.toString(),
              transactionDate: date,
            ),
          ),
        );
        return;
      }

      final details = await _service.fetchWithdrawalDetails(transaction.id);
      final receipt = WithdrawalTransactionModel.fromBackendJson(details);
      if (!mounted) return;
      await Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) => WithdrawalReceiptScreen(
            transaction: receipt,
            returnToPreviousScreen: true,
          ),
        ),
      );
    } catch (_) {
      _showReceiptError('Unable to load this transaction receipt.');
    }
  }

  double _requiredAmount(Map<String, dynamic> details, String key) {
    final value = details[key];
    final amount = value is num
        ? value.toDouble()
        : double.tryParse(value?.toString() ?? '');
    if (amount == null || !amount.isFinite) {
      throw FormatException('Transaction details have an invalid $key.');
    }
    return amount;
  }

  String _formatLabel(String value) => value
      .split('_')
      .map((part) => part.isEmpty ? part : '${part[0]}${part.substring(1).toLowerCase()}')
      .join(' ');

  void _showReceiptError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final btnBg = isDark ? AppColors.darkCard : AppColors.lightCard;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: Container(
              decoration: BoxDecoration(color: btnBg, shape: BoxShape.circle),
              child: Icon(Boxicons.bx_chevron_left, color: textColor),
            ),
          ),
        ),
        title: Text(
          'Transaction History',
          style: AppTextTheme.light.titleLarge?.copyWith(
            color: textColor,
            fontSize: 18,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: _openFilterSheet,
              borderRadius: BorderRadius.circular(AppRadius.full),
              child: Container(
                width: 40,
                decoration: BoxDecoration(color: btnBg, shape: BoxShape.circle),
                child: Icon(Boxicons.bx_slider_alt, color: textColor),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        color: AppColors.primary,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  children: [
                    TransactionBalanceCard(
                      isVisible: _isBalanceVisible,
                      onToggleVisibility: () {
                        if (!mounted) return;
                        setState(() => _isBalanceVisible = !_isBalanceVisible);
                      },
                      balance: _walletBalance,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TransactionSummaryCards(
                      totalDeposits: _totalDeposits,
                      totalWithdrawals: _totalWithdrawals,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TransactionFilterTabs(
                      activeTab: _filter.type,
                      onTabChanged: (tab) => setState(() {
                        _filter = TransactionHistoryFilter(
                          type: tab,
                          status: _filter.status,
                          dateRange: _filter.dateRange,
                          sortBy: _filter.sortBy,
                          customDateRange: _filter.customDateRange,
                        );
                      }),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              sliver: _buildListContent(),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
          ],
        ),
      ),
    );
  }

  Widget _buildListContent() {
    if (_isLoading) {
      return const SliverToBoxAdapter(child: TransactionHistoryShimmer());
    }

    if (_hasError) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: 300,
          child: TransactionHistoryError(onRetry: _loadData),
        ),
      );
    }

    final data = _filteredTransactions;

    if (data.isEmpty) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: 300,
          child: TransactionHistoryEmptyState(
            onReset: _loadData,
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return TransactionListItem(
            transaction: data[index],
            onTap: () => _openTransaction(data[index]),
          );
        },
        childCount: data.length,
      ),
    );
  }
}