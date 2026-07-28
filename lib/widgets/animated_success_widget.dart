import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class AnimatedSuccessWidget extends StatefulWidget {
  final double size;

  const AnimatedSuccessWidget({super.key, this.size = 90});

  @override
  State<AnimatedSuccessWidget> createState() => _AnimatedSuccessWidgetState();
}

class _AnimatedSuccessWidgetState extends State<AnimatedSuccessWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
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
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green.shade500,
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.35),
              blurRadius: 30,
              spreadRadius: 8,
            ),
          ],
        ),
        child: Icon(
          Boxicons.bx_check,
          color: Colors.white,
          size: widget.size * 0.6,
        ),
      ),
    );
  }
}