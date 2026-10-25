import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

import 'referral_info_sheet.dart';
import 'models/referral_summary.dart';
import 'services/referral_api_service.dart';
import '../authentication/services/authentication_service.dart';
import 'widgets/referral_balance_card.dart';
import 'widgets/referral_stats_card.dart';
import 'widgets/referral_link_card.dart';
import 'widgets/referral_how_it_works.dart';
import 'widgets/referral_progress.dart';
import 'widgets/referral_reward_banner.dart';
import '../../localization/app_localizations.dart';

class ReferralScreen extends StatefulWidget {
  final Future<ReferralSummary> Function()? loadReferralSummary;

  const ReferralScreen({super.key, this.loadReferralSummary});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  bool isLoading = true;
  bool hasError = false;
  bool authenticationExpired = false;
  ReferralSummary? _summary;

  @override
  void initState() {
    super.initState();
    _loadReferralData();
  }

  Future<void> _loadReferralData() async {
    setState(() {
      isLoading = true;
      hasError = false;
      authenticationExpired = false;
    });

    try {
      final summary =
          await (widget.loadReferralSummary ??
              ReferralApiService(
                AuthenticationService(),
              ).getMyReferralSummary)();
      if (!mounted) return;
      setState(() {
        _summary = summary;
        isLoading = false;
      });
    } on AuthenticationExpiredException {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        hasError = true;
        authenticationExpired = true;
      });
    } catch (_) {
      if (!mounted) return;
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
    final summary = _summary;
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
              context.tr('referral_program', fallback: 'Referral Program'),
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
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ReferralBalanceCard(
                              balance: summary!.availableRewardUsd,
                              pending: summary.pendingRewardUsd,
                              held: summary.heldRewardUsd,
                            ),
                            const SizedBox(height: 16),
                            ReferralStatsCard(
                              invited: summary.invitedCount,
                              qualified: summary.qualifiedCount,
                              earned: summary.totalEarnedUsd,
                            ),
                            const SizedBox(height: 16),
                            ReferralLinkCard(
                              code: summary.code,
                              link: summary.link,
                            ),
                            const SizedBox(height: 16),
                            const ReferralHowItWorks(),
                            const SizedBox(height: 16),
                            ReferralProgress(
                              current: summary.qualifiedCount,
                              target: summary.invitedCount,
                            ),
                            const SizedBox(height: 16),
                            _buildRewardHistory(summary, isDark),
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
            authenticationExpired
                ? 'Your session has expired. Please log in again to view referrals.'
                : 'Failed to load referral data. Check your connection and try again.',
            textAlign: TextAlign.center,
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

  Widget _buildRewardHistory(ReferralSummary summary, bool isDark) {
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    final borderColor = isDark ? Colors.grey[800]! : Colors.grey[200]!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reward history',
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (summary.rewardHistory.isEmpty)
            Text(
              'Your referral rewards will appear here.',
              style: TextStyle(color: subTextColor, fontSize: 13),
            )
          else
            ...summary.rewardHistory.map((reward) {
              final statusColor = switch (reward.status) {
                'AVAILABLE' => const Color(0xFF00B94A),
                'PENDING' => Colors.orange,
                'HELD' => Colors.deepOrange,
                _ => subTextColor,
              };
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reward.referredName.isEmpty
                                ? 'Referred friend'
                                : reward.referredName,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            reward.status.toLowerCase().replaceAll('_', ' '),
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '\$${reward.amountUsd.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }),
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
