import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../models/withdraw_bank_models.dart';

class WithdrawBankSelectorSheet extends StatefulWidget {
  final List<WithdrawalBank> banks;
  final WithdrawalBank? selectedBank;
  final ValueChanged<WithdrawalBank> onBankSelected;

  const WithdrawBankSelectorSheet({
    super.key,
    required this.banks,
    this.selectedBank,
    required this.onBankSelected,
  });

  @override
  State<WithdrawBankSelectorSheet> createState() => _WithdrawBankSelectorSheetState();
}

class _WithdrawBankSelectorSheetState extends State<WithdrawBankSelectorSheet> {
  String searchQuery = '';
  late List<WithdrawalBank> filteredBanks;

  @override
  void initState() {
    super.initState();
    filteredBanks = widget.banks;
  }

  void _filterBanks(String query) {
    setState(() {
      searchQuery = query;
      filteredBanks = widget.banks
          .where((b) => b.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subTextColor = isDark ? AppColors.darkSubText : AppColors.lightSubText;
    final inputColor = isDark ? AppColors.darkInput : AppColors.lightBackground;

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            "Select Bank",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontFamily: "Poppins",
              color: textColor,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: TextField(
              onChanged: _filterBanks,
              style: TextStyle(color: textColor, fontFamily: "Inter"),
              decoration: InputDecoration(
                hintText: "Search for your bank",
                hintStyle: TextStyle(color: subTextColor),
                prefixIcon: Icon(Boxicons.bx_search, color: subTextColor),
                filled: true,
                fillColor: inputColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: filteredBanks.isEmpty
                ? Center(
                    child: Text(
                      "No banks found",
                      style: TextStyle(color: subTextColor, fontFamily: "Inter"),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredBanks.length,
                    itemBuilder: (context, index) {
                      final bank = filteredBanks[index];
                      final isSelected = widget.selectedBank?.id == bank.id;

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          child: Text(
                            bank.name[0],
                            style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          bank.name,
                          style: TextStyle(
                            color: textColor,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          "Bank Transfer",
                          style: TextStyle(
                            color: subTextColor,
                            fontFamily: "Inter",
                            fontSize: 12,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Boxicons.bx_check_circle, color: AppColors.success)
                            : Icon(Boxicons.bx_circle, color: subTextColor.withOpacity(0.3)),
                        onTap: () {
                          widget.onBankSelected(bank);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}