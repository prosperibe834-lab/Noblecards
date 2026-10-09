import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider/provider.dart';
import 'package:noble_cards/screens/cards/buy_receipt_screen.dart';
import 'package:noble_cards/screens/cards/providers/buy_receipt_provider.dart';
import 'package:noble_cards/screens/cards/providers/sell_receipt_provider.dart';
import 'package:noble_cards/screens/cards/sell_receipt_screen.dart';
import 'package:noble_cards/screens/orders/gift_card_details/gift_card_details_screen.dart';
import 'package:noble_cards/screens/orders/models/order_model.dart';
import 'package:noble_cards/screens/orders/services/order_filter_service.dart';
import 'package:noble_cards/screens/orders/services/orders_service.dart';
import 'package:noble_cards/screens/orders/orders_screen.dart';
import 'package:noble_cards/screens/authentication/services/authentication_service.dart';
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
  test('fetches and maps the backend items response', () async {
    String? requestedPath;
    final service = OrdersService(
      authentication: _StubAuthenticationService((path) async {
        requestedPath = path;
        return {
          'items': [
            {
              'id': 'buy-real-id',
              'transactionType': 'buy',
              'status': 'SUCCESSFUL',
              'productName': 'Amazon Gift Card',
              'createdAt': '2026-10-07T09:00:00Z',
            },
            {
              'id': 'sell-real-id',
              'transactionType': 'sell',
              'status': 'UNDER_REVIEW',
              'slug': 'apple',
              'createdAt': '2026-10-07T08:00:00Z',
            },
          ],
          'purchases': [],
          'sales': [],
        };
      }),
    );

    final orders = await service.fetchOrders();

    expect(requestedPath, '/gift-cards/orders');
    expect(orders, hasLength(2));
    expect(orders.first.transactionType, TransactionType.buy);
    expect(orders.last.transactionType, TransactionType.sell);
  });

  test('authenticated Orders request sends the secure access token', () async {
    String? authorization;
    final authentication = AuthenticationService(
      storage: _MemorySecureStorage(),
      httpClient: MockClient((request) async {
        authorization = request.headers['Authorization'];
        expect(request.method, 'GET');
        expect(request.url.path, '/gift-cards/orders');
        return http.Response(
          jsonEncode({
            'items': [
              {
                'id': 'buy-real-id',
                'transactionType': 'buy',
                'status': 'SUCCESSFUL',
                'productName': 'Amazon Gift Card',
                'createdAt': '2026-10-07T09:00:00Z',
              },
            ],
            'purchases': [],
            'sales': [],
          }),
          200,
        );
      }),
    );

    final orders = await OrdersService(
      authentication: authentication,
    ).fetchOrders();

    expect(authorization, 'Bearer test-access-token');
    expect(orders.single.orderId, 'buy-real-id');
  });

  test('returns empty only for a successful empty items response', () async {
    final service = OrdersService(
      authentication: _StubAuthenticationService(
        (_) async => {'items': [], 'purchases': [], 'sales': []},
      ),
    );

    expect(await service.fetchOrders(), isEmpty);
  });

  test('rejects an invalid backend response shape', () async {
    final service = OrdersService(
      authentication: _StubAuthenticationService(
        (_) async => {'purchases': []},
      ),
    );

    expect(service.fetchOrders(), throwsFormatException);
  });

  test(
    'rejects malformed items instead of treating them as no orders',
    () async {
      final service = OrdersService(
        authentication: _StubAuthenticationService(
          (_) async => {
            'items': [null],
          },
        ),
      );

      expect(service.fetchOrders(), throwsFormatException);
    },
  );

  testWidgets('shows the existing empty state after a successful empty fetch', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: OrdersScreen(ordersService: _StubOrdersService(() async => [])),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No Orders Yet'), findsOneWidget);
    expect(find.text('Unable to load orders'), findsNothing);
  });

  testWidgets('shows a retryable error and retries after an HTTP failure', (
    tester,
  ) async {
    var attempts = 0;
    final service = _StubOrdersService(() async {
      attempts += 1;
      if (attempts == 1) throw Exception('401 Unauthorized');
      return [
        _order(
          id: 'buy-real-id',
          type: TransactionType.buy,
          status: OrderStatus.completed,
          name: 'Amazon Gift Card',
        ),
      ];
    });

    await tester.pumpWidget(
      MaterialApp(home: OrdersScreen(ordersService: service)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Unable to load orders'), findsOneWidget);
    expect(find.text('No Orders Yet'), findsNothing);
    expect(find.text('401 Unauthorized'), findsNothing);

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(attempts, 2);
    expect(find.text('Unable to load orders'), findsNothing);
    expect(find.text('Amazon Gift Card'), findsOneWidget);
  });

  testWidgets('403, network, and server failures never show the empty state', (
    tester,
  ) async {
    for (final failure in [
      Exception('403 Forbidden'),
      Exception('Network unavailable'),
      Exception('500 Server error'),
    ]) {
      await tester.pumpWidget(
        MaterialApp(
          home: OrdersScreen(
            ordersService: _StubOrdersService(() async => throw failure),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Unable to load orders'), findsOneWidget);
      expect(find.text('No Orders Yet'), findsNothing);
      expect(find.text(failure.toString()), findsNothing);
    }
  });

  test(
    'sorts mixed Buy and Sell orders newest first by real createdAt timestamp',
    () {
      final orders = OrdersService().parseOrders([
        {
          'id': 'older-buy-id',
          'transactionType': 'buy',
          'status': 'SUCCESSFUL',
          'brandName': 'Amazon',
          'productName': 'Amazon Gift Card',
          'amount': '25',
          'customerPrice': '25',
          'createdAt': '2026-09-30T11:00:00Z',
        },
        {
          'id': 'newer-sell-id',
          'transactionType': 'sell',
          'status': 'SUBMITTED',
          'slug': 'apple',
          'cardAmount': '50',
          'createdAt': '2026-10-02T10:00:00Z',
        },
        {
          'id': 'newer-buy-id',
          'transactionType': 'buy',
          'status': 'SUCCESSFUL',
          'brandName': 'Steam',
          'productName': 'Steam Gift Card',
          'amount': '60',
          'customerPrice': '60',
          'createdAt': '2026-10-03T12:00:00Z',
        },
      ]);

      expect(orders.map((order) => order.orderId).toList(), [
        'newer-buy-id',
        'newer-sell-id',
        'older-buy-id',
      ]);
      expect(
        OrderFilterService.filterOrders(
          orders: orders,
          sortBy: 'Newest',
        ).map((order) => order.orderId).toList(),
        ['newer-buy-id', 'newer-sell-id', 'older-buy-id'],
      );
      expect(
        OrderFilterService.filterOrders(
          orders: orders,
          sortBy: 'Oldest',
        ).map((order) => order.orderId).toList(),
        ['older-buy-id', 'newer-sell-id', 'newer-buy-id'],
      );
      expect(orders.first.transactionType, TransactionType.buy);
      expect(orders.last.transactionType, TransactionType.buy);
    },
  );

  test(
    'maps combined API items into Buy and Sell types using explicit type',
    () {
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
    },
  );

  test('Buy, Sell, status chips, and search filter mapped orders', () {
    final orders = [
      _order(
        id: '1',
        type: TransactionType.buy,
        status: OrderStatus.completed,
        name: 'Amazon',
      ),
      _order(
        id: '2',
        type: TransactionType.sell,
        status: OrderStatus.pending,
        name: 'Apple',
      ),
      _order(
        id: '3',
        type: TransactionType.sell,
        status: OrderStatus.cancelled,
        name: 'Steam',
      ),
    ];

    expect(
      OrderFilterService.filterOrders(orders: orders, chipFilter: 'Buy'),
      hasLength(1),
    );
    expect(
      OrderFilterService.filterOrders(orders: orders, chipFilter: 'Sell'),
      hasLength(2),
    );
    expect(
      OrderFilterService.filterOrders(orders: orders, chipFilter: 'Pending'),
      hasLength(1),
    );
    expect(
      OrderFilterService.filterOrders(orders: orders, chipFilter: 'Completed'),
      hasLength(1),
    );
    expect(
      OrderFilterService.filterOrders(orders: orders, chipFilter: 'Cancelled'),
      hasLength(1),
    );
    expect(
      OrderFilterService.filterOrders(
        orders: orders,
        searchQuery: 'apple',
      ).single.orderId,
      '2',
    );
  });

  testWidgets(
    'tapping a Buy order opens gift-card details with the database ID',
    (tester) async {
      final order = _order(
        id: 'buy-db-id',
        type: TransactionType.buy,
        status: OrderStatus.completed,
        name: 'Amazon',
      );
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => BuyReceiptProvider(),
          child: MaterialApp(
            home: Scaffold(body: OrderCard(order: order)),
          ),
        ),
      );

      await tester.tap(find.byType(OrderCard));
      await tester.pumpAndSettle();

      final details = tester.widget<GiftCardDetailsScreen>(
        find.byType(GiftCardDetailsScreen),
      );
      expect(details.purchaseId, 'buy-db-id');
      expect(find.byType(BuyReceiptScreen), findsNothing);
      expect(find.byType(SellReceiptScreen), findsNothing);
    },
  );

  testWidgets(
    'tapping a Sell order opens its Sell receipt with the database ID',
    (tester) async {
      final order = _order(
        id: 'sell-db-id',
        type: TransactionType.sell,
        status: OrderStatus.pending,
        name: 'Apple',
      );
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => BuyReceiptProvider()),
            ChangeNotifierProvider(create: (_) => SellReceiptProvider()),
          ],
          child: MaterialApp(
            home: Scaffold(body: OrderCard(order: order)),
          ),
        ),
      );

      await tester.tap(find.byType(OrderCard));
      await tester.pumpAndSettle();

      final receipt = tester.widget<SellReceiptScreen>(
        find.byType(SellReceiptScreen),
      );
      expect(receipt.transactionId, 'sell-db-id');
      expect(find.byType(BuyReceiptScreen), findsNothing);
    },
  );
}

class _StubAuthenticationService extends AuthenticationService {
  final Future<Map<String, dynamic>> Function(String path) _get;

  _StubAuthenticationService(this._get) : super();

  @override
  Future<Map<String, dynamic>> authenticatedGet(String path) => _get(path);
}

class _StubOrdersService extends OrdersService {
  final Future<List<OrderModel>> Function() _fetch;

  _StubOrdersService(this._fetch) : super();

  @override
  Future<List<OrderModel>> fetchOrders() => _fetch();
}

class _MemorySecureStorage extends FlutterSecureStorage {
  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => key == 'noble_cards_access_token' ? 'test-access-token' : null;
}
