import 'dart:async';
import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class CountdownTimerCard extends StatefulWidget {
  final int totalSeconds;
  final String? expiryTime;
  final VoidCallback onExpired;

  const CountdownTimerCard({
    super.key,
    this.totalSeconds = 900, // 15 minutes default
    this.expiryTime,
    required this.onExpired,
  });

  @override
  State<CountdownTimerCard> createState() => _CountdownTimerCardState();
}

class _CountdownTimerCardState extends State<CountdownTimerCard> {
  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = _resolveRemainingSeconds();
    _startTimer();
  }

  int _resolveRemainingSeconds() {
    if (widget.expiryTime != null && widget.expiryTime!.isNotEmpty) {
      try {
        final expiry = DateTime.tryParse(widget.expiryTime!);
        if (expiry != null) {
          final diff = expiry.difference(DateTime.now()).inSeconds;
          if (diff > 0) return diff;
          return 0;
        }
      } catch (_) {}
    }
    return widget.totalSeconds;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        if (mounted) setState(() => _remainingSeconds--);
      } else {
        _timer?.cancel();
        if (mounted) widget.onExpired();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Color _getTimerColor() {
    final ratio = _remainingSeconds / widget.totalSeconds;
    if (ratio > 0.5) return Colors.green;
    if (ratio > 0.2) return Colors.orange;
    return Colors.red;
  }

  String _formatTime(int seconds) {
    final m = (seconds / 60).floor().toString().padLeft(2, '0');
    final s = (seconds % 60).floor().toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final total = widget.expiryTime != null && widget.expiryTime!.isNotEmpty
        ? _resolveRemainingSeconds() == 0
            ? 1
            : _resolveRemainingSeconds()
        : widget.totalSeconds;
    final progress = total <= 0 ? 0.0 : (_remainingSeconds / total).clamp(0.0, 1.0);
    final color = _getTimerColor();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 4,
                  backgroundColor: color.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
                Icon(Boxicons.bx_time_five, color: color, size: 20),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Account Details Expire In",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
                Text(
                  _formatTime(_remainingSeconds),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Boxicons.bx_shield_quarter, size: 22, color: Colors.green),
        ],
      ),
    );
  }
}