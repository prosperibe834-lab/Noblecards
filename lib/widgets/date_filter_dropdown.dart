import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class DateFilterDropdown extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String?> onChanged;

  const DateFilterDropdown({
    Key? key,
    required this.selectedFilter,
    required this.onChanged,
  }) : super(key: key);

  static const List<String> dateOptions = [
    'All Time',
    'Today',
    'Yesterday',
    'Last 7 Days',
    'Last 30 Days',
    'Last 3 Months',
    'Last 6 Months',
    'This Month',
    'Last Month',
    'This Year',
    'Last Year',
    'Custom Date'
  ];

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
        child: DropdownButton<String>(
          value: selectedFilter,
          isExpanded: true,
          icon: const Icon(Boxicons.bx_chevron_down, size: 20),
          items: dateOptions.map((opt) {
            return DropdownMenuItem<String>(
              value: opt,
              child: Row(
                children: [
                  const Icon(Boxicons.bx_calendar, size: 16),
                  const SizedBox(width: 8),
                  Text(opt, style: const TextStyle(fontSize: 13)),
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