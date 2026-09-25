import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';

class AnalyticsFilterSheet extends StatefulWidget {
  final Function(DateTimeRange) onApplyRange;

  const AnalyticsFilterSheet({Key? key, required this.onApplyRange}) : super(key: key);

  static void show(BuildContext context, Function(DateTimeRange) onApplyRange) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AnalyticsFilterSheet(onApplyRange: onApplyRange),
    );
  }

  @override
  State<AnalyticsFilterSheet> createState() => _AnalyticsFilterSheetState();
}

class _AnalyticsFilterSheetState extends State<AnalyticsFilterSheet> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime _endDate = DateTime.now();
  String _selectedQuick = 'Last 7 Days';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          Text('Select Date Range', style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              'Today',
              'Last 7 Days',
              'Last 30 Days',
              'This Month',
              'Last Month',
            ].map((opt) {
              final isSel = _selectedQuick == opt;
              return ChoiceChip(
                label: Text(opt, style: TextStyle(color: isSel ? Colors.white : textColor, fontSize: 12)),
                selected: isSel,
                selectedColor: AppColors.primary,
                backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
                onSelected: (val) {
                  setState(() {
                    _selectedQuick = opt;
                    final now = DateTime.now();
                    if (opt == 'Today') {
                      _startDate = now;
                      _endDate = now;
                    } else if (opt == 'Last 7 Days') {
                      _startDate = now.subtract(const Duration(days: 7));
                      _endDate = now;
                    } else if (opt == 'Last 30 Days') {
                      _startDate = now.subtract(const Duration(days: 30));
                      _endDate = now;
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                  ),
                  onPressed: () {
                    widget.onApplyRange(DateTimeRange(start: _startDate, end: _endDate));
                    Navigator.pop(context);
                  },
                  child: const Text('Apply Range', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}