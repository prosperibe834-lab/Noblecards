// Location: lib/deposit/widgets/recent_deposits_section.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../../theme/app_colors.dart';
import '../../../theme/theme_provider.dart';
import '../../../models/deposit_model.dart';
import '../../../services/deposits_service.dart';
import '../../authentication/services/authentication_service.dart';

class RecentDepositsSection extends StatefulWidget {
  const RecentDepositsSection({super.key});

  @override
  State<RecentDepositsSection> createState() => _RecentDepositsSectionState();
}

class _RecentDepositsSectionState extends State<RecentDepositsSection> {
  String _authToken = '';
  List<Deposit> _recentDeposits = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecentDeposits();
  }

  Future<void> _loadRecentDeposits() async {
    try {
      final token = await AuthenticationService().getAccessToken();
      _authToken = token ?? '';
      final depositsService = DepositsService(
        httpClient: http.Client(),
        getAuthToken: () => _authToken,
      );
      final list = await depositsService.listDeposits();
      if (mounted) {
        setState(() {
          _recentDeposits = list.take(2).toList();
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Deposits',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
            GestureDetector(
              onTap: () {
                // Navigate to Transaction History
                Navigator.pushNamed(context, '/transaction-history');
              },
              child: const Text(
                'View All',
                style: TextStyle(
                  color: Color(0xFF10B981),
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF13222E) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? const Color(0xFF263545) : const Color(0xFFE2E8F0),
              width: 1,
            ),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  ],
          ),
          child: Column(
            children: [
              _buildTransactionRow(
                context: context,
                icon: Icons.account_balance,
                title: 'Bank Transfer',
                time: 'Completed • 2 hours ago',
                amount: '+ ₦100,000',
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: isDark ? const Color(0xFF263545) : const Color(0xFFF1F5F9),
              ),
              _buildTransactionRow(
                context: context,
                icon: Icons.credit_card,
                title: 'Card Payment',
                time: 'Completed • 1 day ago',
                amount: '+ \$50',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionRow({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String time,
    required String amount,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Solid emerald circle badge with white icon
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFF10B981),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  time,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(width: 6),
          Icon(
            Icons.chevron_right,
            size: 16,
            color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
          ),
        ],
      ),
    );
  }
}
