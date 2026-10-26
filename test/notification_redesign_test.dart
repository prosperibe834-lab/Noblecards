import 'package:flutter_test/flutter_test.dart';
import 'package:noble_cards/screens/notification/data/notification_data.dart';
import 'package:noble_cards/screens/notification/models/notification_model.dart';
import 'package:noble_cards/screens/notification/services/notification_service.dart';

void main() {
  group('Notification Redesign Tests', () {
    late NotificationService service;

    setUp(() {
      service = NotificationService();
    });

    test('Initial notifications count exactly 23 items matching mockup design', () {
      final initial = NotificationData.getInitialNotifications();
      expect(initial.length, 23);
      expect(service.countByCategory(initial, NotificationCategory.all), 23);
      expect(service.countByCategory(initial, NotificationCategory.transactions), 8);
      expect(service.countByCategory(initial, NotificationCategory.updates), 5);
      expect(service.countByCategory(initial, NotificationCategory.promotions), 4);
      expect(service.countByCategory(initial, NotificationCategory.security), 2);
      expect(service.countByCategory(initial, NotificationCategory.marketing), 2);
      expect(service.countByCategory(initial, NotificationCategory.system), 1);
      expect(service.countByCategory(initial, NotificationCategory.maintenance), 1);
    });

    test('Filter by category returns exact subset of notifications', () {
      final initial = NotificationData.getInitialNotifications();

      final txList = service.filterByCategory(initial, NotificationCategory.transactions);
      expect(txList.length, 8);
      expect(txList.every((n) => n.category == NotificationCategory.transactions), isTrue);

      final promoList = service.filterByCategory(initial, NotificationCategory.promotions);
      expect(promoList.length, 4);
      expect(promoList.every((n) => n.category == NotificationCategory.promotions), isTrue);

      final allList = service.filterByCategory(initial, NotificationCategory.all);
      expect(allList.length, 23);
    });

    test('Mark all as read updates all items', () {
      final initial = NotificationData.getInitialNotifications();
      expect(initial.any((n) => !n.isRead), isTrue);

      service.markAllAsRead(initial);
      expect(initial.every((n) => n.isRead), isTrue);
    });

    test('Toggle read status inverts read state', () {
      final initial = NotificationData.getInitialNotifications();
      final item = initial.first;
      final originalState = item.isRead;

      service.toggleReadStatus(item);
      expect(item.isRead, !originalState);

      service.toggleReadStatus(item);
      expect(item.isRead, originalState);
    });

    test('Toggle pin inverts pinned state', () {
      final initial = NotificationData.getInitialNotifications();
      final item = initial.first;
      final originalState = item.isPinned;

      service.togglePin(item);
      expect(item.isPinned, !originalState);

      service.togglePin(item);
      expect(item.isPinned, originalState);
    });
  });
}
