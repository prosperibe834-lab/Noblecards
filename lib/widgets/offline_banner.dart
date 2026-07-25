import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class OfflineBanner extends StatelessWidget {
  final bool isOffline;

  const OfflineBanner({super.key, required this.isOffline});

  @override
  Widget build(BuildContext context) {
    if (!isOffline) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.amber[800],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Boxicons.bx_wifi_off, color: Colors.white, size: 16),
          SizedBox(width: 8),
          Text(
            "No connection. Displaying cached data.",
            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}