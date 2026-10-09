import 'package:intl/intl.dart';

import '../../authentication/services/authentication_service.dart';
import '../models/order_model.dart';

class OrdersService {
  final AuthenticationService _authentication;

  OrdersService({AuthenticationService? authentication})
    : _authentication = authentication ?? AuthenticationService();

  Future<List<OrderModel>> fetchOrders() async {
    final response = await _authentication.authenticatedGet(
      '/gift-cards/orders',
    );
    final items = response['items'];
    if (items is! List) {
      throw const FormatException('Invalid orders response.');
    }
    if (items.any((item) => item is! Map)) {
      throw const FormatException('Invalid orders response.');
    }
    return parseOrders(items);
  }

  List<OrderModel> parseOrders(dynamic raw) {
    if (raw is! List) return const [];

    final entries = raw.whereType<Map>().toList();
    entries.sort((left, right) {
      final leftTime = _timestampFromEntry(left);
      final rightTime = _timestampFromEntry(right);
      final byTime = rightTime.compareTo(leftTime);
      if (byTime != 0) return byTime;

      final leftId = (left['id'] ?? left['reference'] ?? '').toString();
      final rightId = (right['id'] ?? right['reference'] ?? '').toString();
      return rightId.compareTo(leftId);
    });

    return entries.map(_mapOrder).toList();
  }

  DateTime _timestampFromEntry(Map item) {
    final value =
        item['createdAt'] ??
        item['updatedAt'] ??
        item['date'] ??
        DateTime.now().toIso8601String();
    final parsed = DateTime.tryParse(value.toString());
    return parsed ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  OrderModel _mapOrder(Map entry) {
    final type = _transactionType(entry);
    final status = _status(entry);
    final productName =
        entry['productName']?.toString() ??
        entry['brandName']?.toString() ??
        entry['slug']?.toString() ??
        entry['name']?.toString() ??
        'Gift Card';
    final amount = _amount(entry);
    final currency =
        entry['currencyCode']?.toString() ??
        entry['payoutCurrency']?.toString() ??
        entry['currency']?.toString() ??
        'USD';
    final region =
        entry['countryCode']?.toString() ??
        entry['cardCountry']?.toString() ??
        entry['country']?.toString() ??
        'US';
    final provider = entry['provider']?.toString() ?? 'Wallet';
    final id =
        entry['id']?.toString() ??
        entry['reference']?.toString() ??
        'NC-${DateTime.now().millisecondsSinceEpoch}';

    return OrderModel(
      referenceId: entry['reference']?.toString() ?? id,
      orderId: id,
      transactionType: type,
      status: status,
      giftCardName: productName,
      brandLogo: productName,
      amount: amount,
      currency: currency,
      region: '$region ${_flag(region)}',
      date: _formatDate(
        entry['createdAt'] ??
            entry['updatedAt'] ??
            DateTime.now().toIso8601String(),
      ),
      createdAt: _timestampFromEntry(entry),
      quantity: int.tryParse(entry['quantity']?.toString() ?? '1') ?? 1,
      paymentMethod: provider,
    );
  }

  TransactionType _transactionType(Map item) {
    final explicit = (item['transactionType'] ?? item['type'] ?? '')
        .toString()
        .toLowerCase();
    if (explicit == 'sell' || explicit == 'sale') return TransactionType.sell;
    if (item['brandName'] != null &&
        item['cardCountry'] != null &&
        item['payoutCurrency'] != null) {
      return TransactionType.sell;
    }
    return TransactionType.buy;
  }

  OrderStatus _status(Map item) {
    final raw = (item['status'] ?? item['state'] ?? '')
        .toString()
        .toUpperCase();
    switch (raw) {
      case 'SUCCESSFUL':
      case 'APPROVED':
      case 'PAID':
        return OrderStatus.completed;
      case 'PROCESSING':
      case 'UNDER_REVIEW':
      case 'SUBMITTED':
        return OrderStatus.pending;
      case 'FAILED':
      case 'REJECTED':
        return OrderStatus.failed;
      case 'CANCELLED':
      case 'CANCELED':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }

  double _amount(Map item) {
    final value =
        item['customerPrice'] ??
        item['finalPayoutAmount'] ??
        item['amount'] ??
        item['quotedPayoutAmount'] ??
        item['cardAmount'] ??
        '0';
    return double.tryParse(value.toString()) ?? 0;
  }

  String _formatDate(String rawDate) {
    final parsed = DateTime.tryParse(rawDate);
    if (parsed == null) return rawDate;
    return DateFormat('dd MMM yyyy, hh:mm a').format(parsed);
  }

  String _flag(String countryCode) {
    final code = countryCode.toUpperCase();
    const flags = {
      'US': '🇺🇸',
      'GB': '🇬🇧',
      'CA': '🇨🇦',
      'NG': '🇳🇬',
      'GH': '🇬🇭',
      'AU': '🇦🇺',
      'DE': '🇩🇪',
      'FR': '🇫🇷',
      'ZA': '🇿🇦',
      'KE': '🇰🇪',
      'IN': '🇮🇳',
      'AE': '🇦🇪',
      'SA': '🇸🇦',
      'SG': '🇸🇬',
      'JP': '🇯🇵',
      'KR': '🇰🇷',
    };
    return flags[code] ?? '🌍';
  }
}
