import '../models/order_model.dart';

class OrderFilterService {
  static List<OrderModel> filterOrders({
    required List<OrderModel> orders,
    String? chipFilter,
    String? searchQuery,
    OrderStatus? status,
    TransactionType? type,
    String? giftCard,
    String? sortBy,
  }) {
    return orders.where((order) {
      // 1. Chip Filter
      if (chipFilter != null && chipFilter != 'All') {
        if (chipFilter == 'Buy' && order.transactionType != TransactionType.buy)
          return false;
        if (chipFilter == 'Sell' &&
            order.transactionType != TransactionType.sell)
          return false;
        if (chipFilter == 'Pending' && order.status != OrderStatus.pending)
          return false;
        if (chipFilter == 'Completed' && order.status != OrderStatus.completed)
          return false;
        if (chipFilter == 'Cancelled' && order.status != OrderStatus.cancelled)
          return false;
      }

      // 2. Search Query
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final query = searchQuery.toLowerCase().trim();
        final matchesName = order.giftCardName.toLowerCase().contains(query);
        final matchesOrderId = order.orderId.toLowerCase().contains(query);
        final matchesRefId = order.referenceId.toLowerCase().contains(query);
        final matchesRegion = order.region.toLowerCase().contains(query);
        if (!matchesName && !matchesOrderId && !matchesRefId && !matchesRegion)
          return false;
      }

      // 3. Status Filter
      if (status != null && order.status != status) return false;

      // 4. Transaction Type Filter
      if (type != null && order.transactionType != type) return false;

      // 5. Gift Card Brand
      if (giftCard != null && giftCard.isNotEmpty && giftCard != 'All') {
        if (!order.giftCardName.toLowerCase().contains(giftCard.toLowerCase()))
          return false;
      }

      return true;
    }).toList()..sort((a, b) {
      if (sortBy == null || sortBy == 'Newest') {
        final leftTime = _timestampForOrder(a);
        final rightTime = _timestampForOrder(b);
        final byTime = rightTime.compareTo(leftTime);
        if (byTime != 0) return byTime;
        return b.orderId.compareTo(a.orderId);
      }
      if (sortBy == 'Oldest') {
        final leftTime = _timestampForOrder(a);
        final rightTime = _timestampForOrder(b);
        final byTime = leftTime.compareTo(rightTime);
        if (byTime != 0) return byTime;
        return a.orderId.compareTo(b.orderId);
      }
      if (sortBy == 'Highest Amount') return b.amount.compareTo(a.amount);
      if (sortBy == 'Lowest Amount') return a.amount.compareTo(b.amount);
      if (sortBy == 'A-Z') return a.giftCardName.compareTo(b.giftCardName);
      return 0; // Default order
    });
  }

  static DateTime _timestampForOrder(OrderModel order) {
    final parsed = order.createdAt ?? DateTime.tryParse(order.date);
    return parsed ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  static int countAll(List<OrderModel> orders) => orders.length;

  static int countPending(List<OrderModel> orders) => orders
      .where(
        (o) =>
            o.status == OrderStatus.pending ||
            o.status == OrderStatus.processing,
      )
      .length;

  static int countCompleted(List<OrderModel> orders) =>
      orders.where((o) => o.status == OrderStatus.completed).length;

  static int countCancelled(List<OrderModel> orders) => orders
      .where(
        (o) =>
            o.status == OrderStatus.cancelled || o.status == OrderStatus.failed,
      )
      .length;
}
