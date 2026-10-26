import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../models/notification_model.dart';

class NotificationData {
  static List<NotificationModel> getInitialNotifications() {
    return [
      // 1. Transaction Successful (from mockup)
      NotificationModel(
        id: 'tx-1',
        title: 'Transaction Successful',
        description:
            'You received \$250.00 from John Doe.\nYour balance has been updated.',
        time: '2m ago',
        group: 'Today',
        type: NotificationType.transaction,
        category: NotificationCategory.transactions,
        icon: Boxicons.bx_transfer,
        iconBgColor: const Color(0xFF10B981),
        iconColor: Colors.white,
        isRead: false,
        actionKey: 'transaction',
        details: const [
          NotificationDetail(label: 'Amount', value: '\$250.00', icon: Icons.attach_money),
          NotificationDetail(label: 'Sender', value: 'John Doe', icon: Icons.person_outline),
          NotificationDetail(label: 'Status', value: 'Completed', icon: Icons.check_circle_outline),
        ],
      ),

      // 2. App Update Available (from mockup)
      NotificationModel(
        id: 'up-1',
        title: 'App Update Available',
        description:
            'A new version (v2.4.0) is now available\nwith improved features and performance.',
        time: '15m ago',
        group: 'Today',
        type: NotificationType.update,
        category: NotificationCategory.updates,
        icon: Boxicons.bx_down_arrow_circle,
        iconBgColor: const Color(0xFF8B5CF6),
        iconColor: Colors.white,
        isRead: true,
        actionKey: 'update',
        details: const [
          NotificationDetail(label: 'Version', value: 'v2.4.0', icon: Icons.info_outline),
          NotificationDetail(label: 'Size', value: '28.4 MB', icon: Icons.storage_outlined),
        ],
      ),

      // 3. Special Promotion (from mockup)
      NotificationModel(
        id: 'promo-1',
        title: 'Special Promotion',
        description:
            'Get 5% cashback on all card payments\nthis weekend. Don\'t miss out!',
        time: '1h ago',
        group: 'Today',
        type: NotificationType.promotion,
        category: NotificationCategory.promotions,
        icon: Boxicons.bxs_tag,
        iconBgColor: const Color(0xFF10B981),
        iconColor: Colors.white,
        isRead: false,
        actionKey: 'promotion',
        details: const [
          NotificationDetail(label: 'Cashback', value: '5%', icon: Icons.percent),
          NotificationDetail(label: 'Validity', value: 'Weekend Only', icon: Icons.calendar_today_outlined),
        ],
      ),

      // 4. Marketing (from mockup)
      NotificationModel(
        id: 'mkt-1',
        title: 'Marketing',
        description:
            'Discover our new travel rewards program\nand earn more points on every trip.',
        time: '2h ago',
        group: 'Today',
        type: NotificationType.marketing,
        category: NotificationCategory.marketing,
        icon: Boxicons.bxs_megaphone,
        iconBgColor: const Color(0xFF2563EB),
        iconColor: Colors.white,
        isRead: true,
        actionKey: 'marketing',
        details: const [
          NotificationDetail(label: 'Program', value: 'Travel Rewards', icon: Icons.flight_takeoff),
          NotificationDetail(label: 'Points Multiplier', value: '2x', icon: Icons.star_border),
        ],
      ),

      // 5. Security Announcement (from mockup)
      NotificationModel(
        id: 'sec-1',
        title: 'Security Announcement',
        description:
            'We\'ve enhanced our security measures\nto keep your account safer.',
        time: '3h ago',
        group: 'Today',
        type: NotificationType.securityAlert,
        category: NotificationCategory.security,
        icon: Boxicons.bxs_shield,
        iconBgColor: const Color(0xFFF59E0B),
        iconColor: Colors.white,
        isRead: true,
        actionKey: 'security',
        details: const [
          NotificationDetail(label: 'Protection', value: 'Active 2FA', icon: Icons.security),
          NotificationDetail(label: 'Audit Status', value: 'Verified', icon: Icons.verified_user_outlined),
        ],
      ),

      // 6. Transaction 2
      NotificationModel(
        id: 'tx-2',
        title: 'Gift Card Sold',
        description: 'Apple Gift Card \$100 verified and credited to wallet.',
        time: '4h ago',
        group: 'Today',
        type: NotificationType.transaction,
        category: NotificationCategory.transactions,
        icon: Boxicons.bx_credit_card,
        iconBgColor: const Color(0xFF10B981),
        iconColor: Colors.white,
        isRead: true,
      ),

      // 7. Transaction 3
      NotificationModel(
        id: 'tx-3',
        title: 'Withdrawal Processed',
        description: 'Transfer of ₦145,000 sent to GTBank account successfully.',
        time: '6h ago',
        group: 'Today',
        type: NotificationType.withdrawal,
        category: NotificationCategory.transactions,
        icon: Boxicons.bx_wallet,
        iconBgColor: const Color(0xFF059669),
        iconColor: Colors.white,
        isRead: true,
      ),

      // 8. Transaction 4
      NotificationModel(
        id: 'tx-4',
        title: 'Amazon Card Redeemed',
        description: 'Your Amazon \$50 submission has been approved.',
        time: '8h ago',
        group: 'Today',
        type: NotificationType.transaction,
        category: NotificationCategory.transactions,
        icon: Boxicons.bx_gift,
        iconBgColor: const Color(0xFF10B981),
        iconColor: Colors.white,
        isRead: true,
      ),

      // 9. Transaction 5
      NotificationModel(
        id: 'tx-5',
        title: 'Deposit Received',
        description: 'Bank transfer deposit of \$500 confirmed.',
        time: 'Yesterday',
        group: 'Yesterday',
        type: NotificationType.transaction,
        category: NotificationCategory.transactions,
        icon: Boxicons.bx_down_arrow_alt,
        iconBgColor: const Color(0xFF10B981),
        iconColor: Colors.white,
        isRead: true,
      ),

      // 10. Transaction 6
      NotificationModel(
        id: 'tx-6',
        title: 'Steam Card Sold',
        description: 'Steam EUR 50 payout credited instantly.',
        time: 'Yesterday',
        group: 'Yesterday',
        type: NotificationType.transaction,
        category: NotificationCategory.transactions,
        icon: Boxicons.bx_credit_card,
        iconBgColor: const Color(0xFF10B981),
        iconColor: Colors.white,
        isRead: true,
      ),

      // 11. Transaction 7
      NotificationModel(
        id: 'tx-7',
        title: 'Cashback Received',
        description: '\$12.50 reward credited from weekend promotion.',
        time: 'This Week',
        group: 'This Week',
        type: NotificationType.transaction,
        category: NotificationCategory.transactions,
        icon: Boxicons.bx_money,
        iconBgColor: const Color(0xFF10B981),
        iconColor: Colors.white,
        isRead: true,
      ),

      // 12. Transaction 8
      NotificationModel(
        id: 'tx-8',
        title: 'Virtual Card Loaded',
        description: 'Noble Virtual USD Card funded with \$150.00.',
        time: 'This Week',
        group: 'This Week',
        type: NotificationType.transaction,
        category: NotificationCategory.transactions,
        icon: Boxicons.bx_card,
        iconBgColor: const Color(0xFF10B981),
        iconColor: Colors.white,
        isRead: true,
      ),

      // 13. Update 2
      NotificationModel(
        id: 'up-2',
        title: 'Exchange Rates Updated',
        description: 'Real-time USD/NGN rates updated with higher sell margins.',
        time: '5h ago',
        group: 'Today',
        type: NotificationType.priceUpdate,
        category: NotificationCategory.updates,
        icon: Boxicons.bx_trending_up,
        iconBgColor: const Color(0xFF8B5CF6),
        iconColor: Colors.white,
        isRead: true,
      ),

      // 14. Update 3
      NotificationModel(
        id: 'up-3',
        title: 'New Gift Cards Added',
        description: 'Razer Gold and Google Play cards now supported.',
        time: 'Yesterday',
        group: 'Yesterday',
        type: NotificationType.update,
        category: NotificationCategory.updates,
        icon: Boxicons.bx_plus_circle,
        iconBgColor: const Color(0xFF8B5CF6),
        iconColor: Colors.white,
        isRead: true,
      ),

      // 15. Update 4
      NotificationModel(
        id: 'up-4',
        title: 'Terms of Service Updated',
        description: 'Read the latest updates to our user service agreement.',
        time: 'Yesterday',
        group: 'Yesterday',
        type: NotificationType.update,
        category: NotificationCategory.updates,
        icon: Boxicons.bx_file,
        iconBgColor: const Color(0xFF8B5CF6),
        iconColor: Colors.white,
        isRead: true,
      ),

      // 16. Update 5
      NotificationModel(
        id: 'up-5',
        title: 'KYC Tier 2 Approved',
        description: 'Your account limits have been increased to \$10,000/day.',
        time: 'This Week',
        group: 'This Week',
        type: NotificationType.kycVerified,
        category: NotificationCategory.updates,
        icon: Boxicons.bx_check_shield,
        iconBgColor: const Color(0xFF8B5CF6),
        iconColor: Colors.white,
        isRead: true,
      ),

      // 17. Promotion 2
      NotificationModel(
        id: 'promo-2',
        title: 'Zero Fee Friday',
        description: 'Sell any gift card with 0% transaction fee today.',
        time: 'Yesterday',
        group: 'Yesterday',
        type: NotificationType.promotion,
        category: NotificationCategory.promotions,
        icon: Boxicons.bx_badge_check,
        iconBgColor: const Color(0xFF10B981),
        iconColor: Colors.white,
        isRead: true,
      ),

      // 18. Promotion 3
      NotificationModel(
        id: 'promo-3',
        title: 'VIP Rate Booster',
        description: 'Earn up to 3% extra on Amazon & Apple trades.',
        time: 'This Week',
        group: 'This Week',
        type: NotificationType.promotion,
        category: NotificationCategory.promotions,
        icon: Boxicons.bx_rocket,
        iconBgColor: const Color(0xFF10B981),
        iconColor: Colors.white,
        isRead: true,
      ),

      // 19. Promotion 4
      NotificationModel(
        id: 'promo-4',
        title: 'Refer & Earn \$20',
        description: 'Invite your friends to NobleCards and get rewarded.',
        time: 'This Week',
        group: 'This Week',
        type: NotificationType.promotion,
        category: NotificationCategory.promotions,
        icon: Boxicons.bx_share_alt,
        iconBgColor: const Color(0xFF10B981),
        iconColor: Colors.white,
        isRead: true,
      ),

      // 20. Security 2
      NotificationModel(
        id: 'sec-2',
        title: 'New Login Detected',
        description: 'Successful login from iPhone 15 Pro in Lagos, NG.',
        time: 'Yesterday',
        group: 'Yesterday',
        type: NotificationType.securityAlert,
        category: NotificationCategory.security,
        icon: Boxicons.bx_lock_alt,
        iconBgColor: const Color(0xFFF59E0B),
        iconColor: Colors.white,
        isRead: true,
      ),

      // 21. Marketing 2
      NotificationModel(
        id: 'mkt-2',
        title: 'Join Our Community',
        description: 'Get daily rate tips and trader insights on Telegram.',
        time: 'This Week',
        group: 'This Week',
        type: NotificationType.marketing,
        category: NotificationCategory.marketing,
        icon: Boxicons.bxs_megaphone,
        iconBgColor: const Color(0xFF2563EB),
        iconColor: Colors.white,
        isRead: true,
      ),

      // 22. System 1
      NotificationModel(
        id: 'sys-1',
        title: 'System Operating at 100%',
        description: 'All trading and wallet APIs are functioning with low latency.',
        time: 'Today',
        group: 'Today',
        type: NotificationType.adminAnnouncement,
        category: NotificationCategory.system,
        icon: Boxicons.bx_cog,
        iconBgColor: const Color(0xFF64748B),
        iconColor: Colors.white,
        isRead: true,
      ),

      // 23. Maintenance 1
      NotificationModel(
        id: 'maint-1',
        title: 'Maintenance Completed',
        description: 'Scheduled core network infrastructure upgrade concluded.',
        time: 'Today',
        group: 'Today',
        type: NotificationType.maintenance,
        category: NotificationCategory.maintenance,
        icon: Boxicons.bx_wrench,
        iconBgColor: const Color(0xFFF97316),
        iconColor: Colors.white,
        isRead: true,
      ),
    ];
  }
}

