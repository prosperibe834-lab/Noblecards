import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';
import '../models/order_model.dart';
import '../services/order_filter_service.dart';
import 'animated_counter_card.dart';
import '../../../../localization/app_localizations.dart';

class OrderSummaryCard extends StatelessWidget {
  final List<OrderModel> orders;

  const OrderSummaryCard({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AnimatedCounterCard(
          label: context.tr('all_orders', fallback: 'All Orders'),
          targetCount: OrderFilterService.countAll(orders),
          icon: Boxicons.bx_shopping_bag,
          iconColor: AppColors.success,
          iconBgColor: AppColors.success.withOpacity(0.12),
        ),
        const SizedBox(width: 6),
        AnimatedCounterCard(
          label: context.tr('pending', fallback: 'Pending'),
          targetCount: OrderFilterService.countPending(orders),
          icon: Boxicons.bx_time_five,
          iconColor: Colors.orange,
          iconBgColor: Colors.orange.withOpacity(0.12),
        ),
        const SizedBox(width: 6),
        AnimatedCounterCard(
          label: context.tr('completed', fallback: 'Completed'),
          targetCount: OrderFilterService.countCompleted(orders),
          icon: Boxicons.bx_check_circle,
          iconColor: AppColors.success,
          iconBgColor: AppColors.success.withOpacity(0.12),
        ),
        const SizedBox(width: 6),
        AnimatedCounterCard(
          label: context.tr('cancelled', fallback: 'Cancelled'),
          targetCount: OrderFilterService.countCancelled(orders),
          icon: Boxicons.bx_x_circle,
          iconColor: Colors.redAccent,
          iconBgColor: Colors.redAccent.withOpacity(0.12),
        ),
      ],
    );
  }
}
