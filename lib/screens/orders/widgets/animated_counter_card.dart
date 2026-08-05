import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';

class AnimatedCounterCard extends StatefulWidget {
  final String label;
  final int targetCount;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;

  const AnimatedCounterCard({
    super.key,
    required this.label,
    required this.targetCount,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });

  @override
  State<AnimatedCounterCard> createState() => _AnimatedCounterCardState();
}

class _AnimatedCounterCardState extends State<AnimatedCounterCard> {
  int _startCount = 0;

  @override
  void initState() {
    super.initState();
    // Start count from 0 and animate up to targetCount when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _startCount = widget.targetCount;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant AnimatedCounterCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the order data changes, update the animation target
    if (oldWidget.targetCount != widget.targetCount) {
      setState(() {
        _startCount = widget.targetCount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.black.withOpacity(0.04),
          ),
        ),
        // Changed Row to Column to match the vertical layout in your design
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: widget.iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(widget.icon, color: widget.iconColor, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              widget.label,
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
              ),
            ),
            const SizedBox(height: 4),
            // The counter animation logic
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: _startCount.toDouble()),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}