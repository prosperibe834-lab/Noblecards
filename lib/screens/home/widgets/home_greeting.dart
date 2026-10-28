import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../localization/app_localizations.dart';

class HomeGreeting extends StatelessWidget {
  final String userName;
  final String? avatarUrl;

  const HomeGreeting({
    super.key,
    this.userName = 'Fawaz',
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subTextColor = isDark ? const Color(0xFF8B9FA8) : const Color(0xFF64748B);

    final cleanName = userName.trim().isEmpty ? 'Fawaz' : userName.trim();
    // Ensure display has crown if not already ending with emoji
    final displayName = cleanName.contains('👑') ? cleanName : '$cleanName 👑';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Avatar with Glowing Green Ring + Verified Checkmark Badge
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF00D084),
                  width: 2.0,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x2500D084),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: (avatarUrl != null && avatarUrl!.trim().isNotEmpty)
                    ? Image.network(
                        avatarUrl!.trim(),
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _buildLocalAvatar(isDark),
                      )
                    : _buildLocalAvatar(isDark),
              ),
            ),
            // Green Checkmark Badge at bottom-right corner (4 o'clock)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  color: const Color(0xFF00D084),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? const Color(0xFF0B141A) : Colors.white,
                    width: 1.8,
                  ),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 9.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),

        // User Welcome Column: "Hello," / "Fawaz 👑" / "Welcome back to NobleCards"
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.tr('hello', fallback: 'Hello,'),
                style: TextStyle(
                  color: subTextColor,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                displayName,
                style: TextStyle(
                  color: textColor,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                  height: 1.2,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                context.tr('welcome_back', fallback: "Welcome back to NobleCards"),
                style: TextStyle(
                  color: subTextColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.1,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        // Right: "[✓ Verified]" Pill Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0A2B20) : const Color(0xFFE8F9F1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? const Color(0xFF135A40) : const Color(0xFFA7F3D0),
              width: 1.1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 13,
                height: 13,
                decoration: const BoxDecoration(
                  color: Color(0xFF00D084),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 8.5,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                context.tr('verified', fallback: "Verified"),
                style: TextStyle(
                  color: isDark ? const Color(0xFF00E599) : const Color(0xFF059669),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocalAvatar(bool isDark) {
    return Image.asset(
      'lib/assets/avatars/male.png',
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => Container(
        color: isDark ? const Color(0xFF1E2D38) : const Color(0xFFE2E8F0),
        alignment: Alignment.center,
        child: Icon(
          Boxicons.bx_user,
          color: isDark ? Colors.white70 : const Color(0xFF475569),
          size: 22,
        ),
      ),
    );
  }
}
