import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
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
  const TransactionHistoryScreen({Key? key}) : super(key: key);

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final TransactionHistoryService _service = TransactionHistoryService();
  
  List<TransactionHistoryModel> _transactions = [];
  bool _isLoading = true;
  bool _hasError = false;
  
  bool _isBalanceVisible = true;
  String _activeTab = 'All';

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
      final data = await _service.fetchTransactions();
      setState(() {
        _transactions = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _openFilterSheet() async {
    final selectedType = await TransactionFilterSheet.show(
      context,
      initialType: _activeTab,
    );
    if (!mounted || selectedType == null) return;
    setState(() => _activeTab = selectedType);
  }

  List<TransactionHistoryModel> get _filteredTransactions {
    if (_activeTab == 'Deposits') {
      return _transactions.where((t) => t.type == TransactionType.deposit).toList();
    } else if (_activeTab == 'Withdrawals') {
      return _transactions.where((t) => t.type == TransactionType.withdrawal).toList();
    }
    return _transactions;
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
                      balance: 2450.80, // Bound this to user wallet state eventually
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const TransactionSummaryCards(
                      totalDeposits: 4320.00,
                      totalWithdrawals: 1869.20,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TransactionFilterTabs(
                      activeTab: _activeTab,
                      onTabChanged: (tab) => setState(() => _activeTab = tab),
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
            onReset: () => setState(() => _activeTab = 'All'),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return TransactionListItem(
            transaction: data[index],
            onTap: () {
              // Stub for Transaction Details routing. 
              // Reusing existing architecture if available.
            },
          );
        },
        childCount: data.length,
      ),
    );
  }
}