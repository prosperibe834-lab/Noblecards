import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../localization/app_localizations.dart';

class HomeGreeting extends StatelessWidget {
  final String userName;
  final String? avatarUrl;

  const HomeGreeting({
    super.key,
    this.userName = 'firminofx1',
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subTextColor = isDark ? const Color(0xFF8B9FA8) : const Color(0xFF64748B);

    return Row(
      children: [
        // Avatar with subtle ring
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF00D084).withValues(alpha: 0.35),
              width: 1.8,
            ),
          ),
          child: ClipOval(
            child: (avatarUrl != null && avatarUrl!.trim().isNotEmpty)
                ? Image.network(
                    avatarUrl!.trim(),
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _buildDefaultAvatar(isDark),
                  )
                : _buildDefaultAvatar(isDark),
          ),
        ),
        const SizedBox(width: 12),

        // User Welcome Column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      "${context.tr('hello', fallback: 'Hello')}, $userName",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text("👋", style: TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                context.tr('welcome_back', fallback: "Welcome back to NobleCards"),
                style: TextStyle(
                  color: subTextColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultAvatar(bool isDark) {
    return Container(
      color: isDark ? const Color(0xFF1E2D38) : const Color(0xFFE2E8F0),
      alignment: Alignment.center,
      child: Icon(
        Boxicons.bx_user,
        color: isDark ? Colors.white70 : const Color(0xFF475569),
        size: 22,
      ),
    );
  }
}
