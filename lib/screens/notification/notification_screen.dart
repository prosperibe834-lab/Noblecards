import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boxicons/boxicons.dart';
import 'models/notification_model.dart';
import 'services/notification_service.dart';
import 'notification_details_screen.dart';
import 'widgets/notification_card.dart';
import 'widgets/notification_category_chip.dart';
import 'widgets/notification_loading_shimmer.dart';
import 'widgets/notification_empty_widget.dart';
import 'widgets/notification_settings_bottom_sheet.dart';
import 'widgets/swipe_notification_actions.dart';
import 'package:noble_cards/theme/app_radius.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with TickerProviderStateMixin {
  final NotificationService _service = NotificationService();
  final ScrollController _horizontalPillController = ScrollController();

  List<NotificationModel> _allNotifications = [];
  NotificationCategory _selectedCategory = NotificationCategory.all;
  bool _isLoading = true;

  // Floating animation for the 3D bell header
  late final AnimationController _floatController;
  late final Animation<double> _floatAnimation;

  // In-app incoming notification banner animation
  late final AnimationController _bannerController;
  late final Animation<Offset> _bannerSlideAnimation;
  NotificationModel? _incomingNotification;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -4.0, end: 4.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _bannerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _bannerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _bannerController, curve: Curves.easeOutBack),
    );

    _fetchData();
  }

  @override
  void dispose() {
    _floatController.dispose();
    _bannerController.dispose();
    _horizontalPillController.dispose();
    super.dispose();
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
    HapticFeedback.mediumImpact();
    setState(() {
      _service.markAllAsRead(_allNotifications);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('All notifications marked as read'),
          ],
        ),
        backgroundColor: const Color(0xFF00D084),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
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

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NotificationDetailsScreen(notification: item),
      ),
    );
  }

  /// Simulates receiving a real-time incoming notification on the phone!
  void _triggerIncomingNotificationDemo() {
    HapticFeedback.heavyImpact();
    final newNotification = NotificationModel(
      id: 'tx-new-${DateTime.now().millisecondsSinceEpoch}',
      title: 'Payment Received!',
      description: 'You received \$180.00 from Alex Morgan.\nFunds are available in your wallet.',
      time: 'Just now',
      group: 'Today',
      type: NotificationType.transaction,
      category: NotificationCategory.transactions,
      icon: Boxicons.bx_transfer,
      iconBgColor: const Color(0xFF10B981),
      iconColor: Colors.white,
      isRead: false,
    );

    setState(() {
      _service.addNotification(newNotification);
      _allNotifications.insert(0, newNotification);
      _incomingNotification = newNotification;
    });

    _bannerController.forward();

    // Auto-dismiss after 4.5 seconds
    Future.delayed(const Duration(milliseconds: 4500), () {
      if (mounted && _bannerController.status == AnimationStatus.completed) {
        _bannerController.reverse();
      }
    });
  }

  int _countFor(NotificationCategory category) {
    if (category == NotificationCategory.all) {
      return _allNotifications.length;
    }
    return _allNotifications.where((n) => n.category == category).length;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Palette strictly matching the mockup
    final bgColor = isDark ? const Color(0xFF0A161E) : const Color(0xFFF7FBF9);
    final headerTextColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    final filtered = _service.filterByCategory(
      _allNotifications,
      _selectedCategory,
    );

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          SafeArea(
            child: _isLoading
                ? const NotificationLoadingShimmer()
                : RefreshIndicator(
                    onRefresh: _fetchData,
                    color: const Color(0xFF00D084),
                    backgroundColor: isDark ? const Color(0xFF121E27) : Colors.white,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),

                          // Top Navigation Bar
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Boxicons.bx_chevron_left,
                                  color: headerTextColor,
                                  size: 28,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                              Row(
                                children: [
                                  // Live Test / Notification Simulator Bell Icon
                                  IconButton(
                                    tooltip: 'Simulate Incoming Notification',
                                    icon: Stack(
                                      children: [
                                        Icon(
                                          Boxicons.bx_bell,
                                          color: headerTextColor,
                                          size: 24,
                                        ),
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF00D084),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    onPressed: _triggerIncomingNotificationDemo,
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Boxicons.bx_cog,
                                      color: headerTextColor,
                                      size: 22,
                                    ),
                                    onPressed: _openSettings,
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // Header Row with Title, Subtitle, and 3D Floating Bell
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Notifications',
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w800,
                                        color: headerTextColor,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Stay updated with the latest activities,\nnews and important alerts.',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        height: 1.35,
                                        color: subTextColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // 3D Emerald Floating Bell Graphic
                              AnimatedBuilder(
                                animation: _floatAnimation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(0, _floatAnimation.value),
                                    child: child,
                                  );
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Ambient green aura glow
                                    Container(
                                      width: 72,
                                      height: 72,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: RadialGradient(
                                          colors: [
                                            const Color(0xFF00D084).withValues(alpha: isDark ? 0.45 : 0.25),
                                            const Color(0xFF00D084).withValues(alpha: 0.0),
                                          ],
                                        ),
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.asset(
                                        'lib/assets/illustrations/notification_bell_3d.jpg',
                                        width: 76,
                                        height: 76,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                            Container(
                                          width: 64,
                                          height: 64,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: const LinearGradient(
                                              colors: [Color(0xFF00D084), Color(0xFF00A86B)],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFF00D084).withValues(alpha: 0.4),
                                                blurRadius: 16,
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            Boxicons.bxs_bell_ring,
                                            color: Colors.white,
                                            size: 32,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Top Horizontal Filter Carousel (All 23, Transactions, Updates, etc.)
                          SingleChildScrollView(
                            controller: _horizontalPillController,
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Row(
                              children: [
                                NotificationCategoryChip(
                                  label: 'All',
                                  icon: Boxicons.bx_list_check,
                                  count: _countFor(NotificationCategory.all),
                                  isSelected: _selectedCategory == NotificationCategory.all,
                                  onTap: () => _onCategorySelected(NotificationCategory.all),
                                ),
                                NotificationCategoryChip(
                                  label: 'Transactions',
                                  icon: Boxicons.bx_transfer_alt,
                                  isSelected: _selectedCategory == NotificationCategory.transactions,
                                  onTap: () => _onCategorySelected(NotificationCategory.transactions),
                                ),
                                NotificationCategoryChip(
                                  label: 'Updates',
                                  icon: Boxicons.bx_check_circle,
                                  isSelected: _selectedCategory == NotificationCategory.updates,
                                  onTap: () => _onCategorySelected(NotificationCategory.updates),
                                ),
                                NotificationCategoryChip(
                                  label: 'Promotions',
                                  icon: Boxicons.bxs_tag,
                                  isSelected: _selectedCategory == NotificationCategory.promotions,
                                  onTap: () => _onCategorySelected(NotificationCategory.promotions),
                                ),
                                NotificationCategoryChip(
                                  label: 'Security',
                                  icon: Boxicons.bx_shield_quarter,
                                  isSelected: _selectedCategory == NotificationCategory.security,
                                  onTap: () => _onCategorySelected(NotificationCategory.security),
                                ),
                                NotificationCategoryChip(
                                  label: 'Marketing',
                                  icon: Boxicons.bxs_megaphone,
                                  isSelected: _selectedCategory == NotificationCategory.marketing,
                                  onTap: () => _onCategorySelected(NotificationCategory.marketing),
                                ),
                                NotificationCategoryChip(
                                  label: 'System',
                                  icon: Boxicons.bx_cog,
                                  isSelected: _selectedCategory == NotificationCategory.system,
                                  onTap: () => _onCategorySelected(NotificationCategory.system),
                                ),
                                NotificationCategoryChip(
                                  label: 'Maintenance',
                                  icon: Boxicons.bx_wrench,
                                  isSelected: _selectedCategory == NotificationCategory.maintenance,
                                  onTap: () => _onCategorySelected(NotificationCategory.maintenance),
                                ),
                                // Forward Arrow Pill
                                GestureDetector(
                                  onTap: () {
                                    _horizontalPillController.animateTo(
                                      _horizontalPillController.offset + 120,
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isDark ? const Color(0xFF121E27) : Colors.white,
                                      border: Border.all(
                                        color: isDark ? const Color(0xFF1E313D) : const Color(0xFFE2E8F0),
                                      ),
                                    ),
                                    child: Icon(
                                      Boxicons.bx_chevron_right,
                                      size: 18,
                                      color: subTextColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // 4x2 Category Grid Matrix (All: 23, Transactions: 8, Updates: 5, Promotions: 4, etc.)
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 4,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 0.94,
                            children: [
                              CategoryMatrixTile(
                                label: 'All',
                                count: _countFor(NotificationCategory.all),
                                icon: Boxicons.bx_grid_alt,
                                color: const Color(0xFF00D084),
                                isSelected: _selectedCategory == NotificationCategory.all,
                                onTap: () => _onCategorySelected(NotificationCategory.all),
                              ),
                              CategoryMatrixTile(
                                label: 'Transactions',
                                count: _countFor(NotificationCategory.transactions),
                                icon: Boxicons.bx_transfer_alt,
                                color: const Color(0xFF10B981),
                                isSelected: _selectedCategory == NotificationCategory.transactions,
                                onTap: () => _onCategorySelected(NotificationCategory.transactions),
                              ),
                              CategoryMatrixTile(
                                label: 'Updates',
                                count: _countFor(NotificationCategory.updates),
                                icon: Boxicons.bx_check_circle,
                                color: const Color(0xFF3B82F6),
                                isSelected: _selectedCategory == NotificationCategory.updates,
                                onTap: () => _onCategorySelected(NotificationCategory.updates),
                              ),
                              CategoryMatrixTile(
                                label: 'Promotions',
                                count: _countFor(NotificationCategory.promotions),
                                icon: Boxicons.bx_rocket,
                                color: const Color(0xFF8B5CF6),
                                isSelected: _selectedCategory == NotificationCategory.promotions,
                                onTap: () => _onCategorySelected(NotificationCategory.promotions),
                              ),
                              CategoryMatrixTile(
                                label: 'Security',
                                count: _countFor(NotificationCategory.security),
                                icon: Boxicons.bx_shield_quarter,
                                color: const Color(0xFF10B981),
                                isSelected: _selectedCategory == NotificationCategory.security,
                                onTap: () => _onCategorySelected(NotificationCategory.security),
                              ),
                              CategoryMatrixTile(
                                label: 'Marketing',
                                count: _countFor(NotificationCategory.marketing),
                                icon: Boxicons.bxs_megaphone,
                                color: const Color(0xFF0EA5E9),
                                isSelected: _selectedCategory == NotificationCategory.marketing,
                                onTap: () => _onCategorySelected(NotificationCategory.marketing),
                              ),
                              CategoryMatrixTile(
                                label: 'System',
                                count: _countFor(NotificationCategory.system),
                                icon: Boxicons.bx_cog,
                                color: const Color(0xFF64748B),
                                isSelected: _selectedCategory == NotificationCategory.system,
                                onTap: () => _onCategorySelected(NotificationCategory.system),
                              ),
                              CategoryMatrixTile(
                                label: 'Maintenance',
                                count: _countFor(NotificationCategory.maintenance),
                                icon: Boxicons.bx_wrench,
                                color: const Color(0xFFF97316),
                                isSelected: _selectedCategory == NotificationCategory.maintenance,
                                onTap: () => _onCategorySelected(NotificationCategory.maintenance),
                              ),
                            ],
                          ),

                          const SizedBox(height: 22),

                          // Section Header: "Today" and "✓ Mark all as read"
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Today',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: headerTextColor,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              InkWell(
                                onTap: _markAllAsRead,
                                borderRadius: BorderRadius.circular(AppRadius.sm),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(
                                        Icons.check_rounded,
                                        color: Color(0xFF00D084),
                                        size: 16,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Mark all as read',
                                        style: TextStyle(
                                          color: Color(0xFF00D084),
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Notification Items List
                          if (filtered.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 40),
                              child: NotificationEmptyWidget(),
                            )
                          else
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final item = filtered[index];
                                return SwipeNotificationActions(
                                  key: ValueKey(item.id),
                                  item: item,
                                  onToggleRead: () => setState(() => _service.toggleReadStatus(item)),
                                  onTogglePin: () => setState(() => _service.togglePin(item)),
                                  onDelete: () => setState(() => _allNotifications.removeWhere((e) => e.id == item.id)),
                                  child: NotificationCard(
                                    item: item,
                                    onTap: () => _navigateToDetail(item),
                                  ),
                                );
                              },
                            ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
          ),

          // In-App Incoming Notification Push Banner (Simulated on phone!)
          if (_incomingNotification != null)
            SlideTransition(
              position: _bannerSlideAnimation,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Dismissible(
                    key: const ValueKey('incoming-banner'),
                    direction: DismissDirection.up,
                    onDismissed: (_) => _bannerController.reverse(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF13222B) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF00D084).withValues(alpha: 0.6),
                          width: 1.4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00D084).withValues(alpha: 0.25),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            _bannerController.reverse();
                            _navigateToDetail(_incomingNotification!);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [Color(0xFF00D084), Color(0xFF00A86B)],
                                    ),
                                  ),
                                  child: const Icon(
                                    Boxicons.bxs_bell_ring,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            _incomingNotification!.title,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13.5,
                                              color: headerTextColor,
                                            ),
                                          ),
                                          const Text(
                                            'Just now',
                                            style: TextStyle(
                                              fontSize: 10.5,
                                              color: Color(0xFF00D084),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _incomingNotification!.description.split('\n').first,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          color: subTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.close_rounded,
                                    size: 18,
                                    color: subTextColor,
                                  ),
                                  onPressed: () => _bannerController.reverse(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

