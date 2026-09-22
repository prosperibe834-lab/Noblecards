// Where to paste:
// lib/screens/notification/models/notification_model.dart

import 'package:flutter/material.dart';

enum NotificationCategory {
  all,
  transactions,
  promotions,
  updates,
  security,
}

enum NotificationType {
  purchase,
  withdrawal,
  orderPending,
  welcomeBonus,
  securityAlert,
  priceUpdate,
  promotion,
  kycVerified,
  adminAnnouncement,
}

class NotificationDetail {
  final String label;
  final String value;
  final IconData icon;

  const NotificationDetail({
    required this.label,
    required this.value,
    required this.icon,
  });
}

class NotificationModel {
  final String id;
  final String title;
  final String description;
  final String time;
  final String group;
  final NotificationType type;
  final NotificationCategory category;

  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;

  /// Used when the notification is opened.
  /// Example:
  /// kyc, purchase, withdrawal, order, price, promotion, security, announcement
  final String? actionKey;

  /// Dynamic information shown on the Notification Details screen.
  final List<NotificationDetail> details;

  bool isRead;
  bool isPinned;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.group,
    required this.type,
    required this.category,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    this.actionKey,
    this.details = const [],
    this.isRead = false,
    this.isPinned = false,
  });
}