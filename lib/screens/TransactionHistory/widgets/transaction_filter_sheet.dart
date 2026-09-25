import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_theme.dart';

class TransactionFilterSheet extends StatefulWidget {
  final String initialType;

  const TransactionFilterSheet({
    Key? key,
    required this.initialType,
  }) : super(key: key);

  static Future<String?> show(
    BuildContext context, {
    String initialType = 'All',
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TransactionFilterSheet(initialType: initialType),
    );
  }

  @override
  State<TransactionFilterSheet> createState() => _TransactionFilterSheetState();
}

class _TransactionFilterSheetState extends State<TransactionFilterSheet> {
  late String _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
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
                _buildFilterSection('Status', ['All', 'Completed', 'Pending', 'Failed'], 'All', isDark),
                const SizedBox(height: AppSpacing.lg),
                _buildFilterSection('Date Range', ['Today', '7 Days', '30 Days', 'Custom'], '30 Days', isDark),
                const SizedBox(height: AppSpacing.lg),
                _buildFilterSection('Sort By', ['Newest', 'Oldest', 'Highest Amount'], 'Newest', isDark),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
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
                  onPressed: () => Navigator.pop(context, _selectedType),
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