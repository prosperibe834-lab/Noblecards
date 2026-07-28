import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../models/transaction_model.dart';
import '../widgets/search_transaction_field.dart';
import '../widgets/transaction_card.dart';
import '../widgets/transaction_empty_state.dart';
import '../widgets/transaction_filter_dropdown.dart';
import '../widgets/transaction_loading.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({Key? key}) : super(key: key);

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  TransactionCategory _selectedCategory = TransactionCategory.all;
  TransactionStatus? _selectedStatus;
  String _selectedDateFilter = 'All Time';
  String _selectedAmountFilter = 'All';
  String _selectedCurrencyFilter = 'All';
  String _selectedCardFilter = 'All';
  String _selectedSort = 'Newest First';

  final List<TransactionModel> _mockTransactions = [
    TransactionModel(
      id: 'TXN-9842049128',
      receiptNumber: 'REC-20260728-001',
      referenceNumber: 'REF-884920194',
      walletId: 'NC-WAL-772910',
      title: 'Amazon Gift Card Sale',
      category: TransactionCategory.giftCardSales,
      giftCardName: 'Amazon',
      giftCardRegion: 'US',
      giftCardCategory: 'E-code',
      amount: 250.00,
      currency: 'USD',
      amountSent: 250.00,
      currencySent: 'USD',
      amountReceived: 370000.00,
      currencyReceived: 'NGN',
      exchangeRate: '1 USD = 1,480 NGN',
      status: TransactionStatus.successful,
      date: DateTime.now().subtract(const Duration(hours: 2)),
      fees: 2.50,
      processingFee: 1.50,
      networkFee: 1.00,
      previousBalance: 1200.00,
      currentBalance: 1447.50,
      bankName: 'Noble Wallet',
      sender: 'NobleCards Engine',
      receiver: 'John Doe',
      country: 'Nigeria',
      device: 'iPhone 15 Pro Max',
      processingTime: '1.2s',
      completedBy: 'System Auto-Settlement',
    ),
    TransactionModel(
      id: 'TXN-9842049129',
      receiptNumber: 'REC-20260728-002',
      referenceNumber: 'REF-884920195',
      walletId: 'NC-WAL-772910',
      title: 'Wallet Deposit',
      category: TransactionCategory.deposits,
      amount: 500.00,
      currency: 'USD',
      amountSent: 500.00,
      currencySent: 'USD',
      amountReceived: 500.00,
      currencyReceived: 'USD',
      exchangeRate: '1:1',
      status: TransactionStatus.successful,
      date: DateTime.now().subtract(const Duration(days: 1)),
      fees: 0.00,
      processingFee: 0.00,
      networkFee: 0.00,
      previousBalance: 700.00,
      currentBalance: 1200.00,
      sender: 'Card Payment Gateway',
      receiver: 'Noble Wallet',
      country: 'United States',
      device: 'Android',
      processingTime: '0.8s',
      completedBy: 'Stripe Gateway',
    ),
    TransactionModel(
      id: 'TXN-9842049130',
      receiptNumber: 'REC-20260728-003',
      referenceNumber: 'REF-884920196',
      walletId: 'NC-WAL-772910',
      title: 'Apple Gift Card Purchase',
      category: TransactionCategory.giftCardPurchases,
      giftCardName: 'Apple',
      amount: 100.00,
      currency: 'USD',
      amountSent: 100.00,
      currencySent: 'USD',
      amountReceived: 100.00,
      currencyReceived: 'USD',
      exchangeRate: '1:1',
      status: TransactionStatus.pending,
      date: DateTime.now().subtract(const Duration(days: 2)),
      fees: 1.00,
      processingFee: 1.00,
      networkFee: 0.00,
      previousBalance: 800.00,
      currentBalance: 699.00,
      sender: 'John Doe',
      receiver: 'Apple Inc.',
      country: 'Nigeria',
      device: 'Web App',
      processingTime: 'In Queue',
      completedBy: 'Pending Audit',
    ),
  ];

  List<TransactionModel> get _filteredTransactions {
    return _mockTransactions.where((txn) {
      final query = _searchController.text.toLowerCase();
      if (query.isNotEmpty) {
        final matchesQuery = txn.title.toLowerCase().contains(query) ||
            txn.id.toLowerCase().contains(query) ||
            (txn.giftCardName != null && txn.giftCardName!.toLowerCase().contains(query));
        if (!matchesQuery) return false;
      }
      if (_selectedCategory != TransactionCategory.all && txn.category != _selectedCategory) {
        return false;
      }
      if (_selectedStatus != null && txn.status != _selectedStatus) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Boxicons.bx_arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Transaction History', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Boxicons.bx_bell),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() => _isLoading = true);
          await Future.delayed(const Duration(seconds: 1));
          setState(() => _isLoading = false);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 12),
              SearchTransactionField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                onClear: () {
                  _searchController.clear();
                  setState(() {});
                },
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(
                      width: 160,
                      child: TransactionFilterDropdown<TransactionCategory>(
                        label: 'Category',
                        value: _selectedCategory,
                        items: TransactionCategory.values,
                        itemLabelExtractor: (cat) => cat.name,
                        onChanged: (val) => setState(() => _selectedCategory = val ?? TransactionCategory.all),
                        icon: Boxicons.bx_category,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 140,
                      child: TransactionFilterDropdown<String>(
                        label: 'Date',
                        value: _selectedDateFilter,
                        items: const ['All Time', 'Today', 'This Month', 'This Year'],
                        itemLabelExtractor: (val) => val,
                        onChanged: (val) => setState(() => _selectedDateFilter = val ?? 'All Time'),
                        icon: Boxicons.bx_calendar,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _isLoading
                    ? const TransactionLoading()
                    : _filteredTransactions.isEmpty
                        ? TransactionEmptyState(
                            onResetFilters: () {
                              setState(() {
                                _searchController.clear();
                                _selectedCategory = TransactionCategory.all;
                                _selectedStatus = null;
                              });
                            },
                          )
                        : ListView.builder(
                            itemCount: _filteredTransactions.length,
                            itemBuilder: (context, index) {
                              return TransactionCard(
                                transaction: _filteredTransactions[index],
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}