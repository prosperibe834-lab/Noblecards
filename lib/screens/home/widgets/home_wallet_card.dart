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
  final VoidCallback? onViewAnalytics;

  const HomeWalletCard({
    super.key,
    this.mainBalance = r'$78,012.60',
    this.availableBalance = r'$78,012.60',
    this.pendingBalance = r'$5,900.00',
    this.rewardPoints = '2,450',
    this.growthPercentage = '+12.5%',
    this.onAddTap,
    this.onViewAnalytics,
  });

  @override
  State<HomeWalletCard> createState() => _HomeWalletCardState();
}

class _HomeWalletCardState extends State<HomeWalletCard> {
  bool _isBalanceHidden = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Gradient styling for Light vs Dark mode
    final cardGradient = isDark
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF062319),
              Color(0xFF093726),
            ],
          )
        : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFDCF8EC),
            ],
          );

    final borderColor = isDark
        ? const Color(0xFF13533A)
        : const Color(0xFFC7F3DE);

    final shadowColor = isDark
        ? const Color(0xFF00E599).withOpacity(0.24)
        : const Color(0x1800D084);

    final titleTextColor = isDark ? Colors.white : const Color(0xFF0A1E17);
    final labelTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF5A6E78);
    final dividerColor = isDark ? const Color(0xFF133F30) : const Color(0xFFD6F3E6);

    final waveColor = isDark
        ? const Color(0xFF00E599).withOpacity(0.35)
        : const Color(0xFF34D399).withOpacity(0.40);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: cardGradient,
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: isDark ? 28 : 22,
            offset: const Offset(0, 8),
            spreadRadius: isDark ? 1 : 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(23),
        child: Stack(
          children: [
            // Decorative Sine Wave Graphics on the Right Side
            Positioned(
              right: 0,
              bottom: 45,
              width: 170,
              height: 75,
              child: CustomPaint(
                painter: _SineWavePainter(color: waveColor),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: "Wallet Balance" + Eye Toggle & Floating Glowing Wallet Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                              style: TextStyle(
                                color: labelTextColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              _isBalanceHidden
                                  ? Boxicons.bx_hide
                                  : Boxicons.bx_show,
                              key: ValueKey(_isBalanceHidden),
                              color: labelTextColor,
                              size: 17,
                            ),
                          ],
                        ),
                      ),

                      // Glowing Mint/Emerald Wallet Button
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          widget.onAddTap?.call();
                        },
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF38EAA0), Color(0xFF00C06D)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x4000D084),
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Boxicons.bx_wallet,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Giant Main Balance Amount
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                    child: Text(
                      _isBalanceHidden ? r'$••••••••' : widget.mainBalance,
                      key: ValueKey(_isBalanceHidden ? 'hidden' : widget.mainBalance),
                      style: TextStyle(
                        color: titleTextColor,
                        fontSize: 31,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.6,
                        height: 1.15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Trend row ("↑ +12.5% this month") & "View Analytics >" Pill
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Growth indicator
                      Row(
                        children: [
                          const Icon(
                            Boxicons.bx_up_arrow_alt,
                            color: Color(0xFF00D084),
                            size: 16,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            widget.growthPercentage,
                            style: const TextStyle(
                              color: Color(0xFF00D084),
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            context.tr('this_month', fallback: "this month"),
                            style: TextStyle(
                              color: labelTextColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),

                      // "View Analytics >" Pill Button
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          widget.onViewAnalytics?.call();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF0A2E22) : const Color(0xFFE8F9F1),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isDark ? const Color(0xFF135A40) : const Color(0xFFA7F3D0),
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "View Analytics",
                                style: TextStyle(
                                  color: isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Icon(
                                Boxicons.bx_chevron_right,
                                color: isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Subtle Divider
                  Container(
                    height: 1,
                    color: dividerColor,
                  ),
                  const SizedBox(height: 14),

                  // Bottom 3 Columns: Available Balance, Pending Balance, Reward Points
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatColumn(
                        context.tr('available_balance', fallback: "Available Balance"),
                        _isBalanceHidden ? r'$••••••' : widget.availableBalance,
                        titleTextColor,
                        labelTextColor,
                      ),
                      _buildStatColumn(
                        context.tr('pending_balance', fallback: "Pending Balance"),
                        _isBalanceHidden ? r'$••••••' : widget.pendingBalance,
                        titleTextColor,
                        labelTextColor,
                      ),
                      _buildRewardPointsColumn(
                        context.tr('reward_points', fallback: "Reward Points"),
                        widget.rewardPoints,
                        titleTextColor,
                        labelTextColor,
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

  Widget _buildStatColumn(String title, String value, Color titleColor, Color labelColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: labelColor,
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            color: titleColor,
            fontSize: 13.5,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildRewardPointsColumn(String title, String points, Color titleColor, Color labelColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: labelColor,
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 3),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              points,
              style: TextStyle(
                color: titleColor,
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              width: 14,
              height: 14,
              decoration: const BoxDecoration(
                color: Color(0xFF00D084),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.star_rounded,
                color: Colors.white,
                size: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Sine Wave Decorative Painter for the Right Side of the Wallet Card
class _SineWavePainter extends CustomPainter {
  final Color color;

  const _SineWavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    final path1 = Path();
    path1.moveTo(0, size.height * 0.7);
    path1.quadraticBezierTo(
      size.width * 0.25, size.height * 0.35,
      size.width * 0.52, size.height * 0.58,
    );
    path1.quadraticBezierTo(
      size.width * 0.78, size.height * 0.80,
      size.width, size.height * 0.25,
    );
    canvas.drawPath(path1, paint1);

    final paint2 = Paint()
      ..color = color.withOpacity(color.opacity * 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round;

    final path2 = Path();
    path2.moveTo(size.width * 0.15, size.height * 0.85);
    path2.quadraticBezierTo(
      size.width * 0.40, size.height * 0.55,
      size.width * 0.65, size.height * 0.75,
    );
    path2.quadraticBezierTo(
      size.width * 0.85, size.height * 0.95,
      size.width, size.height * 0.55,
    );
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant _SineWavePainter oldDelegate) => oldDelegate.color != color;
}
