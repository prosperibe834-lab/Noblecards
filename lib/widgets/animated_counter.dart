import 'package:flutter/material.dart';

class AnimatedCounter extends StatelessWidget {
  final double value;
  final String prefix;
  final TextStyle style;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.prefix = '\$',
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutCubic,
      builder: (context, val, child) {
        final formatted = val.toStringAsFixed(2);
        return Text(
          '$prefix$formatted',
          style: style,
        );
      },
    );
  }
}