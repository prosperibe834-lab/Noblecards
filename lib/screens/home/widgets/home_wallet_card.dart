import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boxicons/boxicons.dart';
import '../../../localization/app_localizations.dart';

class HomeWalletCard extends StatefulWidget {
  final String mainBalance;
  final String availableBalance;
  final String pendingBalance;
  final String rewardPoints;
  final String growthPercentage;
  final VoidCallback? onAddTap;

  const HomeWalletCard({
    super.key,
    this.mainBalance = r'$78,012.60',
    this.availableBalance = r'$78,012.60',
    this.pendingBalance = r'$5,900.00',
    this.rewardPoints = '2,450',
    this.growthPercentage = '12.5%',
    this.onAddTap,
  });

  @override
  State<HomeWalletCard> createState() => _HomeWalletCardState();
}

class _HomeWalletCardState extends State<HomeWalletCard> {
  bool _isBalanceHidden = false;

  @override
  Widget build(BuildContext context) {
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
        boxShadow: const [
          BoxShadow(
            color: Color(0x3510B981),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Translucent credit card graphic watermark on the right
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              Boxicons.bx_credit_card,
              size: 160,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Row: "Wallet Balance" + Eye Toggle & Plus Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _isBalanceHidden = !_isBalanceHidden;
                        });
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        children: [
                          Text(
                            context.tr('wallet_balance', fallback: "Wallet Balance"),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 7),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              _isBalanceHidden
                                  ? Boxicons.bx_hide
                                  : Boxicons.bx_show,
                              key: ValueKey(_isBalanceHidden),
                              color: Colors.white70,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Add funds plus button
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        widget.onAddTap?.call();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Boxicons.bx_plus,
                          color: Color(0xFF0D6B3F),
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Main Amount with AnimatedSwitcher
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                  child: Text(
                    _isBalanceHidden ? r'$••••••••' : widget.mainBalance,
                    key: ValueKey(_isBalanceHidden ? 'hidden' : widget.mainBalance),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 6),

                // Trend indicator
                Row(
                  children: [
                    const Icon(
                      Boxicons.bx_up_arrow_alt,
                      color: Color(0xFF6EE7B7),
                      size: 16,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      widget.growthPercentage,
                      style: const TextStyle(
                        color: Color(0xFF6EE7B7),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      context.tr('this_month', fallback: "this month"),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Subtle divider
                Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
                const SizedBox(height: 14),

                // Bottom Statistics: Available Balance, Pending Balance, Reward Points
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSubBalanceItem(
                      context.tr('available_balance', fallback: "Available Balance"),
                      _isBalanceHidden ? r'$••••••' : widget.availableBalance,
                    ),
                    _buildSubBalanceItem(
                      context.tr('pending_balance', fallback: "Pending Balance"),
                      _isBalanceHidden ? r'$••••••' : widget.pendingBalance,
                    ),
                    _buildSubBalanceItem(
                      context.tr('reward_points', fallback: "Reward Points"),
                      widget.rewardPoints,
                    ),
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
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}
