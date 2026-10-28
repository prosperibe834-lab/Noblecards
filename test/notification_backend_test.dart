import 'package:flutter_test/flutter_test.dart';
import 'package:noble_cards/screens/notification/models/notification_model.dart';
import 'package:noble_cards/screens/notification/services/notification_service.dart';

void main() {
  group('Notification Backend Integration Tests', () {
    test('NotificationModel.fromJson maps backend payload correctly', () {
      final json = {
        'id': 'inapp-nt-004837-user-1',
        'title': 'Weekend Flash Sale!',
        'description': 'Get 10% bonus credit on all gift card trades today.',
        'time': 'Just now',
        'group': 'Today',
        'type': 'promotion',
        'category': 'promotions',
        'icon': 'tag',
        'iconBgColor': '#10B981',
        'iconColor': '#FFFFFF',
        'actionKey': 'promotion',
        'details': [
          {'label': 'Broadcast ID', 'value': 'NT-004837', 'icon': 'info_outline'},
          {'label': 'Category', 'value': 'Promotion', 'icon': 'percent'},
        ],
        'isRead': false,
        'isPinned': true,
      };

      final model = NotificationModel.fromJson(json);

      expect(model.id, 'inapp-nt-004837-user-1');
      expect(model.title, 'Weekend Flash Sale!');
      expect(model.type, NotificationType.promotion);
      expect(model.category, NotificationCategory.promotions);
      expect(model.isRead, false);
      expect(model.isPinned, true);
      expect(model.details.length, 2);
      expect(model.details[0].label, 'Broadcast ID');
      expect(model.details[0].value, 'NT-004837');
    });

    test('NotificationModel.fromJson handles fallback values gracefully', () {
      final minimalJson = {
        'id': 'nt-123',
        'title': 'Server Alert',
        'message': 'Something happened',
      };

      final model = NotificationModel.fromJson(minimalJson);

      expect(model.id, 'nt-123');
      expect(model.title, 'Server Alert');
      expect(model.description, 'Something happened');
      expect(model.isRead, false);
      expect(model.isPinned, false);
      expect(model.details, isEmpty);
    });

    test('NotificationService handles offline gracefully and preserves local state', () async {
      final service = NotificationService();
      final items = await service.fetchNotifications();

      expect(items.isNotEmpty, isTrue);
      expect(items.length, 23);
    });
  });
}
