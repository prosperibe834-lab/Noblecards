import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

import 'models/analytics_model.dart';
import 'services/analytics_service.dart';
import 'widgets/analytics_header.dart';
import 'widgets/analytics_period_selector.dart';
import 'widgets/analytics_balance_card.dart';
import 'widgets/analytics_overview_grid.dart';
import 'widgets/analytics_spending_chart.dart';
import 'widgets/analytics_recent_activity.dart';
import 'widgets/analytics_filter_sheet.dart';
import 'widgets/analytics_shimmer.dart';
import 'widgets/analytics_empty_state.dart';
import 'widgets/analytics_error_state.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AnalyticsService _service = AnalyticsService();

  AnalyticsData? _data;
  bool _isLoading = true;
  bool _hasError = false;
  bool _isBalanceVisible = true;

  String _selectedPeriod = '7D';
  DateTimeRange? _customRange;

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final res = await _service.fetchAnalyticsData(
        period: _selectedPeriod,
        customRange: _customRange,
      );
      setState(() {
        _data = res;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  void _onPeriodChanged(String newPeriod) {
    if (_selectedPeriod == newPeriod && _customRange == null) return;
    setState(() {
      _selectedPeriod = newPeriod;
      _customRange = null;
    });
    _loadAnalytics();
  }

  void _openCalendarFilter() {
    AnalyticsFilterSheet.show(context, (range) {
      setState(() {
        _customRange = range;
      });
      _loadAnalytics();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : AppColors.lightBackground;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // Fixed Header (Does not scroll out of view)
          AnalyticsHeader(onCalendarTap: _openCalendarFilter),
          // Scrollable Body Content
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadAnalytics,
              color: AppColors.primary,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                      child: Column(
                        children: [
                          AnalyticsPeriodSelector(
                            selectedPeriod: _selectedPeriod,
                            onPeriodSelected: _onPeriodChanged,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          if (_isLoading)
                            const AnalyticsShimmer()
                          else if (_hasError)
                            AnalyticsErrorState(onRetry: _loadAnalytics)
                          else if (_data == null)
                            AnalyticsEmptyState(onReset: () => _onPeriodChanged('7D'))
                          else ...[
                            AnalyticsBalanceCard(
                              balance: _data!.totalBalance,
                              changePercent: _data!.balanceChangePercent,
                              periodLabel: _data!.comparisonPeriodLabel,
                              isVisible: _isBalanceVisible,
                              onToggleVisibility: () => setState(() => _isBalanceVisible = !_isBalanceVisible),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            AnalyticsOverviewGrid(
                              totalDeposits: _data!.totalDeposits,
                              depositsChange: _data!.depositsChangePercent,
                              totalWithdrawals: _data!.totalWithdrawals,
                              withdrawalsChange: _data!.withdrawalsChangePercent,
                              giftCardsBought: _data!.giftCardsBought,
                              boughtChange: _data!.boughtChangePercent,
                              giftCardsSold: _data!.giftCardsSold,
                              soldChange: _data!.soldChangePercent,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            AnalyticsSpendingChart(points: _data!.chartPoints),
                            const SizedBox(height: AppSpacing.lg),
                            AnalyticsRecentActivity(
                              activities: _data!.recentActivities,
                              onViewAll: () {},
                            ),
                          ],
                          const SizedBox(height: AppSpacing.xxl),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}