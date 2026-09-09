import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boxicons/boxicons.dart';
import 'package:provider/provider.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import 'package:noble_cards/screens/profile/edit_profile_screen.dart';
import 'package:noble_cards/screens/profile/providers/edit_profile_provider.dart';
import '../../authentication/services/authentication_service.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> with SingleTickerProviderStateMixin {
  late AnimationController _copyAnimController;
  late Animation<double> _copyScaleAnim;
  AuthUser? _user;

  @override
  void initState() {
    super.initState();
    _copyAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _copyScaleAnim = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _copyAnimController, curve: Curves.easeInOut),
    );
    _loadUser();
  }

  Future<void> _loadUser() async {
    final auth = AuthenticationService();
    await auth.getUserProfile('current');
    if (mounted) setState(() => _user = auth.currentUser);
  }

  @override
  void dispose() {
    _copyAnimController.dispose();
    super.dispose();
  }

  void _copyUserId() async {
    _copyAnimController.forward().then((_) => _copyAnimController.reverse());
    await Clipboard.setData(const ClipboardData(text: 'NC-004829'));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('User ID copied to clipboard.', style: TextStyle(color: Colors.white)),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = _user ?? AuthenticationService().currentUser;

    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (_) => EditProfileProvider(),
              child: const EditProfileScreen(),
            ),
          ),
        );
        if (mounted) await _loadUser();
      },
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.04)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            // Profile Image
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? AppColors.darkBackground : Colors.grey[200],
                image: DecorationImage(
                  image: user?.profileImageUrl != null ? NetworkImage(user!.profileImageUrl!.startsWith('/') ? '${AuthenticationService.apiBaseUrl}${user.profileImageUrl}' : user.profileImageUrl!) : const NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80'),
                  fit: BoxFit.cover,
                ),
                border: Border.all(
                  color: isDark ? Colors.white10 : Colors.grey.shade300,
                  width: 2,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Info Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        user?.displayName ?? '${user?.firstName ?? ''} ${user?.lastName ?? ''}'.trim(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (user?.isVerified == true) const Icon(Boxicons.bxs_check_circle, color: AppColors.success, size: 18),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (user?.isVerified == true) const Icon(Boxicons.bx_check_shield, color: AppColors.success, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        user?.isVerified == true ? 'Noble Verified' : 'Profile incomplete',
                        style: TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Member since July 2026',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: _copyUserId,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'User ID: NC-004829',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 6),
                        ScaleTransition(
                          scale: _copyScaleAnim,
                          child: Icon(
                            Boxicons.bx_copy,
                            size: 14,
                            color: isDark ? Colors.white54 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Boxicons.bx_chevron_right, color: isDark ? Colors.white54 : Colors.black54),
          ],
        ),
      ),
    );
  }
}