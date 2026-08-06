import 'package:flutter/material.dart';
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

class _AnimatedCounterCardState extends State<AnimatedCounterCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = Tween<double>(begin: 0, end: widget.targetCount.toDouble())
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedCounterCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.targetCount != widget.targetCount) {
      _animation = Tween<double>(begin: 0, end: widget.targetCount.toDouble())
          .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Text(
                  _animation.value.toInt().toString(),
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