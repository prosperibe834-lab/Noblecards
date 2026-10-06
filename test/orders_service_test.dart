import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:noble_cards/screens/cards/buy_receipt_screen.dart';
import 'package:noble_cards/screens/cards/providers/buy_receipt_provider.dart';
import 'package:noble_cards/screens/cards/providers/sell_receipt_provider.dart';
import 'package:noble_cards/screens/cards/sell_receipt_screen.dart';
import 'package:noble_cards/screens/orders/gift_card_details/gift_card_details_screen.dart';
import 'package:noble_cards/screens/orders/models/order_model.dart';
import 'package:noble_cards/screens/orders/services/order_filter_service.dart';
import 'package:noble_cards/screens/orders/services/orders_service.dart';
import 'package:noble_cards/screens/orders/widgets/order_card.dart';

OrderModel _order({
  required String id,
  required TransactionType type,
  required OrderStatus status,
  required String name,
}) => OrderModel(
  referenceId: 'external-$id',
  orderId: id,
  transactionType: type,
  status: status,
  giftCardName: name,
  brandLogo: name.toLowerCase(),
  amount: 25,
  region: 'US',
  date: '15 Sep 2026, 12:00 PM',
  paymentMethod: 'Wallet',
);

void main() {
  test('maps combined API items into Buy and Sell types using explicit type', () {
    final orders = OrdersService().parseOrders([
      {
        'id': 'buy-db-id',
        'reference': 'buy-provider-reference',
        'transactionType': 'buy',
        'status': 'SUCCESSFUL',
        'brandName': 'Amazon',
        'productName': 'Amazon Gift Card',
        'amount': '25',
        'customerPrice': '23',
        'createdAt': '2026-09-15T12:00:00Z',
      },
      {
        'id': 'sell-db-id',
        'transactionType': 'sell',
        'status': 'SUBMITTED',
        'slug': 'apple',
        'cardAmount': '50',
        'createdAt': '2026-09-15T11:00:00Z',
      },
    ]);

    expect(orders, hasLength(2));
    expect(orders.first.transactionType, TransactionType.buy);
    expect(orders.first.orderId, 'buy-db-id');
    expect(orders.first.referenceId, 'buy-provider-reference');
    expect(orders.last.transactionType, TransactionType.sell);
    expect(orders.last.orderId, 'sell-db-id');
  });

  test('Buy, Sell, status chips, and search filter mapped orders', () {
    final orders = [
      _order(id: '1', type: TransactionType.buy, status: OrderStatus.completed, name: 'Amazon'),
      _order(id: '2', type: TransactionType.sell, status: OrderStatus.pending, name: 'Apple'),
      _order(id: '3', type: TransactionType.sell, status: OrderStatus.cancelled, name: 'Steam'),
    ];

    expect(OrderFilterService.filterOrders(orders: orders, chipFilter: 'Buy'), hasLength(1));
    expect(OrderFilterService.filterOrders(orders: orders, chipFilter: 'Sell'), hasLength(2));
    expect(OrderFilterService.filterOrders(orders: orders, chipFilter: 'Pending'), hasLength(1));
    expect(OrderFilterService.filterOrders(orders: orders, chipFilter: 'Completed'), hasLength(1));
    expect(OrderFilterService.filterOrders(orders: orders, chipFilter: 'Cancelled'), hasLength(1));
    expect(OrderFilterService.filterOrders(orders: orders, searchQuery: 'apple').single.orderId, '2');
  });

  testWidgets('tapping a Buy order opens gift-card details with the database ID', (tester) async {
    final order = _order(id: 'buy-db-id', type: TransactionType.buy, status: OrderStatus.completed, name: 'Amazon');
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: OrderCard(order: order))),
    );

    await tester.tap(find.byType(OrderCard));
    await tester.pumpAndSettle();

    final details = tester.widget<GiftCardDetailsScreen>(find.byType(GiftCardDetailsScreen));
    expect(details.purchaseId, 'buy-db-id');
    expect(find.byType(BuyReceiptScreen), findsNothing);
    expect(find.byType(SellReceiptScreen), findsNothing);
  });

  testWidgets('tapping a Sell order opens its Sell receipt with the database ID', (tester) async {
    final order = _order(id: 'sell-db-id', type: TransactionType.sell, status: OrderStatus.pending, name: 'Apple');
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => BuyReceiptProvider()),
          ChangeNotifierProvider(create: (_) => SellReceiptProvider()),
        ],
        child: MaterialApp(home: Scaffold(body: OrderCard(order: order))),
      ),
    );

    await tester.tap(find.byType(OrderCard));
    await tester.pumpAndSettle();

    final receipt = tester.widget<SellReceiptScreen>(find.byType(SellReceiptScreen));
    expect(receipt.transactionId, 'sell-db-id');
    expect(find.byType(BuyReceiptScreen), findsNothing);
  });
}