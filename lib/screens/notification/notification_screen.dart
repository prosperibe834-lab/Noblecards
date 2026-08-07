// Where to paste: lib/screens/notification/notification_screen.dart

import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'models/notification_model.dart';
import 'services/notification_service.dart';
import 'widgets/notification_banner.dart';
import 'widgets/notification_card.dart';
import 'widgets/notification_category_chip.dart';
import 'widgets/notification_loading_shimmer.dart';
import 'widgets/notification_empty_widget.dart';
import 'widgets/notification_settings_bottom_sheet.dart';
import 'widgets/swipe_notification_actions.dart';

// Import detail pages
import 'pages/order_pending_page.dart';
import 'pages/security_alert_page.dart';
import 'pages/welcome_bonus_page.dart';
import 'pages/promotion_details_page.dart';
import 'pages/kyc_verified_page.dart';
import 'pages/price_update_page.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationService _service = NotificationService();
  
  List<NotificationModel> _allNotifications = [];
  NotificationCategory _selectedCategory = NotificationCategory.all;
  bool _isLoading = true;
  bool _showPushCard = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    final data = await _service.fetchNotifications();
    if (mounted) {
      setState(() {
        _allNotifications = data;
        _isLoading = false;
      });
    }
  }

  void _onCategorySelected(NotificationCategory category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _markAllAsRead() {
    setState(() {
      _service.markAllAsRead(_allNotifications);
    });
  }

  void _openSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const NotificationSettingsBottomSheet(),
    );
  }

  void _navigateToDetail(NotificationModel item) {
    setState(() {
      item.isRead = true;
    });

    Widget targetPage;
    switch (item.type) {
      case NotificationType.orderPending:
        targetPage = const OrderPendingPage();
        break;
      case NotificationType.securityAlert:
        targetPage = const SecurityAlertPage();
        break;
      case NotificationType.welcomeBonus:
        targetPage = const WelcomeBonusPage();
        break;
      case NotificationType.promotion:
        targetPage = const PromotionDetailsPage();
        break;
      case NotificationType.kycVerified:
        targetPage = const KycVerifiedPage();
        break;
      case NotificationType.priceUpdate:
        targetPage = const PriceUpdatePage();
        break;
      default:
        targetPage = const OrderPendingPage();
        break;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => targetPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = _service.filterByCategory(_allNotifications, _selectedCategory);

    // Grouping
    final todayItems = filtered.where((e) => e.group == "Today").toList();
    final yesterdayItems = filtered.where((e) => e.group == "Yesterday").toList();
    final thisWeekItems = filtered.where((e) => e.group == "This Week").toList();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0E11) : const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Boxicons.bx_chevron_left, color: isDark ? Colors.white : Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Notifications",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Boxicons.bx_cog, color: isDark ? Colors.white : Colors.black, size: 22),
            onPressed: _openSettings,
          ),
        ],
      ),
      body: _isLoading
          ? const NotificationLoadingShimmer()
          : RefreshIndicator(
              onRefresh: _fetchData,
              color: const Color(0xFF00C853),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          NotificationCategoryChip(
                            label: "All",
                            isSelected: _selectedCategory == NotificationCategory.all,
                            onTap: () => _onCategorySelected(NotificationCategory.all),
                          ),
                          NotificationCategoryChip(
                            label: "Transactions",
                            isSelected: _selectedCategory == NotificationCategory.transactions,
                            onTap: () => _onCategorySelected(NotificationCategory.transactions),
                          ),
                          NotificationCategoryChip(
                            label: "Promotions",
                            isSelected: _selectedCategory == NotificationCategory.promotions,
                            onTap: () => _onCategorySelected(NotificationCategory.promotions),
                          ),
                          NotificationCategoryChip(
                            label: "Updates",
                            isSelected: _selectedCategory == NotificationCategory.updates,
                            onTap: () => _onCategorySelected(NotificationCategory.updates),
                          ),
                          NotificationCategoryChip(
                            label: "Security",
                            isSelected: _selectedCategory == NotificationCategory.security,
                            onTap: () => _onCategorySelected(NotificationCategory.security),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Banner
                    NotificationBanner(onMarkAllRead: _markAllAsRead),
                    const SizedBox(height: 20),

                    if (filtered.isEmpty)
                      const NotificationEmptyWidget()
                    else ...[
                      // Today Group
                      if (todayItems.isNotEmpty) ...[
                        _buildGroupHeader("Today", isDark),
                        ...todayItems.map((item) => _buildItemTile(item)),
                      ],

                      // Yesterday Group
                      if (yesterdayItems.isNotEmpty) ...[
                        _buildGroupHeader("Yesterday", isDark),
                        ...yesterdayItems.map((item) => _buildItemTile(item)),
                      ],

                      // This Week Group
                      if (thisWeekItems.isNotEmpty) ...[
                        _buildGroupHeader("This Week", isDark),
                        ...thisWeekItems.map((item) => _buildItemTile(item)),
                      ],
                    ],

                    const SizedBox(height: 16),

                    // Enable Push Notifications Card
                    if (_showPushCard)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF082215) : const Color(0xFFEBF9F0),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF00C853).withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Boxicons.bxs_bell, color: Color(0xFF00C853), size: 36),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Enable Push Notifications",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: isDark ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "Turn on push notifications to never miss important updates.",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark ? Colors.white54 : Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00C853),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {},
                              child: const Text("Enable", style: TextStyle(color: Colors.white, fontSize: 12)),
                            ),
                            IconButton(
                              icon: Icon(Boxicons.bx_x, color: isDark ? Colors.white54 : Colors.black45, size: 20),
                              onPressed: () => setState(() => _showPushCard = false),
                            )
                          ],
                        ),
                      ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildGroupHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildItemTile(NotificationModel item) {
    return SwipeNotificationActions(
      item: item,
      onToggleRead: () => setState(() => _service.toggleReadStatus(item)),
      onTogglePin: () => setState(() => _service.togglePin(item)),
      onDelete: () => setState(() => _allNotifications.removeWhere((e) => e.id == item.id)),
      child: NotificationCard(
        item: item,
        onTap: () => _navigateToDetail(item),
      ),
    );
  }
}