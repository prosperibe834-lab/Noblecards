import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class NetworkStatusBanner extends StatelessWidget {
  final bool isConnected;
  final VoidCallback onRetry;

  const NetworkStatusBanner({
    super.key,
    required this.isConnected,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isConnected) return const SizedBox.shrink();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: Colors.red.shade800,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            const Icon(Boxicons.bx_wifi_off, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                "No Internet Connection",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            GestureDetector(
              onTap: onRetry,
              child: const Text(
                "RETRY",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}