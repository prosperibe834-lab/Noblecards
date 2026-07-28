import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boxicons/boxicons.dart';

class CopyButton extends StatefulWidget {
  final String textToCopy;
  final String label;

  const CopyButton({
    super.key,
    required this.textToCopy,
    this.label = "Copy",
  });

  @override
  State<CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<CopyButton> {
  bool _copied = false;

  void _handleCopy() async {
    await Clipboard.setData(ClipboardData(text: widget.textToCopy));
    HapticFeedback.mediumImpact();
    setState(() => _copied = true);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      child: Material(
        color: _copied ? Colors.green.withOpacity(0.12) : primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          onTap: _handleCopy,
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _copied ? Boxicons.bx_check : Boxicons.bx_copy,
                  size: 16,
                  color: _copied ? Colors.green : primaryColor,
                ),
                const SizedBox(width: 4),
                Text(
                  _copied ? "Copied!" : widget.label,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _copied ? Colors.green : primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}