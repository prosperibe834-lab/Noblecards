// Where to paste: lib/screens/notification/services/notification_service.dart

import '../models/notification_model.dart';
import '../data/notification_data.dart';
import '../../authentication/services/authentication_service.dart';

class NotificationService {
  final AuthenticationService _authService;
  final List<NotificationModel> _list;

  NotificationService({
    AuthenticationService? authService,
    List<NotificationModel>? initialList,
  })  : _authService = authService ?? AuthenticationService(),
        _list = initialList ?? NotificationData.getInitialNotifications();

  Future<List<NotificationModel>> fetchNotifications({
    NotificationCategory category = NotificationCategory.all,
  }) async {
    try {
      final categoryParam = category == NotificationCategory.all
          ? ''
          : '?category=${category.name}';
      final response = await _authService.authenticatedGet('/notifications$categoryParam');
      final rawList = response['notifications'];
      if (rawList is List) {
        final fetched = rawList
            .map((item) => NotificationModel.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ))
            .toList();
        _list
          ..clear()
          ..addAll(fetched);
        return List.from(_list);
      }
    } catch (_) {
      // Graceful offline fallback to rich local state
    }

    return List.from(_list);
  }

  List<NotificationModel> filterByCategory(
    List<NotificationModel> items,
    NotificationCategory category,
  ) {
    if (category == NotificationCategory.all) return items;
    return items.where((item) => item.category == category).toList();
  }

  void markAllAsRead(List<NotificationModel> items) {
    for (var item in items) {
      item.isRead = true;
    }
    // Sync with backend asynchronously
    try {
      _authService.authenticatedPost('/notifications/read-all');
    } catch (_) {}
  }

  void toggleReadStatus(NotificationModel item) {
    item.isRead = !item.isRead;
    // Sync with backend asynchronously
    try {
      _authService.authenticatedPatch(
        '/notifications/${item.id}/read',
        body: {'isRead': item.isRead},
      );
    } catch (_) {}
  }

  void markAsRead(NotificationModel item) {
    if (!item.isRead) {
      item.isRead = true;
      try {
        _authService.authenticatedPatch(
          '/notifications/${item.id}/read',
          body: {'isRead': true},
        );
      } catch (_) {}
    }
  }

  void togglePin(NotificationModel item) {
    item.isPinned = !item.isPinned;
    // Sync with backend asynchronously
    try {
      _authService.authenticatedPatch('/notifications/${item.id}/pin');
    } catch (_) {}
  }

  void addNotification(NotificationModel item) {
    _list.insert(0, item);
  }

  int countByCategory(List<NotificationModel> items, NotificationCategory category) {
    if (category == NotificationCategory.all) return items.length;
    return items.where((item) => item.category == category).length;
  }
}
