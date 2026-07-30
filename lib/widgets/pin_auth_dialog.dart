import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boxicons/boxicons.dart';

class PinAuthDialog extends StatefulWidget {
  final String title;
  final Function(String pin) onSuccess;

  const PinAuthDialog({
    super.key,
    this.title = "Authorize Transaction",
    required this.onSuccess,
  });

  @override
  State<PinAuthDialog> createState() => _PinAuthDialogState();
}

class _PinAuthDialogState extends State<PinAuthDialog> {
  String _pin = "";

  void _onKeyPress(String val) {
    if (_pin.length < 4) {
      HapticFeedback.lightImpact();
      setState(() => _pin += val);
      if (_pin.length == 4) {
        Future.delayed(const Duration(milliseconds: 200), () {
          widget.onSuccess(_pin);
          if (Navigator.canPop(context)) {
            Navigator.pop(context, true);
          }
        });
      }
    }
  }

  void _onDelete() {
    if (_pin.isNotEmpty) {
      HapticFeedback.lightImpact();
      setState(() => _pin = _pin.substring(0, _pin.length - 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF1E202C) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Boxicons.bx_lock_alt, size: 40, color: Colors.blue),
            const SizedBox(height: 12),
            Text(
              widget.title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Enter your 4-digit security PIN",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: isDark ? Colors.white60 : Colors.black54,
              ),
            ),
            const SizedBox(height: 24),

            // PIN Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final isFilled = index < _pin.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFilled
                        ? Theme.of(context).primaryColor
                        : (isDark ? Colors.white24 : Colors.grey.shade300),
                  ),
                );
              }),
            ),

            const SizedBox(height: 28),

            // Keypad
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.5,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                if (index == 9) {
                  return IconButton(
                    onPressed: () {},
                    icon: const Icon(Boxicons.bx_fingerprint, size: 28),
                  );
                }
                if (index == 10) {
                  return _buildKey("0");
                }
                if (index == 11) {
                  return IconButton(
                    onPressed: _onDelete,
                    icon: const Icon(Boxicons.bx_left_arrow_alt, size: 24),
                  );
                }
                return _buildKey("${index + 1}");
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKey(String value) {
    return InkWell(
      onTap: () => _onKeyPress(value),
      borderRadius: BorderRadius.circular(30),
      child: Center(
        child: Text(
          value,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}