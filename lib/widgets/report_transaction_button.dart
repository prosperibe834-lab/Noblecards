import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class ReportTransactionButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ReportTransactionButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Boxicons.bx_flag, color: Colors.redAccent, size: 18),
      label: const Text(
        'Report an Issue with this Transaction',
        style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
      ),
    );
  }
}