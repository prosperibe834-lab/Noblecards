import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'package:flutter/services.dart';

import 'referral_info_sheet.dart';
import 'widgets/referral_balance_card.dart';
import 'widgets/referral_stats_card.dart';
import 'widgets/referral_link_card.dart';
import 'widgets/referral_how_it_works.dart';
import 'widgets/referral_progress.dart';
import 'widgets/referral_reward_banner.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({Key? key}) : super(key: key);

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  bool isLoading = true;
  bool hasError = false;

  // Mock State Data (Ready to be replaced by your backend models)
  String referralCode = 'PROSPERIBE';
  String referralLink = 'noblecards.com/ref/PROSPERIBE';
  double totalCredit = 24.75;
  int friendsInvited = 18;
  int qualifiedFriends = 7;
  int qualifiedTarget = 5;

  @override
  void initState() {
    super.initState();
    _loadReferralData();
  }

  Future<void> _loadReferralData() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      // Simulating network delay
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  void _showInfoSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ReferralInfoSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Boxicons.bx_chevron_left, color: textColor, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              'Referral Program',
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 12,
                ),
                children: const [
                  TextSpan(text: 'Invite friends. '),
                  TextSpan(
                    text: 'Earn rewards. ',
                    style: TextStyle(
                      color: Color(0xFF00B94A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(text: 'Grow together.'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Boxicons.bx_info_circle, color: textColor),
            onPressed: _showInfoSheet,
          ),
        ],
      ),
      body: SafeArea(
        child: hasError
            ? _buildErrorState(textColor)
            : RefreshIndicator(
                color: const Color(0xFF00B94A),
                onRefresh: _loadReferralData,
                child: isLoading
                    ? _buildShimmerLoading(isDark)
                    : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ReferralBalanceCard(balance: totalCredit),
                            const SizedBox(height: 16),
                            ReferralStatsCard(
                              invited: friendsInvited,
                              qualified: qualifiedFriends,
                              earned: totalCredit,
                            ),
                            const SizedBox(height: 16),
                            ReferralLinkCard(link: referralLink),
                            const SizedBox(height: 16),
                            const ReferralHowItWorks(),
                            const SizedBox(height: 16),
                            ReferralProgress(
                              current: qualifiedFriends,
                              target: qualifiedTarget,
                            ),
                            const SizedBox(height: 16),
                            const ReferralRewardBanner(),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
              ),
      ),
    );
  }

  Widget _buildErrorState(Color textColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Boxicons.bx_error_circle, color: Colors.red[400], size: 64),
          const SizedBox(height: 16),
          Text(
            'Failed to load referral data',
            style: TextStyle(color: textColor, fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00B94A),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: _loadReferralData,
            icon: const Icon(Boxicons.bx_refresh),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading(bool isDark) {
    final baseColor = isDark ? Colors.grey[850]! : Colors.grey[300]!;
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          height: index == 0 ? 160 : 100,
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }
}