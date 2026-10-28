import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../theme/app_colors.dart';
import '../services/wallet_service.dart';
import '../providers/wallet_provider.dart';
import 'authentication/services/authentication_service.dart';

import 'home/widgets/home_top_bar.dart';
import 'home/widgets/home_greeting.dart';
import 'home/widgets/home_wallet_card.dart';
import 'home/widgets/home_action_buttons.dart';
import 'home/widgets/home_featured_cards.dart';
import 'home/widgets/home_quick_actions.dart';
import 'home/widgets/home_todays_market.dart';
import 'home/widgets/home_loading_shimmer.dart';

import 'notification/notification_screen.dart';
import 'qrScanner/qr_scanner_screen.dart';
import 'cards/buy_gift_cards_catalog_screen.dart';
import 'cards/sell_gift_cards_catalog_screen.dart';
import 'rate/market_rates_screen.dart';
import 'deposit_screen.dart';
import 'Analytics/analytics_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onNavigateToCards;

  const HomeScreen({super.key, this.onNavigateToCards});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  AuthUser? _currentUser;
  double? _availableBalance;
  double? _pendingBalance;
  double? _mainBalance;

  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));

    final auth = AuthenticationService();
    _currentUser = auth.currentUser;
    final cached = WalletService.cachedBalances;
    if (cached != null) {
      _availableBalance = cached.availableBalance;
      _pendingBalance = cached.pendingBalance;
      _mainBalance = cached.availableBalance;
    }
    _fetchBackendData();
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _fetchBackendData() async {
    final auth = AuthenticationService();
    // 1. Fetch user profile from backend
    try {
      await auth.getUserProfile('current');
    } catch (_) {}

    // 2. Fetch wallet balances from backend
    WalletBalances? balances;
    try {
      final walletService = WalletService(authenticationService: auth);
      balances = await walletService.getUsdWalletBalances();
    } catch (_) {}

    if (!mounted) return;
    setState(() {
      _currentUser = auth.currentUser;
      if (balances != null) {
        _availableBalance = balances.availableBalance;
        _pendingBalance = balances.pendingBalance;
        _mainBalance = balances.availableBalance;
      }
    });

    // Also trigger refresh on WalletProvider if registered in context
    try {
      context.read<WalletProvider>().refresh();
    } catch (_) {}
  }

  Future<void> _handleRefresh() async {
    HapticFeedback.lightImpact();
    setState(() => _isLoading = true);

    await _fetchBackendData();
    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;
    setState(() => _isLoading = false);
    _animController.reset();
    _animController.forward();
    HapticFeedback.mediumImpact();
  }

  String get _resolvedUserName {
    final user = _currentUser ?? AuthenticationService().currentUser;
    final firstName = user?.firstName?.trim();
    if (firstName != null && firstName.isNotEmpty) {
      return firstName;
    }
    final username = user?.username?.trim();
    if (username != null && username.isNotEmpty) {
      return username;
    }
    final fullName = user?.displayName?.trim();
    if (fullName != null && fullName.isNotEmpty) {
      return fullName.split(' ').first;
    }
    return 'Fawaz';
  }

  String? get _resolvedAvatarUrl {
    final user = _currentUser ?? AuthenticationService().currentUser;
    final path = user?.profileImageUrl?.trim();
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    final base = AuthenticationService.apiBaseUrl.endsWith('/')
        ? AuthenticationService.apiBaseUrl.substring(0, AuthenticationService.apiBaseUrl.length - 1)
        : AuthenticationService.apiBaseUrl;
    return path.startsWith('/') ? '$base$path' : '$base/$path';
  }

  static String _formatUsd(double amount) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    return '\$${formatter.format(amount)}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark ? const Color(0xFF0B1319) : const Color(0xFFF8FAFC);

    WalletProvider? walletProvider;
    try {
      walletProvider = context.watch<WalletProvider>();
    } catch (_) {}

    final availableVal = _availableBalance ??
        (walletProvider != null && walletProvider.availableBalance > 0
            ? walletProvider.availableBalance
            : (walletProvider != null && walletProvider.balance > 0
                ? walletProvider.balance
                : (WalletService.cachedBalances?.availableBalance ?? 78012.60)));
    final pendingVal = _pendingBalance ??
        (walletProvider != null && walletProvider.pendingBalance > 0
            ? walletProvider.pendingBalance
            : (WalletService.cachedBalances?.pendingBalance ?? 5900.00));
    final mainVal = _mainBalance ??
        (walletProvider != null && walletProvider.balance > 0
            ? walletProvider.balance
            : availableVal);

    final formattedMain = _formatUsd(mainVal);
    final formattedAvailable = _formatUsd(availableVal);
    final formattedPending = _formatUsd(pendingVal);

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 1. PINNED / FIXED TOP BAR (Always in fixed position at the top)
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 10.0),
              child: HomeTopBar(
                onNotificationTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationScreen(),
                    ),
                  );
                },
                onQrScanTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const QrScannerScreen(),
                    ),
                  );
                },
              ),
            ),

            // 2. SCROLLABLE REFRESHABLE BODY WITH NETWORK SHIMMER AND ANIMATIONS
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isLoading
                    ? const HomeLoadingShimmer(key: ValueKey('shimmer'))
                    : RefreshIndicator(
                        key: const ValueKey('content'),
                        color: AppColors.primary,
                        backgroundColor: isDark ? const Color(0xFF101B22) : Colors.white,
                        onRefresh: _handleRefresh,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 6.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Greeting Section ("Hello," "Fawaz 👑" [✓ Verified])
                                  HomeGreeting(
                                    userName: _resolvedUserName,
                                    avatarUrl: _resolvedAvatarUrl,
                                  ),
                                  const SizedBox(height: 18),

                                  // Hero Wallet Balance Card
                                  HomeWalletCard(
                                    mainBalance: formattedMain,
                                    availableBalance: formattedAvailable,
                                    pendingBalance: formattedPending,
                                    rewardPoints: '2,450',
                                    growthPercentage: '+12.5%',
                                    onAddTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const DepositScreen(),
                                        ),
                                      );
                                    },
                                    onViewAnalytics: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const AnalyticsScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 18),

                                  // Action Buttons ("Buy Gift Cards ->" and "Sell Gift Cards ->")
                                  HomeActionButtons(
                                    onBuyTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const BuyGiftCardsCatalogScreen(),
                                        ),
                                      );
                                    },
                                    onSellTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const SellGiftCardsCatalogScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 24),

                                  // Featured Gift Cards (Apple & Amazon with badges, discounts, rates)
                                  HomeFeaturedCards(
                                    onViewAll: widget.onNavigateToCards ??
                                        () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const BuyGiftCardsCatalogScreen(),
                                        ),
                                      );
                                    },
                                    onCardTap: (card) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const BuyGiftCardsCatalogScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 24),

                                  // Quick Actions (4 Equal Items: Buy Gift Cards, Sell Cards, Exchange Rates, My Orders)
                                  HomeQuickActions(
                                    onNavigateToCards: widget.onNavigateToCards,
                                  ),
                                  const SizedBox(height: 24),

                                  // Today's Market Section
                                  HomeTodaysMarket(
                                    onViewAll: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const MarketRatesScreen(),
                                        ),
                                      );
                                    },
                                    onItemTap: (marketItem) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const MarketRatesScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 32),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
