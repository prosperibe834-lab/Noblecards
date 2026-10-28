// Where to paste:
// lib/screens/notification/models/notification_model.dart

import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

enum NotificationCategory {
  all,
  transactions,
  updates,
  promotions,
  security,
  marketing,
  system,
  maintenance,
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
  transaction,
  update,
  marketing,
  maintenance,
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

  factory NotificationDetail.fromJson(Map<String, dynamic> json) {
    return NotificationDetail(
      label: json['label']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
      icon: _parseDetailIcon(json['icon']?.toString()),
    );
  }

  static IconData _parseDetailIcon(String? name) {
    switch (name) {
      case 'attach_money':
        return Icons.attach_money;
      case 'person_outline':
        return Icons.person_outline;
      case 'check_circle_outline':
        return Icons.check_circle_outline;
      case 'info_outline':
        return Icons.info_outline;
      case 'storage_outlined':
        return Icons.storage_outlined;
      case 'percent':
        return Icons.percent;
      case 'calendar_today_outlined':
        return Icons.calendar_today_outlined;
      case 'flight_takeoff':
        return Icons.flight_takeoff;
      case 'star_border':
        return Icons.star_border;
      case 'lock_outline':
        return Icons.lock_outline;
      case 'card_giftcard':
        return Icons.card_giftcard;
      case 'verified':
        return Icons.verified;
      case 'shield':
        return Icons.shield;
      default:
        return Icons.info_outline;
    }
  }
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

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final parsedType = _parseType(json['type']?.toString());
    final parsedCategory = _parseCategory(json['category']?.toString());
    final parsedIcon = _parseIcon(json['icon']?.toString(), parsedType);
    final parsedIconBgColor = _parseColor(
      json['iconBgColor'],
      const Color(0xFF10B981),
    );
    final parsedIconColor = _parseColor(
      json['iconColor'],
      Colors.white,
    );

    final detailsList = <NotificationDetail>[];
    if (json['details'] is List) {
      for (final d in (json['details'] as List)) {
        if (d is Map<String, dynamic>) {
          detailsList.add(NotificationDetail.fromJson(d));
        } else if (d is Map) {
          detailsList.add(
            NotificationDetail.fromJson(Map<String, dynamic>.from(d)),
          );
        }
      }
    }

    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ??
          json['message']?.toString() ??
          '',
      time: json['time']?.toString() ?? 'Just now',
      group: json['group']?.toString() ?? 'Today',
      type: parsedType,
      category: parsedCategory,
      icon: parsedIcon,
      iconBgColor: parsedIconBgColor,
      iconColor: parsedIconColor,
      actionKey: json['actionKey']?.toString(),
      details: detailsList,
      isRead: json['isRead'] == true,
      isPinned: json['isPinned'] == true,
    );
  }

  static NotificationType _parseType(String? t) {
    switch (t?.toLowerCase()) {
      case 'transaction':
        return NotificationType.transaction;
      case 'purchase':
        return NotificationType.purchase;
      case 'withdrawal':
        return NotificationType.withdrawal;
      case 'orderpending':
      case 'order_pending':
        return NotificationType.orderPending;
      case 'welcomebonus':
      case 'welcome_bonus':
        return NotificationType.welcomeBonus;
      case 'securityalert':
      case 'security_alert':
      case 'security':
        return NotificationType.securityAlert;
      case 'priceupdate':
      case 'price_update':
        return NotificationType.priceUpdate;
      case 'promotion':
        return NotificationType.promotion;
      case 'kycverified':
      case 'kyc_verified':
      case 'kyc':
        return NotificationType.kycVerified;
      case 'adminannouncement':
      case 'announcement':
        return NotificationType.adminAnnouncement;
      case 'update':
      case 'system':
        return NotificationType.update;
      case 'marketing':
        return NotificationType.marketing;
      case 'maintenance':
        return NotificationType.maintenance;
      default:
        return NotificationType.adminAnnouncement;
    }
  }

  static NotificationCategory _parseCategory(String? cat) {
    switch (cat?.toLowerCase()) {
      case 'transactions':
      case 'transaction':
        return NotificationCategory.transactions;
      case 'updates':
      case 'update':
        return NotificationCategory.updates;
      case 'promotions':
      case 'promotion':
        return NotificationCategory.promotions;
      case 'security':
        return NotificationCategory.security;
      case 'marketing':
        return NotificationCategory.marketing;
      case 'system':
        return NotificationCategory.system;
      case 'maintenance':
        return NotificationCategory.maintenance;
      default:
        return NotificationCategory.all;
    }
  }

  static IconData _parseIcon(String? iconStr, NotificationType type) {
    switch (iconStr) {
      case 'transfer':
        return Boxicons.bx_transfer;
      case 'down_arrow_circle':
        return Boxicons.bx_down_arrow_circle;
      case 'tag':
        return Boxicons.bxs_tag;
      case 'megaphone':
        return Boxicons.bxs_megaphone;
      case 'shield':
        return Boxicons.bxs_shield;
      case 'wallet':
        return Boxicons.bx_wallet;
      case 'credit_card':
        return Boxicons.bx_credit_card;
      case 'gift':
        return Boxicons.bxs_gift;
      case 'badge':
        return Boxicons.bxs_badge_check;
      case 'bell':
        return Boxicons.bxs_bell_ring;
      case 'wrench':
        return Boxicons.bx_wrench;
      default:
        switch (type) {
          case NotificationType.transaction:
          case NotificationType.purchase:
          case NotificationType.withdrawal:
            return Boxicons.bx_transfer;
          case NotificationType.update:
          case NotificationType.priceUpdate:
            return Boxicons.bx_down_arrow_circle;
          case NotificationType.promotion:
          case NotificationType.welcomeBonus:
            return Boxicons.bxs_tag;
          case NotificationType.marketing:
            return Boxicons.bxs_megaphone;
          case NotificationType.securityAlert:
            return Boxicons.bxs_shield;
          case NotificationType.kycVerified:
            return Boxicons.bxs_badge_check;
          case NotificationType.maintenance:
            return Boxicons.bx_wrench;
          case NotificationType.adminAnnouncement:
          default:
            return Boxicons.bxs_bell_ring;
        }
    }
  }

  static Color _parseColor(dynamic colorValue, Color fallback) {
    if (colorValue is String && colorValue.startsWith('#')) {
      final hex = colorValue.replaceFirst('#', '');
      try {
        if (hex.length == 6) {
          return Color(int.parse('FF$hex', radix: 16));
        }
        if (hex.length == 8) {
          return Color(int.parse(hex, radix: 16));
        }
      } catch (_) {
        return fallback;
      }
    }
    return fallback;
  }
}