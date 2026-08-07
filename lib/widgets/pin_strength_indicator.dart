import 'package:flutter/material.dart';

class PinStrengthIndicator extends StatelessWidget {
  final String pin;

  const PinStrengthIndicator({super.key, required this.pin});

  String _getStrengthLabel() {
    if (pin.length < 4) return "Too weak";
    if (RegExp(r'^(.)\1{3}$').hasMatch(pin)) return "Weak"; // e.g. 1111
    if ("0123456789".contains(pin) || "9876543210".contains(pin)) return "Fair"; // e.g. 1234
    return "Strong";
  }

  Color _getStrengthColor() {
    final label = _getStrengthLabel();
    switch (label) {
      case "Too weak":
      case "Weak":
        return Colors.red;
      case "Fair":
        return Colors.orange;
      case "Strong":
        return const Color(0xFF00C853);
      default:
        return Colors.grey;
    }
  }

  int _getActiveBars() {
    if (pin.isEmpty) return 0;
    if (pin.length < 4) return pin.length;
    final label = _getStrengthLabel();
    if (label == "Weak") return 2;
    if (label == "Fair") return 4;
    return 6;
  }

  @override
  Widget build(BuildContext context) {
    final activeBars = _getActiveBars();
    final color = _getStrengthColor();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "PIN Strength",
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
                fontSize: 13,
              ),
            ),
            Text(
              pin.isEmpty ? "" : _getStrengthLabel(),
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(6, (index) {
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.only(right: index == 5 ? 0 : 6),
                height: 4,
                decoration: BoxDecoration(
                  color: index < activeBars
                      ? color
                      : (isDark ? Colors.white10 : Colors.black12),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}