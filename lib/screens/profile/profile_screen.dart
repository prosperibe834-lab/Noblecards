import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_shadow.dart';
import '../../../theme/app_text_styles.dart';
import 'widgets/profile_header.dart';
import 'widgets/account_level_card.dart';
import 'widgets/quick_stats_section.dart';
import 'widgets/profile_section.dart';
import 'biometric_login_screen.dart';
import 'services/biometric_service.dart';
import 'package:provider/provider.dart';
import 'appearance/appearance_screen.dart';
import 'help_center_screen.dart';
import './livechat/live_chat_screen.dart';
import 'security_pin/change_transaction_pin_screen.dart';
import 'language/language_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Profile',
          style: AppTextStyles.h2.copyWith(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Boxicons.bx_qr_scan, color: isDark ? Colors.white : Colors.black),
            onPressed: () {
              // TODO: Open QR Code BottomSheet
            },
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(Boxicons.bx_bell, color: isDark ? Colors.white : Colors.black),
                onPressed: () {
                  // TODO: Open Notifications
                },
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const ProfileHeader(),
                const SizedBox(height: 16),
                const AccountLevelCard(),
                const SizedBox(height: 16),
                const QuickStatsSection(),
                const SizedBox(height: 24),

                // MY ACCOUNT
                ProfileSection(
                  title: 'My Account',
                  children: [
                    ProfileTile(
                      icon: Boxicons.bx_user,
                      title: 'Personal Information',
                      onTap: () {},
                    ),
                   ProfileTile(
  icon: Boxicons.bx_check_shield,
  title: 'Security & PIN',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChangeTransactionPinScreen(),
      ),
    );
  },
),
                    ProfileTile(
                      icon: Boxicons.bxs_bank,
                      title: 'Bank Accounts',
                      onTap: () {},
                    ),
                    ProfileTile(
                      icon: Boxicons.bx_credit_card,
                      title: 'Payment Methods',
                      onTap: () {},
                    ),
                      ProfileTile(
                        icon: Boxicons.bx_fingerprint,
                        title: 'Biometric Login',
                        trailingText: 'Enabled',
                        trailingTextColor: AppColors.success,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangeNotifierProvider(
                                create: (_) => BiometricProvider(),
                                child: const BiometricLoginScreen(),
                              ),
                            ),
                          );
                        },
                      ),
                    ProfileTile(
                      icon: Boxicons.bx_lock_alt,
                      title: 'Change Password',
                      showBorder: false,
                      onTap: () {},
                    ),
                  ],
                ),

                // WALLET
                ProfileSection(
                  title: 'Wallet',
                  children: [
                    ProfileTile(
                      icon: Boxicons.bx_wallet,
                      title: 'USD Wallet',
                      trailingText: '\$2,450.80',
                      trailingTextColor: AppColors.success,
                      onTap: () {},
                    ),
                    ProfileTile(
                      icon: Boxicons.bx_list_ul,
                      title: 'Transaction History',
                      onTap: () {},
                    ),
                    ProfileTile(
                      icon: Boxicons.bx_down_arrow_circle,
                      title: 'Deposit Funds',
                      onTap: () {},
                    ),
                    ProfileTile(
                      icon: Boxicons.bx_up_arrow_circle,
                      title: 'Withdraw Funds',
                      onTap: () {},
                    ),
                    ProfileTile(
                      icon: Boxicons.bx_bookmark,
                      title: 'Saved Withdrawal Accounts',
                      showBorder: false,
                      onTap: () {},
                    ),
                  ],
                ),

                // ORDERS
                ProfileSection(
                  title: 'Orders',
                  children: [
                    ProfileTile(
                      icon: Boxicons.bx_shopping_bag,
                      title: 'My Orders',
                      onTap: () {},
                    ),
                    ProfileTile(
                      icon: Boxicons.bx_time_five,
                      title: 'Pending Orders',
                      onTap: () {},
                    ),
                    ProfileTile(
                      icon: Boxicons.bx_check_circle,
                      title: 'Completed Orders',
                      onTap: () {},
                    ),
                    ProfileTile(
                      icon: Boxicons.bx_x_circle,
                      title: 'Cancelled Orders',
                      showBorder: false,
                      onTap: () {},
                    ),
                  ],
                ),

                // PREFERENCES
                ProfileSection(
                  title: 'Preferences',
                  children: [
                   ProfileTile(
  icon: Boxicons.bx_palette,
  title: 'Appearance',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AppearanceScreen(),
      ),
    );
  },
),
                    ProfileTile(
  icon: Boxicons.bx_globe,
  title: 'Language',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LanguageScreen(), // Replace with your Language Screen widget
      ),
    );
  },
),
                    ProfileTile(
                      icon: Boxicons.bx_money,
                      title: 'Currency',
                      showBorder: false,
                      onTap: () {},
                    ),
                  ],
                ),

                // SUPPORT
                ProfileSection(
                  title: 'Support',
                  children: [
                   ProfileTile(
  icon: Boxicons.bx_help_circle,
  title: 'Help Center',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HelpCenterScreen(),
      ),
    );
  },
),
                    ProfileTile(
  icon: Boxicons.bx_message_dots,
  title: 'Live Chat',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LiveChatScreen(),
      ),
    );
  },
),
                    ProfileTile(
                      icon: Boxicons.bx_error_circle,
                      title: 'Report a Problem',
                      showBorder: false,
                      onTap: () {
                        Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LiveChatScreen(),
      ),
    );
                      },
                    ),
                  ],
                ),

                // REFERRAL PROMO
                const _ReferralPromoCard(),
                const SizedBox(height: 24),

                // DANGER ZONE
                ProfileSection(
                  title: 'Danger Zone',
                  titleColor: AppColors.error,
                  children: [
                    ProfileTile(
                      icon: Boxicons.bx_log_out_circle,
                      title: 'Logout',
                      iconColor: AppColors.error,
                      textColor: AppColors.error,
                      hideChevron: true,
                      onTap: () {},
                    ),
                    ProfileTile(
                      icon: Boxicons.bx_trash,
                      title: 'Delete Account',
                      iconColor: AppColors.error,
                      textColor: AppColors.error,
                      hideChevron: true,
                      showBorder: false,
                      onTap: () {},
                    ),
                  ],
                ),
                
                const SizedBox(height: 40), // Bottom padding
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReferralPromoCard extends StatelessWidget {
  const _ReferralPromoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadow.light,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Boxicons.bxs_gift, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              Text(
                'Invite Friends',
                style: AppTextStyles.h3.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Earn rewards when friends join NobleCards using your link.',
            style: AppTextStyles.bodyText2.copyWith(color: Colors.white.withValues(alpha: 0.9)),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF2575FC),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 0,
            ),
            child: const Text('Invite Friends', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}