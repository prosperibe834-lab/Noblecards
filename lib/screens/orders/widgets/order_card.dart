import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../models/order_model.dart';
import '../order_details_router.dart';
import 'order_status_chip.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;

  const OrderCard({super.key, required this.order});

  Widget _buildBrandLogo(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    IconData icon;
    Color iconColor;

    switch (order.brandLogo) {
      case 'amazon':
        icon = Boxicons.bxl_amazon;
        iconColor = Colors.orange;
        break;
      case 'apple':
        icon = Boxicons.bxl_apple;
        iconColor = isDark ? Colors.white : Colors.black;
        break;
      case 'steam':
        icon = Boxicons.bxl_steam;
        iconColor = Colors.blueAccent;
        break;
      case 'netflix':
        icon = Boxicons.bx_tv;
        iconColor = Colors.red;
        break;
      case 'google_play':
        icon = Boxicons.bxl_play_store;
        iconColor = Colors.green;
        break;
      default:
        icon = Boxicons.bx_credit_card;
        iconColor = AppColors.success;
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Center(
        child: Icon(icon, color: iconColor, size: 26),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Hero(
      tag: 'order_${order.referenceId}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => OrderDetailsRouter.navigateToReceipt(context, order),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.black.withOpacity(0.04),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Row(
              children: [
                _buildBrandLogo(context),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          OrderTypeChip(type: order.transactionType),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              order.giftCardName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Order ID: ${order.orderId}',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        order.date,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${order.currency}${order.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Boxicons.bx_chevron_right,
                          size: 18,
                          color: isDark ? Colors.white38 : Colors.black38,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    OrderStatusBadge(status: order.status),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}