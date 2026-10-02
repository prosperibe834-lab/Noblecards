import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_theme.dart';

class TransactionHistoryFilter {
  final String type;
  final String status;
  final String dateRange;
  final String sortBy;
  final DateTimeRange? customDateRange;

  const TransactionHistoryFilter({
    this.type = 'All',
    this.status = 'All',
    this.dateRange = '30 Days',
    this.sortBy = 'Newest',
    this.customDateRange,
  });
}

class TransactionFilterSheet extends StatefulWidget {
  final TransactionHistoryFilter initialFilter;

  const TransactionFilterSheet({
    Key? key,
    required this.initialFilter,
  }) : super(key: key);

  static Future<TransactionHistoryFilter?> show(
    BuildContext context, {
    TransactionHistoryFilter initialFilter = const TransactionHistoryFilter(),
  }) {
    return showModalBottomSheet<TransactionHistoryFilter>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TransactionFilterSheet(initialFilter: initialFilter),
    );
  }

  @override
  State<TransactionFilterSheet> createState() => _TransactionFilterSheetState();
}

class _TransactionFilterSheetState extends State<TransactionFilterSheet> {
  late String _selectedType;
  late String _selectedStatus;
  late String _selectedDateRange;
  late String _selectedSortBy;
  DateTimeRange? _customDateRange;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialFilter.type;
    _selectedStatus = widget.initialFilter.status;
    _selectedDateRange = widget.initialFilter.dateRange;
    _selectedSortBy = widget.initialFilter.sortBy;
    _customDateRange = widget.initialFilter.customDateRange;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Filter Transactions', style: AppTextTheme.light.titleLarge?.copyWith(color: textColor)),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: ListView(
              children: [
                _buildFilterSection(
                  'Transaction Type',
                  ['All', 'Deposits', 'Withdrawals'],
                  _selectedType,
                  isDark,
                  onSelected: (value) => setState(() => _selectedType = value),
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildFilterSection(
                  'Status',
                  ['All', 'Completed', 'Pending', 'Failed'],
                  _selectedStatus,
                  isDark,
                  onSelected: (value) => setState(() => _selectedStatus = value),
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildFilterSection(
                  'Date Range',
                  ['Today', '7 Days', '30 Days', 'Custom'],
                  _selectedDateRange,
                  isDark,
                  onSelected: _selectDateRange,
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildFilterSection(
                  'Sort By',
                  ['Newest', 'Oldest', 'Highest Amount'],
                  _selectedSortBy,
                  isDark,
                  onSelected: (value) => setState(() => _selectedSortBy = value),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, const TransactionHistoryFilter()),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                  ),
                  child: Text('Reset', style: TextStyle(color: textColor)),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(
                    context,
                    TransactionHistoryFilter(
                      type: _selectedType,
                      status: _selectedStatus,
                      dateRange: _selectedDateRange,
                      sortBy: _selectedSortBy,
                      customDateRange: _customDateRange,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                  ),
                  child: const Text('Apply Filters', style: TextStyle(color: AppColors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _selectDateRange(String value) async {
    if (value == 'Custom') {
      final now = DateTime.now();
      final range = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: now,
        initialDateRange: _customDateRange,
      );
      if (range == null || !mounted) return;
      setState(() {
        _selectedDateRange = value;
        _customDateRange = range;
      });
      return;
    }
    setState(() => _selectedDateRange = value);
  }

  Widget _buildFilterSection(
    String title,
    List<String> options,
    String selected,
    bool isDark, {
    ValueChanged<String>? onSelected,
  }) {
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final unselectedBg = isDark ? AppColors.darkCard : AppColors.lightCard;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: options.map((opt) {
            final isSelected = opt == selected;
            return GestureDetector(
              onTap: onSelected == null ? null : () => onSelected(opt),
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary.withOpacity(0.1) : unselectedBg,
                  border: Border.all(color: isSelected ? AppColors.primary : Colors.transparent),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  opt,
                  style: TextStyle(
                    color: isSelected ? AppColors.primary : (isDark ? AppColors.darkSubText : AppColors.lightSubText),
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}