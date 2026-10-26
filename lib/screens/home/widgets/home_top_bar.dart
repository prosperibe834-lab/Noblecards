import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boxicons/boxicons.dart';
import '../../notification/notification_screen.dart';
import '../../qrScanner/qr_scanner_screen.dart';

class HomeTopBar extends StatelessWidget {
  final VoidCallback? onNotificationTap;
  final VoidCallback? onQrScanTap;

  const HomeTopBar({
    super.key,
    this.onNotificationTap,
    this.onQrScanTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final buttonBg = isDark ? const Color(0xFF141E26) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E2D38) : const Color(0xFFE2E8F0);
    final iconColor = isDark ? Colors.white : const Color(0xFF334155);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left: NobleCards Logo & Brand Name
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Emerald Brand Mark Icon
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00E599), Color(0xFF00B074)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(11),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x3500D084),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Image.asset(
                  'lib/assets/logos/logo_icon.png',
                  width: 22,
                  height: 22,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => const Icon(
                    Boxicons.bx_credit_card_front,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              "NobleCards",
              style: TextStyle(
                color: textColor,
                fontSize: 21,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.6,
              ),
            ),
          ],
        ),

        // Right: Notification Bell & QR Scanner
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Notification Bell with Badge
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                if (onNotificationTap != null) {
                  onNotificationTap!();
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NotificationScreen()),
                  );
                }
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: buttonBg,
                      shape: BoxShape.circle,
                      border: Border.all(color: borderColor, width: 1),
                      boxShadow: [
                        if (!isDark)
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Boxicons.bx_bell,
                        color: iconColor,
                        size: 20,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(4.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? const Color(0xFF0B0F15) : Colors.white,
                          width: 1.5,
                        ),
                      ),
                      child: const Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // QR Scan Icon Button
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                if (onQrScanTap != null) {
                  onQrScanTap!();
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const QrScannerScreen()),
                  );
                }
              },
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: buttonBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor, width: 1),
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Boxicons.bx_qr_scan,
                    color: iconColor,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
