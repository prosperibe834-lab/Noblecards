import 'package:flutter/material.dart';
import '../models/analytics_model.dart';

class AnalyticsService {
  Future<AnalyticsData> fetchAnalyticsData({
    required String period,
    DateTimeRange? customRange,
  }) async {
    // Simulate network response latency
    await Future.delayed(const Duration(milliseconds: 600));

    String periodLabel = 'vs. last 7 days';
    if (period == '30D') periodLabel = 'vs. last 30 days';
    if (period == '3M') periodLabel = 'vs. last 3 months';
    if (period == '6M') periodLabel = 'vs. last 6 months';
    if (period == '1Y') periodLabel = 'vs. last 1 year';
    if (customRange != null) periodLabel = 'in selected range';

    List<ChartDataPoint> chartPoints;

    switch (period) {
      case '30D':
        chartPoints = [
          ChartDataPoint(label: 'Week 1', deposits: 3200, withdrawals: 1200, buyCards: 1800, sellCards: 900),
          ChartDataPoint(label: 'Week 2', deposits: 3800, withdrawals: 1500, buyCards: 2100, sellCards: 1100),
          ChartDataPoint(label: 'Week 3', deposits: 4100, withdrawals: 1600, buyCards: 2300, sellCards: 1300),
          ChartDataPoint(label: 'Week 4', deposits: 4320, withdrawals: 1869, buyCards: 2540, sellCards: 1420),
        ];
        break;
      case '3M':
        chartPoints = [
          ChartDataPoint(label: 'Feb', deposits: 2800, withdrawals: 1100, buyCards: 1500, sellCards: 800),
          ChartDataPoint(label: 'Mar', deposits: 3600, withdrawals: 1400, buyCards: 2000, sellCards: 1100),
          ChartDataPoint(label: 'Apr', deposits: 4320, withdrawals: 1869, buyCards: 2540, sellCards: 1420),
        ];
        break;
      case '6M':
        chartPoints = [
          ChartDataPoint(label: 'Nov', deposits: 2100, withdrawals: 900, buyCards: 1200, sellCards: 600),
          ChartDataPoint(label: 'Dec', deposits: 2500, withdrawals: 1000, buyCards: 1400, sellCards: 750),
          ChartDataPoint(label: 'Jan', deposits: 2900, withdrawals: 1200, buyCards: 1600, sellCards: 850),
          ChartDataPoint(label: 'Feb', deposits: 3400, withdrawals: 1450, buyCards: 1900, sellCards: 1050),
          ChartDataPoint(label: 'Mar', deposits: 3900, withdrawals: 1650, buyCards: 2200, sellCards: 1250),
          ChartDataPoint(label: 'Apr', deposits: 4320, withdrawals: 1869, buyCards: 2540, sellCards: 1420),
        ];
        break;
      case '1Y':
        chartPoints = [
          ChartDataPoint(label: 'Q1 2024', deposits: 8500, withdrawals: 3200, buyCards: 4800, sellCards: 2800),
          ChartDataPoint(label: 'Q2 2024', deposits: 10200, withdrawals: 4100, buyCards: 6100, sellCards: 3400),
          ChartDataPoint(label: 'Q3 2024', deposits: 12400, withdrawals: 5300, buyCards: 7500, sellCards: 4200),
          ChartDataPoint(label: 'Q4 2024', deposits: 14800, withdrawals: 6200, buyCards: 8900, sellCards: 5100),
        ];
        break;
      case '7D':
      default:
        chartPoints = [
          ChartDataPoint(label: 'Apr 22', deposits: 1800, withdrawals: 800, buyCards: 1200, sellCards: 500),
          ChartDataPoint(label: 'Apr 23', deposits: 2800, withdrawals: 1300, buyCards: 1900, sellCards: 900),
          ChartDataPoint(label: 'Apr 24', deposits: 2200, withdrawals: 1000, buyCards: 1500, sellCards: 700),
          ChartDataPoint(label: 'Apr 25', deposits: 3100, withdrawals: 1500, buyCards: 2100, sellCards: 1100),
          ChartDataPoint(label: 'Apr 26', deposits: 2900, withdrawals: 1400, buyCards: 1800, sellCards: 950),
          ChartDataPoint(label: 'Apr 27', deposits: 3800, withdrawals: 1700, buyCards: 2300, sellCards: 1250),
          ChartDataPoint(label: 'Apr 28', deposits: 4320, withdrawals: 1869, buyCards: 2540, sellCards: 1420),
        ];
        break;
    }

    return AnalyticsData(
      totalBalance: 2450.80,
      balanceChangePercent: 12.5,
      comparisonPeriodLabel: periodLabel,
      totalDeposits: 4320.00,
      depositsChangePercent: 18.2,
      totalWithdrawals: 1869.20,
      withdrawalsChangePercent: 8.7,
      giftCardsBought: 2540.00,
      boughtChangePercent: 15.3,
      giftCardsSold: 1420.00,
      soldChangePercent: 11.6,
      chartPoints: chartPoints,
      recentActivities: [
        RecentActivityItem(
          id: '1',
          title: 'Deposit',
          subtitle: 'Bank Transfer • Apr 28, 2025 • 10:24 AM',
          dateString: 'Apr 28, 2025',
          amount: 250.00,
          isPositive: true,
          status: 'Completed',
          category: 'deposit',
        ),
        RecentActivityItem(
          id: '2',
          title: 'Withdrawal',
          subtitle: 'Mobile Money • Apr 27, 2025 • 04:15 PM',
          dateString: 'Apr 27, 2025',
          amount: 100.00,
          isPositive: false,
          status: 'Completed',
          category: 'withdrawal',
        ),
        RecentActivityItem(
          id: '3',
          title: 'Gift Card Purchase',
          subtitle: 'Amazon • Apr 26, 2025 • 11:30 AM',
          dateString: 'Apr 26, 2025',
          amount: 50.00,
          isPositive: false,
          status: 'Completed',
          category: 'buy',
        ),
        RecentActivityItem(
          id: '4',
          title: 'Gift Card Sale',
          subtitle: 'iTunes • Apr 25, 2025 • 09:42 AM',
          dateString: 'Apr 25, 2025',
          amount: 120.00,
          isPositive: true,
          status: 'Completed',
          category: 'sell',
        ),
      ],
    );
  }
}