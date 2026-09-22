import 'package:flutter/material.dart';

import '../models/notification_model.dart';

class NotificationData {
	static List<NotificationModel> getInitialNotifications() {
		return [
			NotificationModel(
				id: 'welcome-bonus',
				title: 'Welcome to NobleCards',
				description: 'Your account is ready to use.',
				time: 'Just now',
				group: 'Today',
				type: NotificationType.welcomeBonus,
				category: NotificationCategory.updates,
				icon: Icons.celebration_outlined,
				iconBgColor: const Color(0xFFE8F5E9),
				iconColor: const Color(0xFF00C853),
				actionKey: 'welcome',
			),
			NotificationModel(
				id: 'security-check',
				title: 'Keep your account secure',
				description: 'Review your security settings regularly.',
				time: 'Today',
				group: 'Today',
				type: NotificationType.securityAlert,
				category: NotificationCategory.security,
				icon: Icons.security_outlined,
				iconBgColor: const Color(0xFFFFEBEE),
				iconColor: const Color(0xFFD32F2F),
				actionKey: 'security',
			),
			NotificationModel(
				id: 'price-update',
				title: 'Market prices updated',
				description: 'Your currency prices have been refreshed.',
				time: 'Yesterday',
				group: 'Yesterday',
				type: NotificationType.priceUpdate,
				category: NotificationCategory.updates,
				icon: Icons.trending_up_outlined,
				iconBgColor: const Color(0xFFE3F2FD),
				iconColor: const Color(0xFF1976D2),
				actionKey: 'price',
			),
		];
	}
}
