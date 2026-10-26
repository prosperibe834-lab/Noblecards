import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'package:shimmer/shimmer.dart';
import 'package:noble_cards/theme/app_colors.dart';
import 'package:noble_cards/theme/app_radius.dart';
import 'package:noble_cards/theme/app_spacing.dart';

class SellSummaryCard extends StatelessWidget {
  final int cardCount;
  final double totalAmount;
  final String cardCurrency;
  final String payoutCurrency;
  final double sellRate;
  final double estimatedPayout;
  final String? sellRateText;
  final String? estimatedPayoutText;

  const SellSummaryCard({
    super.key,
    required this.cardCount,
    required this.totalAmount,
    this.cardCurrency = 'USD',
    this.payoutCurrency = 'NGN',
    this.sellRate = 0,
    this.estimatedPayout = 0,
    this.sellRateText,
    this.estimatedPayoutText,
  });

  bool get _isRateLoading {
    if (sellRateText == null) return sellRate == 0;
    final clean = sellRateText!.trim();
    return clean.isEmpty || clean == 'Loading...' || clean == '0.00%' || clean.startsWith('0.00');
  }

  bool get _isPayoutLoading {
    if (estimatedPayoutText == null) return estimatedPayout == 0;
    final clean = estimatedPayoutText!.trim();
    return clean.isEmpty || clean == 'Loading...' || clean == '0.00' || clean.startsWith('0.00');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkCard : AppColors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final labelColor = isDark ? AppColors.darkSubText : AppColors.lightSubText;
    final valueColor = isDark ? AppColors.darkText : AppColors.lightText;

    final shimmerBase = isDark
        ? AppColors.darkBorder.withValues(alpha: 0.6)
        : const Color(0xFFE2E8F0);
    final shimmerHighlight = isDark
        ? AppColors.darkCard.withValues(alpha: 0.9)
        : const Color(0xFFF8FAFC);

    final cardUnit = cardCount == 1 ? 'card' : 'cards';

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: borderColor, width: 1.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: const Icon(
                        Boxicons.bx_receipt,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Summary',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: valueColor,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'Live Rate',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: borderColor.withValues(alpha: 0.7)),

          // Body Content
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                // Total Cards Row
                _buildRow(
                  'Total Cards',
                  '$cardCount $cardUnit',
                  labelColor: labelColor,
                  valueColor: valueColor,
                  leadingIcon: Boxicons.bx_credit_card,
                ),
                const SizedBox(height: AppSpacing.md),

                // Total Amount Row
                _buildRow(
                  'Total Amount',
                  '$cardCurrency ${totalAmount.toStringAsFixed(2)}',
                  labelColor: labelColor,
                  valueColor: valueColor,
                  isEmphasized: true,
                ),
                const SizedBox(height: AppSpacing.md),

                // Sell Rate Row (With Network Shimmer)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sell Rate',
                      style: TextStyle(
                        color: labelColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (_isRateLoading)
                      Shimmer.fromColors(
                        baseColor: shimmerBase,
                        highlightColor: shimmerHighlight,
                        child: Container(
                          width: 110,
                          height: 18,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      )
                    else
                      Text(
                        sellRateText ?? sellRate.toStringAsFixed(2),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: valueColor,
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),
                Divider(height: 1, color: borderColor.withValues(alpha: 0.5)),
                const SizedBox(height: AppSpacing.md),

                // Highlighted Net Payout Box (Top Fintech Hero Component)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF0F172A).withValues(alpha: 0.6)
                        : const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Estimated You Receive',
                            style: TextStyle(
                              color: isDark ? AppColors.darkSubText : const Color(0xFF065F46),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Instant wallet credit',
                            style: TextStyle(
                              color: isDark ? Colors.white54 : const Color(0xFF047857).withValues(alpha: 0.7),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      if (_isPayoutLoading)
                        Shimmer.fromColors(
                          baseColor: shimmerBase,
                          highlightColor: shimmerHighlight,
                          child: Container(
                            width: 130,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        )
                      else
                        Text(
                          estimatedPayoutText ??
                              '$payoutCurrency ${estimatedPayout.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                            fontSize: 18,
                            letterSpacing: -0.3,
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Footer Metadata: Processing Time & Timestamp
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Boxicons.bx_time_five,
                          size: 14,
                          color: labelColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Processing Time',
                          style: TextStyle(color: labelColor, fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Boxicons.bx_bolt_circle,
                          color: AppColors.primary,
                          size: 14,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '~5 minutes',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: valueColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Last updated a few seconds ago',
                      style: TextStyle(color: labelColor.withValues(alpha: 0.7), fontSize: 11),
                    ),
                    Row(
                      children: [
                        Icon(
                          Boxicons.bx_check_shield,
                          size: 12,
                          color: AppColors.primary.withValues(alpha: 0.8),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          'Verified rate',
                          style: TextStyle(
                            color: AppColors.primary.withValues(alpha: 0.8),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    String label,
    String value, {
    required Color labelColor,
    required Color valueColor,
    IconData? leadingIcon,
    bool isEmphasized = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (leadingIcon != null) ...[
              Icon(leadingIcon, size: 14, color: labelColor),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                color: labelColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isEmphasized ? FontWeight.w800 : FontWeight.w600,
            color: valueColor,
            fontSize: isEmphasized ? 15 : 13,
          ),
        ),
      ],
    );
  }
}

