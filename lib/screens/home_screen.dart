import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onNavigateToCards;

  const HomeScreen({super.key, this.onNavigateToCards});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isBalanceHidden = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Surface colors adaptive to current theme mode
    final bgColor = isDark ? const Color(0xFF0B0E14) : const Color(0xFFF4F6F9);
    final cardBgColor = isDark ? const Color(0xFF161922) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. TOP BAR / APP HEADER
              _buildTopBar(isDark, textColor, cardBgColor),
              const SizedBox(height: 16),

              // 2. USER GREETING SECTION
              _buildGreeting(textColor, subTextColor),
              const SizedBox(height: 20),

              // 3. WALLET BALANCE CARD
              _buildWalletCard(),
              const SizedBox(height: 20),

              // 4. MAIN ACTION BUTTONS (BUY / SELL)
              _buildMainActionButtons(isDark, cardBgColor, textColor),
              const SizedBox(height: 24),

              // 5. FEATURED GIFT CARDS
              _buildSectionHeader(
                title: "Featured Gift Cards",
                textColor: textColor,
                onViewAll: widget.onNavigateToCards ?? () {},
              ),
              const SizedBox(height: 12),
              _buildFeaturedCardsList(isDark),
              const SizedBox(height: 24),

              // 6. QUICK ACTIONS GRID
              _buildSectionHeader(
                title: "Quick Actions",
                textColor: textColor,
                showViewAll: false,
              ),
              const SizedBox(height: 12),
              _buildQuickActionsGrid(isDark, cardBgColor, textColor),
              const SizedBox(height: 24),

              // 7. TODAY'S MARKET
              _buildSectionHeader(
                title: "Today's Market",
                textColor: textColor,
                onViewAll: widget.onNavigateToCards ?? () {},
              ),
              const SizedBox(height: 12),
              _buildTodaysMarketList(isDark, cardBgColor, textColor, subTextColor),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildTopBar(bool isDark, Color textColor, Color cardBg) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Boxicons.bx_credit_card_front,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "NobleCards",
              style: TextStyle(
                color: textColor,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        Row(
          children: [
            // Notification Bell with Badge
            GestureDetector(
              onTap: widget.onNavigateToCards ?? () {},
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: cardBg,
                      shape: BoxShape.circle,
                      boxShadow: [
                        if (!isDark)
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                      ],
                    ),
                    child: Icon(
                      Boxicons.bx_bell,
                      color: isDark ? Colors.white : const Color(0xFF334155),
                      size: 20,
                    ),
                  ),
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(width: 10),
            // QR Scan Icon
            GestureDetector(
              onTap: widget.onNavigateToCards ?? () {},
              child: Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: Icon(
                  Boxicons.bx_qr_scan,
                  color: isDark ? Colors.white : const Color(0xFF334155),
                  size: 20,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildGreeting(Color textColor, Color subTextColor) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 22,
          backgroundImage: NetworkImage(
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200',
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Hello, Prosper",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                const Text("👋", style: TextStyle(fontSize: 15)),
              ],
            ),
            Text(
              "Welcome back to NobleCards",
              style: TextStyle(
                color: subTextColor,
                fontSize: 13,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildWalletCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F5132),
            Color(0xFF0D6B3F),
            Color(0xFF10B981),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              Boxicons.bx_credit_card,
              size: 160,
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Wallet Balance",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isBalanceHidden = !_isBalanceHidden;
                            });
                          },
                          child: Icon(
                            _isBalanceHidden ? Boxicons.bx_hide : Boxicons.bx_show,
                            color: Colors.white70,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: widget.onNavigateToCards ?? () {},
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Boxicons.bx_plus,
                          color: Color(0xFF0D6B3F),
                          size: 20,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _isBalanceHidden ? '\$*******' : '\$251,000.00',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: const [
                    Icon(Boxicons.bx_up_arrow_alt, color: Color(0xFF6EE7B7), size: 16),
                    SizedBox(width: 2),
                    Text(
                      "12.5%",
                      style: TextStyle(
                        color: Color(0xFF6EE7B7),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      "this month",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  height: 1,
                  color: Colors.white.withOpacity(0.15),
                ),
                const SizedBox(height: 14),
                if (!_isBalanceHidden)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSubBalanceItem("Available Balance", '\$200,000.00'),
                      _buildSubBalanceItem("Pending Balance", '\$25,000.00'),
                      _buildSubBalanceItem("Reward Points", "2,450"),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubBalanceItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMainActionButtons(bool isDark, Color cardBg, Color textColor) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: widget.onNavigateToCards ?? () {},
            icon: const Icon(Boxicons.bx_shopping_bag, size: 18, color: Colors.white),
            label: const Text(
              "Buy Gift Cards",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: widget.onNavigateToCards ?? () {},
            icon: Icon(
              Boxicons.bx_tag,
              size: 18,
              color: isDark ? Colors.white : const Color(0xFF10B981),
            ),
            label: Text(
              "Sell Gift Cards",
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: cardBg,
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(
                color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required Color textColor,
    bool showViewAll = true,
    VoidCallback? onViewAll,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (showViewAll)
          GestureDetector(
            onTap: onViewAll,
            child: const Text(
              "View all",
              style: TextStyle(
                color: Color(0xFF10B981),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFeaturedCardsList(bool isDark) {
    final cards = [
      {
        'name': 'Amazon',
        'buy': '\$460.00',
        'sell': '\$440.00',
        'color': const Color(0xFF141414),
        'icon': Boxicons.bxl_amazon,
        'flag': '🇺🇸',
      },
      {
        'name': 'Apple',
        'buy': '\$700.00',
        'sell': '\$680.00',
        'color': const Color(0xFF5B32EA),
        'icon': Boxicons.bxl_apple,
        'flag': '🇺🇸',
      },
      {
        'name': 'Steam',
        'buy': '\$420.00',
        'sell': '\$400.00',
        'color': const Color(0xFF17202A),
        'icon': Boxicons.bxl_steam,
        'flag': '🇺🇸',
      },
      {
        'name': 'Google Play',
        'buy': '\$350.00',
        'sell': '\$330.00',
        'color': isDark ? Colors.white : const Color(0xFFFFFFFF),
        'icon': Boxicons.bxl_play_store,
        'flag': '🇺🇸',
      },
    ];

    return SizedBox(
      height: 145,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final item = cards[index];
          final cardColor = item['color'] as Color;
          final isLightCard = cardColor == Colors.white;
          final cardTextColor = isLightCard ? Colors.black : Colors.white;

          return GestureDetector(
            onTap: widget.onNavigateToCards ?? () {},
            child: Container(
              width: 135,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(18),
                border: isLightCard ? Border.all(color: Colors.grey.shade300) : null,
                boxShadow: [
                  if (isLightCard && !isDark)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                    )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        item['icon'] as IconData,
                        color: cardTextColor,
                        size: 24,
                      ),
                      Icon(
                        Boxicons.bx_heart,
                        color: cardTextColor.withOpacity(0.6),
                        size: 18,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        item['name'] as String,
                        style: TextStyle(
                          color: cardTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(item['flag'] as String, style: const TextStyle(fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Buy  ${item['buy']}",
                    style: TextStyle(
                      color: cardTextColor.withOpacity(0.7),
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    "Sell  ${item['sell']}",
                    style: TextStyle(
                      color: cardTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickActionsGrid(
      bool isDark, Color cardBg, Color textColor) {
    final actions = [
      {'label': 'Buy Gift\nCards', 'icon': Boxicons.bx_shopping_bag},
      {'label': 'Sell\nCards', 'icon': Boxicons.bx_refresh},
      {'label': 'Exchange\nRates', 'icon': Boxicons.bx_line_chart},
      {'label': 'My\nOrders', 'icon': Boxicons.bx_receipt},
      {'label': 'My\nWallet', 'icon': Boxicons.bx_wallet},
      {'label': 'Transaction\nHistory', 'icon': Boxicons.bx_history},
      {'label': 'Saved\nCards', 'icon': Boxicons.bx_credit_card},
      {'label': 'Referral\nProgram', 'icon': Boxicons.bx_gift},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 10,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        final item = actions[index];
        return GestureDetector(
          onTap: widget.onNavigateToCards ?? () {},
          child: Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: const Color(0xFF10B981),
                    size: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item['label'] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTodaysMarketList(
      bool isDark, Color cardBg, Color textColor, Color subTextColor) {
    final marketData = [
      {
        'tag': 'Highest Paying',
        'icon': Boxicons.bxl_amazon,
        'price': '\$480.00',
        'change': '↑ 8.2%',
      },
      {
        'tag': 'Trending',
        'icon': Boxicons.bxl_steam,
        'price': '\$430.00',
        'change': '↑ 6.5%',
      },
      {
        'tag': 'Most Traded',
        'icon': Boxicons.bxl_apple,
        'price': '\$690.00',
        'change': '↑ 5.1%',
      },
      {
        'tag': 'Best Selling',
        'icon': Boxicons.bxl_play_store,
        'price': '\$340.00',
        'change': '↑ 4.3%',
      },
    ];

    return SizedBox(
      height: 95,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: marketData.length,
        itemBuilder: (context, index) {
          final item = marketData[index];
          return GestureDetector(
            onTap: widget.onNavigateToCards ?? () {},
            child: Container(
              width: 125,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item['tag'] as String,
                    style: TextStyle(
                      color: subTextColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        item['icon'] as IconData,
                        color: textColor,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['price'] as String,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            item['change'] as String,
                            style: const TextStyle(
                              color: Color(0xFF10B981),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}