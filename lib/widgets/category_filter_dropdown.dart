import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../models/transaction_model.dart';

class CategoryFilterDropdown extends StatelessWidget {
  final TransactionCategory selectedCategory;
  final ValueChanged<TransactionCategory?> onChanged;

  const CategoryFilterDropdown({
    Key? key,
    required this.selectedCategory,
    required this.onChanged,
  }) : super(key: key);

  String _getCategoryName(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.all:
        return 'All Categories';
      case TransactionCategory.deposits:
        return 'Deposits';
      case TransactionCategory.withdrawals:
        return 'Withdrawals';
      case TransactionCategory.giftCardPurchases:
        return 'Gift Card Purchases';
      case TransactionCategory.giftCardSales:
        return 'Gift Card Sales';
      case TransactionCategory.refunds:
        return 'Refunds';
      case TransactionCategory.rewards:
        return 'Rewards';
      case TransactionCategory.bonuses:
        return 'Bonuses';
      case TransactionCategory.transfers:
        return 'Transfers';
      case TransactionCategory.exchange:
        return 'Exchange';
      case TransactionCategory.fees:
        return 'Fees';
      case TransactionCategory.adjustments:
        return 'Adjustments';
      case TransactionCategory.cashback:
        return 'Cashback';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<TransactionCategory>(
          value: selectedCategory,
          isExpanded: true,
          icon: const Icon(Boxicons.bx_chevron_down, size: 20),
          items: TransactionCategory.values.map((cat) {
            return DropdownMenuItem<TransactionCategory>(
              value: cat,
              child: Row(
                children: [
                  const Icon(Boxicons.bx_category, size: 16),
                  const SizedBox(width: 8),
                  Text(_getCategoryName(cat), style: const TextStyle(fontSize: 13)),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}