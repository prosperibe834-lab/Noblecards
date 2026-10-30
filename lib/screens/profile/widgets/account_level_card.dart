import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../localization/app_localizations.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_shadow.dart';
import '../../authentication/services/authentication_service.dart';
import '../account_level_screen.dart';

class AccountLevelCard extends StatefulWidget {
  const AccountLevelCard({super.key});

  @override
  State<AccountLevelCard> createState() => _AccountLevelCardState();
}

class _AccountLevelCardState extends State<AccountLevelCard> {
  String _currentTier = 'Gold';
  double _dailyLimit = 10000;

  @override
  void initState() {
    super.initState();
    _loadTierData();
  }

  Future<void> _loadTierData() async {
    try {
      final res = await AuthenticationService().authenticatedGet('/users/me/account-tier');
      if (mounted) {
        setState(() {
          _currentTier = res['currentTier']?.toString() ?? _currentTier;
          _dailyLimit = (res['dailyLimit'] as num?)?.toDouble() ?? _dailyLimit;
        });
      }
    } catch (_) {
      // Keep initial fallback if offline
    }
  }

  @override
  Widget build(BuildContext context) {
    Color badgeColor = const Color(0xFFFFD700);
    IconData badgeIcon = Boxicons.bxs_medal;

    switch (_currentTier.toLowerCase()) {
      case 'diamond':
        badgeColor = const Color(0xFF00BFFF);
        badgeIcon = Boxicons.bxs_diamond;
        break;
      case 'platinum':
        badgeColor = const Color(0xFFA78BFA);
        badgeIcon = Boxicons.bx_crown;
        break;
      case 'silver':
        badgeColor = const Color(0xFFC0C0C0);
        badgeIcon = Boxicons.bxs_medal;
        break;
      case 'bronze':
        badgeColor = const Color(0xFFCD7F32);
        badgeIcon = Boxicons.bxs_medal;
        break;
      case 'gold':
      default:
        badgeColor = const Color(0xFFFFD700);
        badgeIcon = Boxicons.bxs_medal;
        break;
    }

    final formattedLimit = "\$${_dailyLimit.toInt().toString().replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',')}";

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AccountLevelScreen()),
        ).then((_) => _loadTierData());
      },
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          gradient: const LinearGradient(
            colors: [Color(0xFF0F9B0F), Color(0xFF0A6C0A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: AppShadow.light,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Tier Badge Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    badgeIcon,
                    color: badgeColor,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('account_level'),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _currentTier,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  context.tr('daily_limit'),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  formattedLimit,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      context.tr('view_benefits'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Boxicons.bx_chevron_right,
                      color: Colors.white,
                      size: 14,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
