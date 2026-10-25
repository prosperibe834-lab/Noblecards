import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../authentication/services/authentication_service.dart';
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
import '../../localization/app_localizations.dart';
import '../../providers/language_provider.dart';
import '../notification/notification_screen.dart';
import 'personal_information_screen.dart';
import 'change_password_screen.dart';
import '../qrScanner/qr_scanner_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          context.tr('profile', fallback: 'Profile'),
          style: AppTextStyles.h2.copyWith(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Boxicons.bx_qr_scan,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const QrScannerScreen(),
              );
            },
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Boxicons.bx_bell,
                  color: isDark ? Colors.white : Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationScreen(),
                    ),
                  );
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
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
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
                  title: context.tr('my_account', fallback: 'My Account'),
                  children: [
                    ProfileTile(
                      icon: Boxicons.bx_user,
                      title: context.tr('personal_information', fallback: 'Personal Information'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const PersonalInformationScreen(),
                          ),
                        );
                      },
                    ),
                    ProfileTile(
                      icon: Boxicons.bx_check_shield,
                      title: context.tr('security_pin', fallback: 'Security & PIN'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ChangeTransactionPinScreen(),
                          ),
                        );
                      },
                    ),
                    ProfileTile(
                      icon: Boxicons.bxs_bank,
                      title: context.tr('bank_accounts', fallback: 'Bank Accounts'),
                      onTap: () {},
                    ),
                    ProfileTile(
                      icon: Boxicons.bx_credit_card,
                      title: context.tr('payment_methods', fallback: 'Payment Methods'),
                      onTap: () {},
                    ),
                    ProfileTile(
                      icon: Boxicons.bx_fingerprint,
                      title: context.tr('biometric_login', fallback: 'Biometric Login'),
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
                      title: context.tr('change_password', fallback: 'Change Password'),
                      showBorder: false,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePasswordScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                // WALLET
                ProfileSection(
                  title: context.tr('wallet', fallback: 'Wallet'),
                  children: [
                    ProfileTile(
                      icon: Boxicons.bx_wallet,
                      title: context.tr('usd_wallet', fallback: 'USD Wallet'),
                      trailingText: '\$2,450.80',
                      trailingTextColor: AppColors.success,
                      onTap: () {},
                    ),
                    ProfileTile(
                      icon: Boxicons.bx_list_ul,
                      title: context.tr('transaction_history', fallback: 'Transaction History'),
                      onTap: () {},
                    ),
                    ProfileTile(
                      icon: Boxicons.bx_down_arrow_circle,
                      title: context.tr('deposit_funds', fallback: 'Deposit Funds'),
                      onTap: () {},
                    ),
                    ProfileTile(
                      icon: Boxicons.bx_up_arrow_circle,
                      title: context.tr('withdraw_funds', fallback: 'Withdraw Funds'),
                      onTap: () {},
                    ),
                    ProfileTile(
                      icon: Boxicons.bx_bookmark,
                      title: context.tr('saved_accounts', fallback: 'Saved Withdrawal Accounts'),
                      showBorder: false,
                      onTap: () {},
                    ),
                  ],
                ),

                // ORDERS
                ProfileSection(
                  title: context.tr('orders', fallback: 'Orders'),
                  children: [
                    ProfileTile(
                      icon: Boxicons.bx_shopping_bag,
                      title: context.tr('my_orders', fallback: 'My Orders'),
                      onTap: () {},
                    ),
                    ProfileTile(
                      icon: Boxicons.bx_time_five,
                      title: context.tr('pending_orders', fallback: 'Pending Orders'),
                      onTap: () {},
                    ),
                    ProfileTile(
                      icon: Boxicons.bx_check_circle,
                      title: context.tr('completed_orders', fallback: 'Completed Orders'),
                      onTap: () {},
                    ),
                    ProfileTile(
                      icon: Boxicons.bx_x_circle,
                      title: context.tr('cancelled_orders', fallback: 'Cancelled Orders'),
                      showBorder: false,
                      onTap: () {},
                    ),
                  ],
                ),

                // PREFERENCES
                ProfileSection(
                  title: context.tr('preferences', fallback: 'Preferences'),
                  children: [
                    ProfileTile(
                      icon: Boxicons.bx_palette,
                      title: context.tr('appearance', fallback: 'Appearance'),
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
                      title: context.tr('language', fallback: 'Language'),
                      trailingText: context.watch<LanguageProvider>().currentLanguage.name,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LanguageScreen(),
                          ),
                        );
                      },
                    ),
                    ProfileTile(
                      icon: Boxicons.bx_money,
                      title: context.tr('currency', fallback: 'Currency'),
                      showBorder: false,
                      onTap: () {},
                    ),
                  ],
                ),

                // SUPPORT
                ProfileSection(
                  title: context.tr('support', fallback: 'Support'),
                  children: [
                    ProfileTile(
                      icon: Boxicons.bx_help_circle,
                      title: context.tr('help_center', fallback: 'Help Center'),
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
                      title: context.tr('live_chat', fallback: 'Live Chat'),
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
                      title: context.tr('report_problem', fallback: 'Report a Problem'),
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
                  title: context.tr('danger_zone', fallback: 'Danger Zone'),
                  titleColor: AppColors.error,
                  children: [
                    ProfileTile(
                      icon: Boxicons.bx_log_out_circle,
                      title: context.tr('logout', fallback: 'Log Out'),
                      iconColor: AppColors.error,
                      textColor: AppColors.error,
                      hideChevron: true,
                      onTap: () async {
                        try {
                          await AuthenticationService().signOut();
                          if (context.mounted) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/login',
                              (route) => false,
                            );
                          }
                        } catch (error) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  error.toString().replaceFirst(
                                    'Exception: ',
                                    '',
                                  ),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: AppColors.error,
                              ),
                            );
                          }
                        }
                      },
                    ),
                    ProfileTile(
                      icon: Boxicons.bx_trash,
                      title: context.tr('delete_account', fallback: 'Delete Account'),
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
                context.tr('invite_friends', fallback: 'Invite Friends'),
                style: AppTextStyles.h3.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            context.tr('invite_friends_desc', fallback: 'Earn rewards when friends join NobleCards using your link.'),
            style: AppTextStyles.bodyText2.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF2575FC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 0,
            ),
            child: Text(
              context.tr('invite_friends', fallback: 'Invite Friends'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
