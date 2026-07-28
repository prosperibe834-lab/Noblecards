import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class TransactionEmptyState extends StatelessWidget {
  final VoidCallback? onResetFilters;

  const TransactionEmptyState({Key? key, this.onResetFilters})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              ),
              child: Icon(
                Boxicons.bx_receipt,
                size: 48,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Transactions Found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'We couldn\'t find any records matching your search or applied filter parameters.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            if (onResetFilters != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onResetFilters,
                child: const Text('Reset All Filters'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
