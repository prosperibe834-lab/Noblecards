import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../theme/app_animation.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';

/// Navigation item model for bottom bar tabs
class NavigationTabItem {
  final String label;
  final IconData icon;
  final IconData? activeIcon;

  const NavigationTabItem({
    required this.label,
    required this.icon,
    this.activeIcon,
  });
}

/// Custom Bottom Navigation Bar for NobleCards matching the visual design.
class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  /// Compatibility getters/constructors for currentTab and onTabSelected
  final int? currentTab;
  final ValueChanged<int>? onTabSelected;

  const CustomBottomNav({
    super.key,
    int? currentIndex,
    ValueChanged<int>? onTap,
    int? currentTab,
    ValueChanged<int>? onTabSelected,
  })  : currentIndex = currentIndex ?? currentTab ?? 0,
        onTap = onTap ?? onTabSelected ?? _defaultOnTap,
        currentTab = currentTab ?? currentIndex ?? 0,
        onTabSelected = onTabSelected ?? onTap ?? _defaultOnTap;

  static void _defaultOnTap(int index) {}

  static const List<NavigationTabItem> items = [
    NavigationTabItem(
      label: 'Home',
      icon: Boxicons.bx_home_alt,
      activeIcon: Boxicons.bxs_home,
    ),
    NavigationTabItem(
      label: 'Cards',
      icon: Boxicons.bx_credit_card,
      activeIcon: Boxicons.bxs_credit_card,
    ),
    NavigationTabItem(
      label: 'Wallet',
      icon: Boxicons.bx_wallet,
      activeIcon: Boxicons.bxs_wallet,
    ),
    NavigationTabItem(
      label: 'Orders',
      icon: Boxicons.bx_receipt,
      activeIcon: Boxicons.bxs_receipt,
    ),
    NavigationTabItem(
      label: 'Profile',
      icon: Boxicons.bx_user,
      activeIcon: Boxicons.bxs_user,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Theme color mappings
    final navBgColor = isDark
        ? AppColors.darkCard.withOpacity(0.85)
        : AppColors.lightCard.withOpacity(0.95);

    final borderColor = isDark
        ? AppColors.darkBorder.withOpacity(0.6)
        : AppColors.lightBorder.withOpacity(0.8);

    final shadowColor = isDark
        ? Colors.black.withOpacity(0.40)
        : Colors.black.withOpacity(0.08);

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Outer Dock Bar
            Container(
              height: 68,
              decoration: BoxDecoration(
                color: navBgColor,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                border: Border.all(
                  color: borderColor,
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 24,
                    spreadRadius: 0,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(items.length, (index) {
                  final item = items[index];
                  final isActive = currentIndex == index;
                  final isWalletTab = index == 2;

                  if (isWalletTab) {
                    return Expanded(
                      child: _WalletNavItem(
                        item: item,
                        isActive: isActive,
                        isDark: isDark,
                        onTap: () => onTap(index),
                      ),
                    );
                  }

                  return Expanded(
                    child: _StandardNavItem(
                      item: item,
                      isActive: isActive,
                      isDark: isDark,
                      onTap: () => onTap(index),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Standard Navigation Item (Home, Cards, Orders, Profile)
class _StandardNavItem extends StatelessWidget {
  final NavigationTabItem item;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  const _StandardNavItem({
    required this.item,
    required this.isActive,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeTextColor = AppColors.primary;
    final inactiveTextColor =
        isDark ? AppColors.darkSubText : AppColors.lightSubText;

    final activeBgColor = isDark
        ? AppColors.primary.withOpacity(0.18)
        : AppColors.primary.withOpacity(0.10);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 2),
          // Icon Container with active background highlight
          AnimatedContainer(
            duration: AppAnimation.fast,
            curve: Curves.easeInOut,
            width: 40,
            height: 32,
            decoration: BoxDecoration(
              color: isActive ? activeBgColor : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              isActive ? (item.activeIcon ?? item.icon) : item.icon,
              size: 22,
              color: isActive ? activeTextColor : inactiveTextColor,
            ),
          ),
          const SizedBox(height: 2),
          // Label Text
          AnimatedDefaultTextStyle(
            duration: AppAnimation.fast,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isActive ? activeTextColor : inactiveTextColor,
            ),
            child: Text(item.label),
          ),
          const SizedBox(height: 3),
          // Active Indicator Dot
          AnimatedOpacity(
            duration: AppAnimation.fast,
            opacity: isActive ? 1.0 : 0.0,
            child: AnimatedScale(
              duration: AppAnimation.fast,
              scale: isActive ? 1.0 : 0.0,
              child: Container(
                width: 4.5,
                height: 4.5,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Central Wallet Navigation Item featuring glowing elevated circular button
class _WalletNavItem extends StatelessWidget {
  final NavigationTabItem item;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  const _WalletNavItem({
    required this.item,
    required this.isActive,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeTextColor = AppColors.primary;
    final inactiveTextColor =
        isDark ? AppColors.darkSubText : AppColors.lightSubText;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Raised circular wallet button with ambient radial glow
          Transform.translate(
            offset: const Offset(0, -6),
            child: AnimatedContainer(
              duration: AppAnimation.normal,
              curve: Curves.easeOutCubic,
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.successLight, // #34D399
                    AppColors.primary,      // #10B981
                    AppColors.primaryDark,  // #059669
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(isActive ? 0.50 : 0.30),
                    blurRadius: isActive ? 18 : 12,
                    spreadRadius: isActive ? 3 : 1,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: AppColors.successLight.withOpacity(0.30),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Icon(
                isActive ? (item.activeIcon ?? item.icon) : item.icon,
                size: 24,
                color: Colors.white,
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedDefaultTextStyle(
                  duration: AppAnimation.fast,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive ? activeTextColor : inactiveTextColor,
                  ),
                  child: Text(item.label),
                ),
                const SizedBox(height: 3),
                AnimatedOpacity(
                  duration: AppAnimation.fast,
                  opacity: isActive ? 1.0 : 0.0,
                  child: AnimatedScale(
                    duration: AppAnimation.fast,
                    scale: isActive ? 1.0 : 0.0,
                    child: Container(
                      width: 4.5,
                      height: 4.5,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}