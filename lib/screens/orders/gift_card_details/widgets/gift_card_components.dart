import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../../theme/app_colors.dart';
import '../../../../../theme/app_spacing.dart';
import '../../../../../theme/app_radius.dart';
import '../models/gift_card_details_model.dart';

class GiftCardHero extends StatelessWidget {
  final GiftCardDetailsModel data;
  final bool isDark;

  const GiftCardHero({Key? key, required this.data, required this.isDark}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [AppColors.primaryDark.withOpacity(0.4), AppColors.darkCard]
              : [AppColors.successLight.withOpacity(0.25), AppColors.successLight.withOpacity(0.05)],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: const Center(child: Icon(Boxicons.bxl_amazon, color: Colors.white, size: 32)),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.brandName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkText : AppColors.lightText, fontFamily: 'Poppins')),
                Text(data.cardType, style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkSubText : AppColors.lightSubText, fontFamily: 'Inter')),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Icon(Boxicons.bx_globe, size: 14, color: isDark ? AppColors.darkSubText : AppColors.lightSubText),
                    const SizedBox(width: 4),
                    Text(data.country, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkSubText : AppColors.lightSubText)),
                    const SizedBox(width: AppSpacing.md),
                    Icon(Boxicons.bx_purchase_tag, size: 14, color: isDark ? AppColors.darkSubText : AppColors.lightSubText),
                    const SizedBox(width: 4),
                    Text(data.format, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkSubText : AppColors.lightSubText)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text('\$${data.denomination.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'Inter')),
          ),
        ],
      ),
    );
  }
}

class GiftCardSummary extends StatelessWidget {
  final GiftCardDetailsModel data;
  final ThemeData theme;

  const GiftCardSummary({Key? key, required this.data, required this.theme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSummaryItem(Boxicons.bx_purchase_tag, '\$${data.denomination.toStringAsFixed(2)}', 'Denomination', theme),
          _buildDivider(theme),
          _buildSummaryItem(Boxicons.bx_wallet, '\$${data.amountPaid.toStringAsFixed(2)}', 'Amount Paid', theme),
          _buildDivider(theme),
          _buildSummaryItem(Boxicons.bx_dollar_circle, data.currency, 'Currency', theme),
          _buildDivider(theme),
          _buildSummaryItem(Boxicons.bx_check_circle, data.status, 'Status', theme),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(IconData icon, String value, String label, ThemeData theme) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(height: AppSpacing.xs),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: theme.textTheme.bodyLarge?.color, fontFamily: 'Inter')),
        Text(label, style: TextStyle(fontSize: 11, color: theme.textTheme.bodyMedium?.color, fontFamily: 'Inter')),
      ],
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Container(height: 35, width: 1, color: theme.dividerColor);
  }
}

class GiftCardCodeSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final String code;
  final bool isVisible;
  final VoidCallback onToggleVisibility;
  final VoidCallback onCopy;
  final ThemeData theme;
  final bool showReadyBadge;

  const GiftCardCodeSection({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.code,
    required this.isVisible,
    required this.onToggleVisibility,
    required this.onCopy,
    required this.theme,
    required this.showReadyBadge,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final obscuredCode = code.replaceAll(RegExp(r'.'), '•');

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: theme.textTheme.bodyLarge?.color, fontFamily: 'Inter')),
              InkWell(
                onTap: onToggleVisibility,
                borderRadius: BorderRadius.circular(AppRadius.full),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(isVisible ? Boxicons.bx_hide : Boxicons.bx_show, size: 20, color: theme.textTheme.bodyMedium?.color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(subtitle, style: TextStyle(fontSize: 12, color: theme.textTheme.bodyMedium?.color, fontFamily: 'Inter')),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.s),
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark ? AppColors.darkInput : AppColors.lightBackground,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    isVisible ? code : obscuredCode,
                    style: TextStyle(
                      fontSize: 15,
                      letterSpacing: isVisible ? 1.2 : 3.0,
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.bodyLarge?.color,
                      fontFamily: 'Inter'
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                InkWell(
                  onTap: onCopy,
                  child: Icon(Boxicons.bx_copy, size: 20, color: theme.textTheme.bodyMedium?.color),
                )
              ],
            ),
          ),
          if (showReadyBadge) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Boxicons.bx_check_circle, color: AppColors.success, size: 14),
                  SizedBox(width: 4),
                  Text('Code is ready', style: TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }
}

class GiftCardDownloadSection extends StatelessWidget {
  final VoidCallback onDownload;
  final ThemeData theme;

  const GiftCardDownloadSection({Key? key, required this.onDownload, required this.theme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.s),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Boxicons.bx_download, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Download Gift Card', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: theme.textTheme.bodyLarge?.color, fontFamily: 'Inter')),
                Text('Save a copy of your gift card details for future use.', style: TextStyle(fontSize: 11, color: theme.textTheme.bodyMedium?.color, fontFamily: 'Inter')),
              ],
            ),
          ),
          InkWell(
            onTap: onDownload,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: const Row(
                children: [
                  Icon(Boxicons.bx_download, color: AppColors.primary, size: 14),
                  SizedBox(width: 4),
                  Text('Download', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class GiftCardInfoSection extends StatelessWidget {
  final GiftCardDetailsModel data;
  final ThemeData theme;
  final bool isDark;

  const GiftCardInfoSection({Key? key, required this.data, required this.theme, required this.isDark}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryDark.withOpacity(0.15) : AppColors.successLight.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: isDark ? AppColors.primaryDark.withOpacity(0.3) : AppColors.successLight.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Boxicons.bx_info_circle, color: AppColors.primary, size: 18),
              SizedBox(width: AppSpacing.sm),
              Text('Important Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary, fontFamily: 'Inter')),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ...data.importantInformation.map((info) => Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 6.0, right: 8.0, left: 4.0),
                  child: CircleAvatar(radius: 2, backgroundColor: AppColors.primary),
                ),
                Expanded(
                  child: Text(info, style: TextStyle(fontSize: 12, color: theme.textTheme.bodyMedium?.color, height: 1.4, fontFamily: 'Inter')),
                )
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }
}