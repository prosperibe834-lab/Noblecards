import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

import '../widgets/analytics/analytics_summary_card.dart';
import '../widgets/analytics/analytics_filter_chip.dart';
import '../widgets/analytics/analytics_stat_card.dart';
import '../widgets/analytics/analytics_line_chart.dart';
import '../widgets/analytics/analytics_bar_chart.dart';
import '../widgets/analytics/analytics_donut_chart.dart';
import '../widgets/analytics/analytics_card_performance.dart';
import '../widgets/analytics/analytics_country_list.dart';
import '../widgets/analytics/analytics_health_score.dart';
import '../widgets/analytics/analytics_insight_card.dart';
import '../widgets/analytics/analytics_quick_actions.dart';
import '../widgets/analytics/analytics_loading.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  bool _isLoading = true;
  String _selectedFilter = '30 Days';

  final List<String> _filters = [
    'Today',
    '7 Days',
    '30 Days',
    '90 Days',
    '6 Months',
    '1 Year',
    'Custom Range',
  ];

  @override
  void initState() {
    super.initState();
    _loadAnalyticsData();
  }

  Future<void> _loadAnalyticsData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _onFilterChanged(String filter) {
    if (filter == 'Custom Range') {
      _showCustomRangePicker();
    } else {
      setState(() {
        _selectedFilter = filter;
      });
      _loadAnalyticsData();
    }
  }

  Future<void> _showCustomRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Theme.of(context).cardColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedFilter =
            '${picked.start.day}/${picked.start.month} - ${picked.end.day}/${picked.end.month}';
      });
      _loadAnalyticsData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.m),
          child: IconButton(
            icon: Icon(
              Boxicons.bx_chevron_left,
              size: 28,
              color: isDark ? AppColors.white : AppColors.textPrimary,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          'Analytics',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: isDark ? AppColors.white : AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Boxicons.bx_bell,
              color: isDark ? AppColors.white : AppColors.textPrimary,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: AppSpacing.s),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadAnalyticsData,
        color: AppColors.primary,
        child: _isLoading
            ? const AnalyticsLoadingShimmer()
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.m,
                  vertical: AppSpacing.s,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AnalyticsSummaryCard(
                      balance: 48920.50,
                      profitToday: 1420.00,
                      profitMonth: 12450.80,
                      deposits: 150000.00,
                      withdrawals: 85000.00,
                      cardsBought: 142,
                      cardsSold: 289,
                      successfulTxns: 412,
                      pendingTxns: 3,
                      failedTxns: 1,
                    ),
                    const SizedBox(height: AppSpacing.l),
                    SizedBox(
                      height: 42,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _filters.length,
                        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.s),
                        itemBuilder: (context, index) {
                          final filter = _filters[index];
                          return AnalyticsFilterChip(
                            label: filter,
                            isSelected: _selectedFilter == filter,
                            onTap: () => _onFilterChanged(filter),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppSpacing.l),
                    _buildSectionHeader('Overview Metrics', Boxicons.bx_grid_alt),
                    const SizedBox(height: AppSpacing.m),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 1.4,
                      crossAxisSpacing: AppSpacing.m,
                      mainAxisSpacing: AppSpacing.m,
                      children: const [
                        AnalyticsStatCard(
                          title: 'Income',
                          value: '\$94,320.00',
                          percentage: '+18.4%',
                          isPositive: true,
                          icon: Boxicons.bx_trending_up,
                          accentColor: AppColors.success,
                        ),
                        AnalyticsStatCard(
                          title: 'Expenses',
                          value: '\$45,400.00',
                          percentage: '-4.2%',
                          isPositive: false,
                          icon: Boxicons.bx_trending_down,
                          accentColor: AppColors.error,
                        ),
                        AnalyticsStatCard(
                          title: 'Net Profit',
                          value: '\$48,920.00',
                          percentage: '+24.1%',
                          isPositive: true,
                          icon: Boxicons.bx_dollar_circle,
                          accentColor: AppColors.primary,
                        ),
                        AnalyticsStatCard(
                          title: 'Trading Volume',
                          value: '\$139,720.00',
                          percentage: '+12.5%',
                          isPositive: true,
                          icon: Boxicons.bx_line_chart,
                          accentColor: AppColors.secondary,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    const AnalyticsHealthScoreCard(
                      score: 94,
                      status: 'Excellent',
                      insights: [
                        'High transaction success rate (99.1%)',
                        'Consistent weekly gift card trading volume',
                        'Low failed withdrawal frequency',
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _buildSectionHeader('Income vs Expenses', Boxicons.bx_line_chart),
                    const SizedBox(height: AppSpacing.m),
                    const AnalyticsLineChartCard(),
                    const SizedBox(height: AppSpacing.xl),
                    _buildSectionHeader('Cash Flow Overview', Boxicons.bx_bar_chart_alt_2),
                    const SizedBox(height: AppSpacing.m),
                    const AnalyticsBarChartCard(),
                    const SizedBox(height: AppSpacing.xl),
                    _buildSectionHeader('Gift Card Performance', Boxicons.bx_gift),
                    const SizedBox(height: AppSpacing.m),
                    const AnalyticsCardPerformanceSection(),
                    const SizedBox(height: AppSpacing.xl),
                    _buildSectionHeader('Category Distribution', Boxicons.bx_pie_chart_alt_2),
                    const SizedBox(height: AppSpacing.m),
                    const AnalyticsDonutChartCard(),
                    const SizedBox(height: AppSpacing.xl),
                    _buildSectionHeader('Top Trading Countries', Boxicons.bx_world),
                    const SizedBox(height: AppSpacing.m),
                    const AnalyticsCountryList(),
                    const SizedBox(height: AppSpacing.xl),
                    _buildSectionHeader('Smart Insights', Boxicons.bx_bulb),
                    const SizedBox(height: AppSpacing.m),
                    const AnalyticsInsightSection(),
                    const SizedBox(height: AppSpacing.xl),
                    _buildSectionHeader('Quick Actions', Boxicons.bx_rocket),
                    const SizedBox(height: AppSpacing.m),
                    const AnalyticsQuickActions(),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppSpacing.s),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: AppSpacing.s),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.white : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}