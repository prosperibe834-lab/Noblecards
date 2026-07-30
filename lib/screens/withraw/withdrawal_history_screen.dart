import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glass_card.dart';
import 'models/withdrawal_models.dart';
import 'withdrawal_receipt_screen.dart';

class WithdrawalHistoryScreen extends StatefulWidget {
  const WithdrawalHistoryScreen({super.key});

  @override
  State<WithdrawalHistoryScreen> createState() => _WithdrawalHistoryScreenState();
}

class _WithdrawalHistoryScreenState extends State<WithdrawalHistoryScreen> {
  String _selectedFilter = 'All';
  String _searchQuery = '';

  final List<String> _filters = ['All', 'Completed', 'Processing', 'Pending', 'Failed'];

  final List<WithdrawalTransaction> _dummyHistory = [
    WithdrawalTransaction(
      id: '1',
      reference: 'REF-2026-072901',
      amountUsd: 250.0,
      receivedAmount: 408375.0,
      currency: 'NGN',
      exchangeRate: 1650.0,
      feeUsd: 2.50,
      methodTitle: 'Bank Account',
      recipientDetails: 'Access Bank •••• 7821',
      date: 'July 29, 2026',
      time: '02:15 PM',
      status: 'Completed',
    ),
    WithdrawalTransaction(
      id: '2',
      reference: 'REF-2026-072810',
      amountUsd: 100.0,
      receivedAmount: 78.0,
      currency: 'GBP',
      exchangeRate: 0.78,
      feeUsd: 1.50,
      methodTitle: 'Wise Transfer',
      recipientDetails: 'john@example.com',
      date: 'July 28, 2026',
      time: '11:00 AM',
      status: 'Processing',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final subTextColor = isDark ? AppColors.darkSubText : AppColors.lightSubText;

    final filteredList = _dummyHistory.where((txn) {
      final matchesFilter = _selectedFilter == 'All' || txn.status.toLowerCase() == _selectedFilter.toLowerCase();
      final matchesSearch = txn.reference.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          txn.recipientDetails.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Withdrawal History")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search reference or recipient...",
                prefixIcon: Icon(Boxicons.bx_search),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _filters.map((f) {
                final isSelected = _selectedFilter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(f),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedFilter = f),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final txn = filteredList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WithdrawalReceiptScreen(transaction: txn),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Boxicons.bx_transfer_alt, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(txn.methodTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text(txn.recipientDetails, style: TextStyle(color: subTextColor, fontSize: 12)),
                                Text("${txn.date} • ${txn.time}", style: TextStyle(color: subTextColor, fontSize: 10)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "${txn.currency} ${txn.receivedAmount.toStringAsFixed(2)}",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                txn.status,
                                style: TextStyle(
                                  color: txn.status == 'Completed' ? AppColors.success : Colors.orange,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}