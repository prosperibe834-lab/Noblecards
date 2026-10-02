import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noble_cards/screens/TransactionHistory/widgets/transaction_balance_card.dart';
import 'package:noble_cards/screens/TransactionHistory/widgets/transaction_filter_sheet.dart';
import 'package:noble_cards/screens/TransactionHistory/widgets/transaction_filter_tabs.dart';
import 'package:noble_cards/screens/TransactionHistory/models/transaction_history_model.dart';
import 'package:noble_cards/screens/TransactionHistory/widgets/transaction_list_item.dart';

void main() {
  testWidgets('balance eye toggles between visible and masked values', (tester) async {
    var isVisible = true;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => TransactionBalanceCard(
              isVisible: isVisible,
              balance: 1234.56,
              onToggleVisibility: () => setState(() => isVisible = !isVisible),
            ),
          ),
        ),
      ),
    );

    expect(find.text('\$1234.56'), findsOneWidget);
    await tester.tap(find.byIcon(Boxicons.bx_show));
    await tester.pumpAndSettle();
    expect(find.text('\$*******'), findsOneWidget);

    await tester.tap(find.byIcon(Boxicons.bx_hide));
    await tester.pumpAndSettle();
    expect(find.text('\$1234.56'), findsOneWidget);
  });

  testWidgets('filter tabs invoke the existing selection callback', (tester) async {
    final selectedTabs = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TransactionFilterTabs(
            activeTab: 'All',
            onTabChanged: selectedTabs.add,
          ),
        ),
      ),
    );

    for (final tab in ['All', 'Deposits', 'Withdrawals']) {
      await tester.tap(find.text(tab));
      expect(selectedTabs.last, tab);
    }
  });

  testWidgets('each transaction row invokes its own selected callback', (tester) async {
    final selectedIds = <String>[];
    final now = DateTime.now();
    final transactions = [
      TransactionHistoryModel(
        id: 'deposit-a', type: TransactionType.deposit, method: 'Bank Transfer',
        date: now, amount: 100, status: TransactionStatus.completed,
      ),
      TransactionHistoryModel(
        id: 'deposit-b', type: TransactionType.deposit, method: 'Card',
        date: now, amount: 200, status: TransactionStatus.pending,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView(
            children: transactions
                .map((transaction) => TransactionListItem(
                      transaction: transaction,
                      onTap: () => selectedIds.add(transaction.id),
                    ))
                .toList(),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TransactionListItem).at(0));
    await tester.tap(find.byType(TransactionListItem).at(1));
    expect(selectedIds, ['deposit-a', 'deposit-b']);
  });

  testWidgets('filter sheet applies selected filters and reset restores defaults', (tester) async {
    TransactionHistoryFilter? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                result = await TransactionFilterSheet.show(context);
              },
              child: const Text('Open filters'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open filters'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Withdrawals'));
    await tester.tap(find.text('Pending'));
    await tester.tap(find.text('7 Days'));
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Oldest'));
    await tester.tap(find.text('Apply Filters'));
    await tester.pumpAndSettle();

    expect(result?.type, 'Withdrawals');
    expect(result?.status, 'Pending');
    expect(result?.dateRange, '7 Days');
    expect(result?.sortBy, 'Oldest');

    await tester.tap(find.text('Open filters'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Deposits'));
    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();

    expect(result, const TransactionHistoryFilter());
  });
}