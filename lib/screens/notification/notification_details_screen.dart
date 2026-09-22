import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

// Adjust these imports based on your actual project structure
import '../../theme/app_animation.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_shadow.dart';
import '../../theme/app_spacing.dart';
import 'models/notification_model.dart'; // Your existing model

class NotificationDetailsScreen extends StatefulWidget {
  final NotificationModel notification;
  final bool isLoading;

  const NotificationDetailsScreen({
    Key? key,
    required this.notification,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<NotificationDetailsScreen> createState() =>
      _NotificationDetailsScreenState();
}

class _NotificationDetailsScreenState extends State<NotificationDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeHeader;
  late Animation<double> _fadeHero;
  late Animation<double> _fadeDetails;
  late Animation<double> _fadeSupporting;
  late Animation<Offset> _slideHero;
  late Animation<Offset> _slideDetails;
  late Animation<Offset> _slideSupporting;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: AppAnimation.slow, // Using existing theme animation duration
    );

    // Staggered Animations for a premium fintech feel
    _fadeHeader = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _fadeHero = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.1, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _fadeDetails = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _fadeSupporting = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _slideHero = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.1, 0.6, curve: Curves.easeOutCubic),
    ));

    _slideDetails =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _slideSupporting =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    if (!widget.isLoading) {
      _animController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant NotificationDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoading && !widget.isLoading) {
      _animController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // Action Handler based on your actionKey architecture
  void _handleActionTap() {
    if (widget.notification.actionKey == null ||
        widget.notification.actionKey!.isEmpty) return;

    final key = widget.notification.actionKey!.toLowerCase();
    
    // Haptic feedback for premium feel
    HapticFeedback.lightImpact();

    // Map your existing routes here
    if (key.contains('kyc')) {
      // Navigator.pushNamed(context, '/kyc');
    } else if (key.contains('security')) {
      // Navigator.pushNamed(context, '/security');
    } else if (key.contains('purchase') || key.contains('order')) {
      // Navigator.pushNamed(context, '/orderDetails');
    } else if (key.contains('withdrawal')) {
      // Navigator.pushNamed(context, '/withdrawalDetails');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        bottom: false,
        child: widget.isLoading
            ? const _NotificationDetailsShimmer()
            : Column(
                children: [
                  _buildHeader(isDark),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SlideTransition(
                            position: _slideHero,
                            child: FadeTransition(
                              opacity: _fadeHero,
                              child: _buildHeroCard(isDark),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                            if (widget.notification.details.isNotEmpty) ...[
                            SlideTransition(
                              position: _slideDetails,
                              child: FadeTransition(
                                opacity: _fadeDetails,
                                child: _buildDetailsCard(isDark),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                          ],
                          SlideTransition(
                            position: _slideSupporting,
                            child: FadeTransition(
                              opacity: _fadeSupporting,
                              child: _buildSupportingCard(isDark),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.huge),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    final textTheme = Theme.of(context).textTheme;
    return FadeTransition(
      opacity: _fadeHeader,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.s,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            Text(
              "Notification Details",
              style: textTheme.titleLarge?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.more_vert_rounded,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
              onPressed: () {}, // Optional menu
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard(bool isDark) {
    final textTheme = Theme.of(context).textTheme;
    
    // Dynamic coloring based on category (Fallback to brand primary)
    Color baseColor = AppColors.primary;
    switch (widget.notification.type) {
      case NotificationType.securityAlert:
        baseColor = AppColors.error;
        break;
      case NotificationType.orderPending:
        baseColor = AppColors.warning;
        break;
      case NotificationType.purchase:
      case NotificationType.withdrawal:
        baseColor = AppColors.secondary;
        break;
      default:
        break;
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: isDark ? AppShadow.dark : AppShadow.light,
        border: Border.all(
          color: baseColor.withOpacity(isDark ? 0.2 : 0.1),
          width: 1,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [baseColor.withOpacity(0.3), AppColors.darkCard]
              : [baseColor.withOpacity(0.15), Colors.white],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Stack(
          children: [
            // Decorative background shapes matching reference
            Positioned(
              right: -30,
              top: -20,
              child: Transform.rotate(
                angle: 0.2,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    gradient: LinearGradient(
                      colors: [
                        baseColor.withOpacity(isDark ? 0.1 : 0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Main Content
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Glowing Icon Container
                      Container(
                        height: 64,
                        width: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [baseColor, baseColor.withOpacity(0.7)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: baseColor.withOpacity(0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.notification.icon,
                          color: widget.notification.iconColor,
                          size: 32,
                        ),
                      ),
                      const Spacer(),
                      // Category Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: baseColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        child: Text(
                          _categoryLabel(widget.notification.category),
                          style: textTheme.bodyMedium?.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : baseColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    widget.notification.title,
                    style: textTheme.titleLarge?.copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    widget.notification.description,
                    style: textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? AppColors.darkSubText
                          : AppColors.lightSubText,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 16,
                        color: isDark
                            ? AppColors.darkSubText
                            : AppColors.lightSubText,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        widget.notification.time,
                        style: textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.darkSubText
                              : AppColors.lightSubText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _categoryLabel(NotificationCategory category) {
    switch (category) {
      case NotificationCategory.all:
        return 'ALL';
      case NotificationCategory.transactions:
        return 'TRANSACTIONS';
      case NotificationCategory.promotions:
        return 'PROMOTIONS';
      case NotificationCategory.updates:
        return 'UPDATES';
      case NotificationCategory.security:
        return 'SECURITY';
    }
  }

  Widget _buildDetailsCard(bool isDark) {
    final textTheme = Theme.of(context).textTheme;
    final details = widget.notification.details;
    final statusDetail = details.cast<NotificationDetail?>().firstWhere(
          (detail) => detail!.label.toLowerCase() == 'status',
          orElse: () => null,
        );

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: isDark ? AppShadow.dark : AppShadow.light,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Details Header Row
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Icon(
                  Icons.receipt_long_rounded,
                  color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                ),
                const SizedBox(width: AppSpacing.s),
                Text(
                  "Verification Details", // Or dynamic based on category
                  style: textTheme.titleLarge?.copyWith(fontSize: 16),
                ),
                const Spacer(),
                // Status indicator (derived from details if 'Status' exists)
                if (statusDetail != null)
                  _buildStatusBadge(statusDetail.value, isDark, textTheme),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          // Details Rows
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
                children: details
                  .where((detail) => detail.label.toLowerCase() != 'status')
                  .map((detail) => _buildDetailRow(
                    detail, isDark, textTheme))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
      NotificationDetail detail, bool isDark, TextTheme textTheme) {
    final label = detail.label;
    final value = detail.value;
    final isPositive = value.toLowerCase() == 'verified' ||
        value.toLowerCase() == 'successful';

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Icon(
            detail.icon,
            size: 18,
            color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: textTheme.bodyLarge?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isPositive 
                ? AppColors.success 
                : (isDark ? AppColors.darkText : AppColors.lightText),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status, bool isDark, TextTheme textTheme) {
    bool isSuccess = status.toLowerCase() == 'verified' || status.toLowerCase() == 'successful';
    Color color = isSuccess ? AppColors.success : AppColors.warning;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isSuccess ? Icons.check_circle : Icons.pending,
              size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            status,
            style: textTheme.bodyMedium?.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportingCard(bool isDark) {
    final textTheme = Theme.of(context).textTheme;
    final supportText = _supportingText(widget.notification.type);

    return GestureDetector(
      onTap: _handleActionTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: isDark ? AppShadow.dark : AppShadow.light,
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: isDark
                ? [AppColors.primaryDark.withOpacity(0.2), AppColors.darkCard]
                : [AppColors.successLight.withOpacity(0.15), Colors.white],
          ),
          border: Border.all(
            color: AppColors.primary.withOpacity(isDark ? 0.2 : 0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shield_outlined,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "What this means",
                    style: textTheme.titleLarge?.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    supportText,
                    style: textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkSubText
                          : AppColors.lightSubText,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            if (widget.notification.actionKey != null) ...[
              const SizedBox(width: AppSpacing.sm),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.primary,
              ),
            ]
          ],
        ),
      ),
    );
  }

  String _supportingText(NotificationType type) {
    switch (type) {
      case NotificationType.kycVerified:
        return 'Your account is now fully verified and you can access all supported NobleCards features.';
      case NotificationType.securityAlert:
        return 'If you do not recognize this activity, review your account security settings immediately.';
      case NotificationType.priceUpdate:
        return 'Gift card pricing has been updated. Review the latest rate before your next transaction.';
      case NotificationType.purchase:
        return 'Your purchase was processed successfully. Review the transaction details above.';
      case NotificationType.withdrawal:
        return 'Your withdrawal request has been recorded. Review the transaction details above.';
      case NotificationType.orderPending:
        return 'Your order is being processed. We will update you when its status changes.';
      case NotificationType.promotion:
        return 'Review this promotion to see how it can benefit your next NobleCards transaction.';
      case NotificationType.welcomeBonus:
        return 'Your welcome bonus is available in your NobleCards wallet.';
      case NotificationType.adminAnnouncement:
        return 'Please review this announcement for the latest NobleCards updates.';
    }
  }
}

// ---------------------------------------------------------
// SHIMMER LOADING SKELETON (NO EXTERNAL PACKAGES REQUIRED)
// ---------------------------------------------------------

class _NotificationDetailsShimmer extends StatefulWidget {
  const _NotificationDetailsShimmer();

  @override
  State<_NotificationDetailsShimmer> createState() =>
      _NotificationDetailsShimmerState();
}

class _NotificationDetailsShimmerState
    extends State<_NotificationDetailsShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Opacity(
          opacity: 0.4 + (_pulseController.value * 0.6),
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          children: [
            const SizedBox(height: 60), // Header space
            // Hero Skeleton
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: baseColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            // Details Skeleton
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: baseColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            // Supporting Skeleton
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: baseColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
            ),
          ],
        ),
      ),
    );
  }
}