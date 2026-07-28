import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class ShareReceiptButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ShareReceiptButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      onPressed: onPressed,
      icon: const Icon(Boxicons.bx_share_alt, size: 20),
      label: const Text('Share', style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}