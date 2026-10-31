import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';

class GiftCardFilterOptions {
  final String sortBy;
  final String category;
  final String country;

  const GiftCardFilterOptions({
    this.sortBy = 'Popular',
    this.category = 'All',
    this.country = 'All',
  });

  GiftCardFilterOptions copyWith({
    String? sortBy,
    String? category,
    String? country,
  }) {
    return GiftCardFilterOptions(
      sortBy: sortBy ?? this.sortBy,
      category: category ?? this.category,
      country: country ?? this.country,
    );
  }
}

class GiftCardFilterBottomSheet extends StatefulWidget {
  final GiftCardFilterOptions currentFilters;
  final Function(GiftCardFilterOptions) onApply;

  const GiftCardFilterBottomSheet({
    super.key,
    required this.currentFilters,
    required this.onApply,
  });

  static Future<void> show(
    BuildContext context, {
    required GiftCardFilterOptions currentFilters,
    required Function(GiftCardFilterOptions) onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => GiftCardFilterBottomSheet(
        currentFilters: currentFilters,
        onApply: onApply,
      ),
    );
  }

  @override
  State<GiftCardFilterBottomSheet> createState() =>
      _GiftCardFilterBottomSheetState();
}

class _GiftCardFilterBottomSheetState extends State<GiftCardFilterBottomSheet> {
  late String _sortBy;
  late String _category;
  late String _country;

  final List<String> _sortOptions = [
    'Popular',
    'Lowest Rate',
    'Highest Rate',
    'Name (A - Z)',
  ];

  final List<String> _categories = [
    'All',
    'Gaming',
    'Shopping',
    'Entertainment',
    'Dining',
  ];

  final List<Map<String, String>> _countries = [
    {'code': 'All', 'name': 'All Countries', 'flag': '🌐'},
    {'code': 'US', 'name': 'United States', 'flag': '🇺🇸'},
    {'code': 'GB', 'name': 'United Kingdom', 'flag': '🇬🇧'},
    {'code': 'CA', 'name': 'Canada', 'flag': '🇨🇦'},
    {'code': 'FR', 'name': 'France', 'flag': '🇫🇷'},
    {'code': 'DE', 'name': 'Germany', 'flag': '🇩🇪'},
    {'code': 'JP', 'name': 'Japan', 'flag': '🇯🇵'},
    {'code': 'NG', 'name': 'Nigeria', 'flag': '🇳🇬'},
  ];

  @override
  void initState() {
    super.initState();
    _sortBy = widget.currentFilters.sortBy;
    _category = widget.currentFilters.category;
    _country = widget.currentFilters.country;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subTextColor =
        isDark ? AppColors.darkSubText : AppColors.lightSubText;
    final borderColor =
        isDark ? Colors.white10 : Colors.black.withOpacity(0.06);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Boxicons.bx_slider_alt,
                    color: AppColors.success,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Filter & Sort Cards',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _sortBy = 'Popular';
                    _category = 'All';
                    _country = 'All';
                  });
                },
                child: const Text(
                  'Reset',
                  style: TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Section 1: Sort By
          Text(
            'Sort By',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: subTextColor,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _sortOptions.map((opt) {
              final isSel = _sortBy == opt;
              return ChoiceChip(
                label: Text(opt),
                selected: isSel,
                onSelected: (_) => setState(() => _sortBy = opt),
                selectedColor: AppColors.success,
                backgroundColor: isDark
                    ? AppColors.darkInput
                    : const Color(0xFFF1F5F9),
                labelStyle: TextStyle(
                  color: isSel ? Colors.white : textColor,
                  fontSize: 12,
                  fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  side: BorderSide(
                    color: isSel ? AppColors.success : borderColor,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Section 2: Category
          Text(
            'Category',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: subTextColor,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _categories.map((cat) {
              final isSel = _category == cat;
              return ChoiceChip(
                label: Text(cat),
                selected: isSel,
                onSelected: (_) => setState(() => _category = cat),
                selectedColor: AppColors.success,
                backgroundColor: isDark
                    ? AppColors.darkInput
                    : const Color(0xFFF1F5F9),
                labelStyle: TextStyle(
                  color: isSel ? Colors.white : textColor,
                  fontSize: 12,
                  fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  side: BorderSide(
                    color: isSel ? AppColors.success : borderColor,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Section 3: Country
          Text(
            'Country / Region',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: subTextColor,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _countries.map((c) {
              final isSel = _country == c['code'];
              return ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(c['flag'] ?? '', style: const TextStyle(fontSize: 13)),
                    const SizedBox(width: 4),
                    Text(c['name'] ?? ''),
                  ],
                ),
                selected: isSel,
                onSelected: (_) => setState(() => _country = c['code']!),
                selectedColor: AppColors.success,
                backgroundColor: isDark
                    ? AppColors.darkInput
                    : const Color(0xFFF1F5F9),
                labelStyle: TextStyle(
                  color: isSel ? Colors.white : textColor,
                  fontSize: 12,
                  fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  side: BorderSide(
                    color: isSel ? AppColors.success : borderColor,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),

          // Action: Apply Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onApply(
                  GiftCardFilterOptions(
                    sortBy: _sortBy,
                    category: _category,
                    country: _country,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Apply Filters',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
