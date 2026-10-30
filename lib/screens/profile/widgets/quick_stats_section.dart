import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../localization/app_localizations.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../authentication/services/authentication_service.dart';

class QuickStatsSection extends StatefulWidget {
  const QuickStatsSection({super.key});

  @override
  State<QuickStatsSection> createState() => _QuickStatsSectionState();
}

class _QuickStatsSectionState extends State<QuickStatsSection> {
  int _totalTransactions = 128;
  int _cardsBought = 67;
  int _cardsSold = 61;
  double _walletBalance = 2450.80;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    try {
      final data = await AuthenticationService().authenticatedGet('/users/me/profile-stats');
      if (mounted) {
        setState(() {
          _totalTransactions = (data['totalTransactions'] as num?)?.toInt() ?? _totalTransactions;
          _cardsBought = (data['giftCardsBought'] as num?)?.toInt() ?? _cardsBought;
          _cardsSold = (data['giftCardsSold'] as num?)?.toInt() ?? _cardsSold;
          _walletBalance = (data['walletBalance'] as num?)?.toDouble() ?? _walletBalance;
        });
      }
    } catch (_) {
      // Keep initial/fallback stats if offline or unauthenticated
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _StatCard(
          label: context.tr('total_transactions'),
          targetCount: _totalTransactions,
          icon: Boxicons.bx_transfer_alt,
          baseColor: AppColors.success,
        ),
        const SizedBox(width: 8),
        _StatCard(
          label: context.tr('cards_bought'),
          targetCount: _cardsBought,
          icon: Boxicons.bx_shopping_bag,
          baseColor: Colors.orange,
        ),
        const SizedBox(width: 8),
        _StatCard(
          label: context.tr('cards_sold'),
          targetCount: _cardsSold,
          icon: Boxicons.bx_money,
          baseColor: Colors.teal,
        ),
        const SizedBox(width: 8),
        _StatCard(
          label: context.tr('wallet_balance'),
          targetDouble: _walletBalance,
          isCurrency: true,
          icon: Boxicons.bx_wallet,
          baseColor: Colors.deepPurpleAccent,
        ),
      ],
    );
  }
}

class _StatCard extends StatefulWidget {
  final String label;
  final int? targetCount;
  final double? targetDouble;
  final bool isCurrency;
  final IconData icon;
  final Color baseColor;

  const _StatCard({
    required this.label,
    this.targetCount,
    this.targetDouble,
    this.isCurrency = false,
    required this.icon,
    required this.baseColor,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  double _startValue = 0;
  late double _targetValue;

  @override
  void initState() {
    super.initState();
    _targetValue = widget.isCurrency
        ? (widget.targetDouble ?? 0.0)
        : (widget.targetCount ?? 0).toDouble();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _startValue = _targetValue;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant _StatCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newTarget = widget.isCurrency
        ? (widget.targetDouble ?? 0.0)
        : (widget.targetCount ?? 0).toDouble();
    if (newTarget != _targetValue) {
      setState(() {
        _targetValue = newTarget;
        _startValue = newTarget;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.black.withOpacity(0.04),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: widget.baseColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(widget.icon, color: widget.baseColor, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              widget.label,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                height: 1.1,
                color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: _startValue),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                String displayValue = widget.isCurrency
                    ? '\$${value.toStringAsFixed(2)}'
                    : value.toInt().toString();
                return Text(
                  displayValue,
                  style: TextStyle(
                    fontSize: widget.isCurrency ? 14 : 18,
                    fontWeight: FontWeight.bold,
                    color: widget
                        .baseColor, // Text color matches icon color as per design
                  ),
                );
              },
            ),
            const SizedBox(height: 6),
            Container(
              width: 16,
              height: 3,
              decoration: BoxDecoration(
                color: widget.baseColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
