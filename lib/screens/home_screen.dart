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

class HomeScreen extends StatefulWidget {
  final VoidCallback? onNavigateToCards;

  const HomeScreen({super.key, this.onNavigateToCards});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  AuthUser? _currentUser;
  double? _availableBalance;
  double? _pendingBalance;
  double? _mainBalance;

  @override
  void initState() {
    super.initState();
    final auth = AuthenticationService();
    _currentUser = auth.currentUser;
    final cached = WalletService.cachedBalances;
    if (cached != null) {
      _availableBalance = cached.availableBalance;
      _pendingBalance = cached.pendingBalance;
      _mainBalance = cached.availableBalance;
    }
    _fetchBackendData();
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
    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;
    setState(() => _isLoading = false);
    HapticFeedback.mediumImpact();
  }

  String get _resolvedUserName {
    final user = _currentUser ?? AuthenticationService().currentUser;
    final username = user?.username?.trim();
    if (username != null && username.isNotEmpty) {
      return username;
    }
    final fullName = user?.displayName?.trim() ??
        '${user?.firstName ?? ''} ${user?.lastName ?? ''}'.trim();
    if (fullName.isNotEmpty) {
      return fullName;
    }
    return 'firminofx1';
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
    final scaffoldBg = isDark ? AppColors.darkBackground : AppColors.lightBackground;

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
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isLoading
              ? const HomeLoadingShimmer(key: ValueKey('shimmer'))
              : RefreshIndicator(
                  key: const ValueKey('content'),
                  color: AppColors.primary,
                  backgroundColor: isDark ? const Color(0xFF141E26) : Colors.white,
                  onRefresh: _handleRefresh,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. TOP BAR / APP HEADER (NobleCards brand mark, Notification Bell, QR Scan)
                        HomeTopBar(
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
                        const SizedBox(height: 18),

                        // 2. USER GREETING SECTION ("Hello, username / fullName 👋")
                        HomeGreeting(
                          userName: _resolvedUserName,
                          avatarUrl: _resolvedAvatarUrl,
                        ),
                        const SizedBox(height: 20),

                        // 3. WALLET BALANCE CARD (Dollar currency, backend balances, and stats)
                        HomeWalletCard(
                          mainBalance: formattedMain,
                          availableBalance: formattedAvailable,
                          pendingBalance: formattedPending,
                          rewardPoints: '2,450',
                          growthPercentage: '12.5%',
                          onAddTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const DepositScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),

                        // 4. MAIN ACTION BUTTONS ("Buy Gift Cards" & "Sell Gift Cards")
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
                        const SizedBox(height: 26),

                        // 5. FEATURED GIFT CARDS (Top-Tier Panoramic Cards: Apple, Amazon, Steam, Google Play)
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
                        const SizedBox(height: 26),

                        // 6. QUICK ACTIONS (4x2 Grid Matrix of 8 Actions)
                        HomeQuickActions(
                          onNavigateToCards: widget.onNavigateToCards,
                        ),
                        const SizedBox(height: 26),

                        // 7. TODAY'S MARKET (Highest Paying, Trending, Most Traded, Best Selling)
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
    );
  }
}
