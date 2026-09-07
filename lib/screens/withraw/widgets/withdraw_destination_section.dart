import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../providers/withdraw_provider.dart';
import '../models/withdraw_country.dart';

class WithdrawDestinationSection extends StatelessWidget {
  final WithdrawProvider provider;

  const WithdrawDestinationSection({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subTextColor = isDark
        ? AppColors.darkSubText
        : AppColors.lightSubText;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '2. Where are you withdrawing to?',
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        GestureDetector(
          onTap: () => _showCountryPicker(context),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryDark,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    provider.selectedCountry.flagInitials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.selectedCountry.name,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'Receive in ${provider.selectedCountry.currency}',
                        style: TextStyle(color: subTextColor, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Icon(Boxicons.bx_chevron_down, color: subTextColor),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showCountryPicker(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: AppSpacing.md),
              Text(
                'Select Destination',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              ...provider.supportedCountries.map(
                (country) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primaryDark,
                    child: Text(
                      country.flagInitials,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  title: Text(
                    country.name,
                    style: TextStyle(
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  subtitle: Text(
                    'Receive in ${country.currency}',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkSubText
                          : AppColors.lightSubText,
                    ),
                  ),
                  onTap: () {
                    provider.selectCountry(country);
                    Navigator.pop(ctx);
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        );
      },
    );
  }
}
