// Where to paste: lib/screens/notification/models/notification_model.dart

import 'package:flutter/material.dart';

enum NotificationCategory { all, transactions, promotions, updates, security }

enum NotificationType {
  purchase,
  withdrawal,
  orderPending,
  welcomeBonus,
  securityAlert,
  priceUpdate,
  deposit,
  promotion,
  kycVerified,
}

class NotificationModel {
  final String id;
  final String title;
  final String description;
  final String time;
  final String group; // "Today", "Yesterday", "This Week"
  final NotificationType type;
  final NotificationCategory category;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
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
    this.isRead = false,
    this.isPinned = false,
  });
}