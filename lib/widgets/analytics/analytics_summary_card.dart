import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

class AnalyticsSummaryCard extends StatefulWidget {
  final double balance;
  final double profitToday;
  final double profitMonth;
  final double deposits;
  final double withdrawals;
  final int cardsBought;
  final int cardsSold;
  final int successfulTxns;
  final int pendingTxns;
  final int failedTxns;

  const AnalyticsSummaryCard({
    Key? key,
    required this.balance,
    required this.profitToday,
    required this.profitMonth,
    required this.deposits,
    required this.withdrawals,
    required this.cardsBought,
    required this.cardsSold,
    required this.successfulTxns,
    required this.pendingTxns,
    required this.failedTxns,
  }) : super(key: key);

  @override
  State<AnalyticsSummaryCard> createState() => _AnalyticsSummaryCardState();
}

class _AnalyticsSummaryCardState extends State<AnalyticsSummaryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animBalance;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _animBalance = Tween<double>(begin: 0, end: widget.balance).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutQuint),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
            AppColors.accentViolet,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Wallet Balance',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Boxicons.bx_shield_quarter, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Live Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          AnimatedBuilder(
            animation: _animBalance,
            builder: (context, _) {
              return Text(
                '\$${_animBalance.value.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.m),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: AppSpacing.m),

          // Secondary metrics row 1
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricTile("Today's Profit", '+\$${widget.profitToday.toStringAsFixed(2)}', AppColors.successLight),
              _buildMetricTile('This Month', '+\$${widget.profitMonth.toStringAsFixed(2)}', AppColors.successLight),
              _buildMetricTile('Deposits', '\$${(widget.deposits / 1000).toStringAsFixed(0)}k', Colors.white),
              _buildMetricTile('Withdrawals', '\$${(widget.withdrawals / 1000).toStringAsFixed(0)}k', Colors.white70),
            ],
          ),
          const SizedBox(height: AppSpacing.m),

          // Cards bought/sold & Txn stats
          Container(
            padding: const EdgeInsets.all(AppSpacing.s),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.18),
              borderRadius: BorderRadius.circular(AppSpacing.m),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSubStat(Boxicons.bx_cart, '${widget.cardsBought}', 'Bought'),
                _buildSubStat(Boxicons.bx_dollar_circle, '${widget.cardsSold}', 'Sold'),
                _buildSubStat(Boxicons.bx_check_circle, '${widget.successfulTxns}', 'Success'),
                _buildSubStat(Boxicons.bx_time_five, '${widget.pendingTxns}', 'Pending'),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMetricTile(String title, String val, Color valColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white60, fontSize: 11),
        ),
        const SizedBox(height: 2),
        Text(
          val,
          style: TextStyle(
            color: valColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSubStat(IconData icon, String count, String label) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              count,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.white54, fontSize: 9),
            ),
          ],
        )
      ],
    );
  }
}