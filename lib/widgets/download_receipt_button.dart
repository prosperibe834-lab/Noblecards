import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class DownloadReceiptButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DownloadReceiptButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      onPressed: onPressed,
      icon: const Icon(Boxicons.bx_download, size: 20),
      label: const Text('Download PDF', style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}