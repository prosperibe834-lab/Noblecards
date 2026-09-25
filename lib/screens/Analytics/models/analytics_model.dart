import 'package:flutter/material.dart';

class ChartDataPoint {
  final String label;
  final double deposits;
  final double withdrawals;
  final double buyCards;
  final double sellCards;

  ChartDataPoint({
    required this.label,
    required this.deposits,
    required this.withdrawals,
    required this.buyCards,
    required this.sellCards,
  });
}

class RecentActivityItem {
  final String id;
  final String title;
  final String subtitle;
  final String dateString;
  final double amount;
  final bool isPositive;
  final String status;
  final String category; // 'deposit', 'withdrawal', 'buy', 'sell'

  RecentActivityItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.dateString,
    required this.amount,
    required this.isPositive,
    required this.status,
    required this.category,
  });
}

class AnalyticsData {
  final double totalBalance;
  final double balanceChangePercent;
  final String comparisonPeriodLabel;
  final double totalDeposits;
  final double depositsChangePercent;
  final double totalWithdrawals;
  final double withdrawalsChangePercent;
  final double giftCardsBought;
  final double boughtChangePercent;
  final double giftCardsSold;
  final double soldChangePercent;
  final List<ChartDataPoint> chartPoints;
  final List<RecentActivityItem> recentActivities;

  AnalyticsData({
    required this.totalBalance,
    required this.balanceChangePercent,
    required this.comparisonPeriodLabel,
    required this.totalDeposits,
    required this.depositsChangePercent,
    required this.totalWithdrawals,
    required this.withdrawalsChangePercent,
    required this.giftCardsBought,
    required this.boughtChangePercent,
    required this.giftCardsSold,
    required this.soldChangePercent,
    required this.chartPoints,
    required this.recentActivities,
  });
}