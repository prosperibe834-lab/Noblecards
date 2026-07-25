import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class WalletCard extends StatelessWidget {
  final bool isBalanceHidden;
  final VoidCallback onToggleBalance;

  const WalletCard({
    super.key,
    required this.isBalanceHidden,
    required this.onToggleBalance,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF0F5132), const Color(0xFF10B981)]
              : [const Color(0xFF10B981), const Color(0xFF059669)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(0.3),
            blurRadius: 18,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Stack(
        children: [
          // Background Card Graphic Overlay (Matching screenshot design)
          Positioned(
            right: -10,
            bottom: -10,
            child: Opacity(
              opacity: 0.15,
              child: Transform.rotate(
                angle: -0.2,
                child: Container(
                  width: 150,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
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
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: onToggleBalance,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              isBalanceHidden ? Boxicons.bx_hide : Boxicons.bx_show,
                              key: ValueKey<bool>(isBalanceHidden),
                              color: Colors.white70,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Boxicons.bx_plus, color: Color(0xFF10B981), size: 20),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                AnimatedCrossFade(
                  firstChild: const Text(
                    "\$250,000.00",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  secondChild: const Text(
                    "\$••••••••",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  crossFadeState: isBalanceHidden
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 200),
                ),
                const SizedBox(height: 6),
                Row(
                  children: const [
                    Icon(Boxicons.bx_up_arrow_alt, color: Colors.greenAccent, size: 16),
                    SizedBox(width: 2),
                    Text(
                      "12.5%",
                      style: TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold),
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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSubBalance("Available Balance", isBalanceHidden ? "\$••••••" : "\$200,000.00"),
                      _buildSubBalance("Pending Balance", isBalanceHidden ? "\$••••••" : "\$25,000.00"),
                      _buildSubBalance("Reward Points", "2,450"),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSubBalance(String label, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10)),
        const SizedBox(height: 3),
        Text(val, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }
}