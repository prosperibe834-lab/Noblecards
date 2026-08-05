import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../models/order_model.dart';

class OrdersFilterBottomSheet extends StatefulWidget {
  final OrderStatus? initialStatus;
  final TransactionType? initialType;
  final String? initialGiftCard;
  final String? initialSort;
  final Function(OrderStatus?, TransactionType?, String?, String?) onApply;
  final VoidCallback onReset;

  const OrdersFilterBottomSheet({
    super.key,
    this.initialStatus,
    this.initialType,
    this.initialGiftCard,
    this.initialSort,
    required this.onApply,
    required this.onReset,
  });

  @override
  State<OrdersFilterBottomSheet> createState() => _OrdersFilterBottomSheetState();
}

class _OrdersFilterBottomSheetState extends State<OrdersFilterBottomSheet> {
  OrderStatus? _status;
  TransactionType? _type;
  String? _giftCard;
  String? _sortBy;

  final List<String> _brands = [
    'All', 'Amazon', 'Apple', 'Steam', 'Netflix', 'Google Play',
    'PlayStation', 'Xbox', 'Razer Gold', 'Binance'
  ];

  final List<String> _sortOptions = ['Newest', 'Oldest', 'Highest Amount', 'Lowest Amount', 'A-Z'];

  @override
  void initState() {
    super.initState();
    _status = widget.initialStatus;
    _type = widget.initialType;
    _giftCard = widget.initialGiftCard;
    _sortBy = widget.initialSort ?? 'Newest';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Orders',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                IconButton(
                  icon: const Icon(Boxicons.bx_x),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 12),

            // Transaction Type
            _buildSectionTitle('Transaction Type'),
            Wrap(
              spacing: 8,
              children: [
                _buildChoiceChip('All', _type == null, () => setState(() => _type = null)),
                _buildChoiceChip('Buy', _type == TransactionType.buy, () => setState(() => _type = TransactionType.buy)),
                _buildChoiceChip('Sell', _type == TransactionType.sell, () => setState(() => _type = TransactionType.sell)),
              ],
            ),
            const SizedBox(height: 16),

            // Status
            _buildSectionTitle('Status'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildChoiceChip('All', _status == null, () => setState(() => _status = null)),
                _buildChoiceChip('Completed', _status == OrderStatus.completed, () => setState(() => _status = OrderStatus.completed)),
                _buildChoiceChip('Pending', _status == OrderStatus.pending, () => setState(() => _status = OrderStatus.pending)),
                _buildChoiceChip('Cancelled', _status == OrderStatus.cancelled, () => setState(() => _status = OrderStatus.cancelled)),
              ],
            ),
            const SizedBox(height: 16),

            // Gift Cards
            _buildSectionTitle('Gift Card Brand'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _brands.map((brand) {
                final isSelected = (_giftCard == null && brand == 'All') || _giftCard == brand;
                return _buildChoiceChip(
                  brand,
                  isSelected,
                  () => setState(() => _giftCard = brand == 'All' ? null : brand),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Sort
            _buildSectionTitle('Sort By'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _sortOptions.map((option) {
                return _buildChoiceChip(
                  option,
                  _sortBy == option,
                  () => setState(() => _sortBy = option),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      widget.onReset();
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
                    ),
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApply(_status, _type, _giftCard, _sortBy);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
                    ),
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.success),
      ),
    );
  }

  Widget _buildChoiceChip(String label, bool isSelected, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.success,
      backgroundColor: isDark ? AppColors.darkCard : Colors.grey.shade100,
      labelStyle: TextStyle(
        fontSize: 12,
        color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}