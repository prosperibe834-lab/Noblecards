import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';

class QuickStatsSection extends StatelessWidget {
  const QuickStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _StatCard(
          label: 'Total Transactions',
          targetCount: 128,
          icon: Boxicons.bx_transfer_alt,
          baseColor: AppColors.success,
        ),
        const SizedBox(width: 8),
        _StatCard(
          label: 'Gift Cards Bought',
          targetCount: 67,
          icon: Boxicons.bx_shopping_bag,
          baseColor: Colors.orange,
        ),
        const SizedBox(width: 8),
        _StatCard(
          label: 'Gift Cards Sold',
          targetCount: 61,
          icon: Boxicons.bx_money,
          baseColor: Colors.teal,
        ),
        const SizedBox(width: 8),
        _StatCard(
          label: 'Wallet Balance',
          targetDouble: 2450.80,
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
    _targetValue = widget.isCurrency ? widget.targetDouble! : widget.targetCount!.toDouble();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _startValue = _targetValue;
        });
      }
    });
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
          border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.04)),
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
                    color: widget.baseColor, // Text color matches icon color as per design
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
            )
          ],
        ),
      ),
    );
  }
}