// Where to paste: lib/screens/notification/services/notification_service.dart

import '../models/notification_model.dart';
import '../data/notification_data.dart';

class NotificationService {
  List<NotificationModel> _list = NotificationData.getInitialNotifications();

  Future<List<NotificationModel>> fetchNotifications() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return List.from(_list);
  }

  List<NotificationModel> filterByCategory(
      List<NotificationModel> items, NotificationCategory category) {
    if (category == NotificationCategory.all) return items;
    return items.where((item) => item.category == category).toList();
  }

  void markAllAsRead(List<NotificationModel> items) {
    for (var item in items) {
      item.isRead = true;
    }
  }

  void toggleReadStatus(NotificationModel item) {
    item.isRead = !item.isRead;
  }

  void togglePin(NotificationModel item) {
    item.isPinned = !item.isPinned;
  }
}