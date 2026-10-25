import 'package:flutter/material.dart';
import '../../../../localization/app_localizations.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../models/order_model.dart';

class OrderTypeChip extends StatelessWidget {
  final TransactionType type;

  const OrderTypeChip({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final isBuy = type == TransactionType.buy;
    final color = isBuy ? AppColors.success : Colors.redAccent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        isBuy ? context.tr('buy') : context.tr('sell'),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case OrderStatus.completed:
        bg = AppColors.success.withOpacity(0.12);
        fg = AppColors.success;
        label = context.tr('completed');
        break;
      case OrderStatus.pending:
        bg = Colors.orange.withOpacity(0.12);
        fg = Colors.orange;
        label = context.tr('pending');
        break;
      case OrderStatus.processing:
        bg = Colors.blue.withOpacity(0.12);
        fg = Colors.blue;
        label = context.tr('processing');
        break;
      case OrderStatus.cancelled:
        bg = isDark(context) ? Colors.white10 : Colors.black12;
        fg = isDark(context) ? Colors.white60 : Colors.black54;
        label = context.tr('cancelled');
        break;
      case OrderStatus.failed:
        bg = Colors.redAccent.withOpacity(0.12);
        fg = Colors.redAccent;
        label = context.tr('failed');
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }

  bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;
}
