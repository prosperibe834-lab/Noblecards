import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../providers/withdraw_provider.dart';
import '../models/withdraw_method.dart';

class WithdrawMethodSection extends StatelessWidget {
  final WithdrawProvider provider;

  const WithdrawMethodSection({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;

    final availableMethods = provider.allMethods
        .where(
          (m) => provider.selectedCountry.supportedMethodIds.contains(m.id),
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '3. Choose withdrawal method',
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: availableMethods.map((method) {
            final isFirst = availableMethods.first == method;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: isFirst ? AppSpacing.sm : 0,
                  left: !isFirst ? AppSpacing.sm : 0,
                ),
                child: _buildMethodCard(method, context),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMethodCard(WithdrawMethod method, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = provider.selectedMethod?.id == method.id;

    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isSelected
        ? AppColors.primary
        : (isDark ? AppColors.darkBorder : AppColors.lightBorder);

    final iconColor = isSelected
        ? AppColors.primary
        : (isDark ? AppColors.darkSubText : AppColors.lightSubText);

    return GestureDetector(
      onTap: () => provider.selectMethod(method),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: borderColor, width: isSelected ? 1.5 : 1.0),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(method.icon, color: iconColor, size: 28),
                const SizedBox(height: AppSpacing.md),
                Text(
                  method.name,
                  style: TextStyle(
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  method.subtitle,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkSubText
                        : AppColors.lightSubText,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            if (isSelected)
              const Positioned(
                right: 0,
                top: 0,
                child: Icon(
                  Boxicons.bxs_check_circle,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
