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

  factory ChartDataPoint.fromJson(Map<String, dynamic> json) => ChartDataPoint(
    label: json['label']?.toString() ?? '',
    deposits: (json['deposits'] as num?)?.toDouble() ?? 0.0,
    withdrawals: (json['withdrawals'] as num?)?.toDouble() ?? 0.0,
    buyCards: (json['buyCards'] as num?)?.toDouble() ?? 0.0,
    sellCards: (json['sellCards'] as num?)?.toDouble() ?? 0.0,
  );
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

  factory RecentActivityItem.fromJson(Map<String, dynamic> json) => RecentActivityItem(
    id: json['id']?.toString() ?? '',
    title: json['title']?.toString() ?? '',
    subtitle: json['subtitle']?.toString() ?? '',
    dateString: json['dateString']?.toString() ?? '',
    amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    isPositive: json['isPositive'] == true,
    status: json['status']?.toString() ?? 'Completed',
    category: json['category']?.toString() ?? 'deposit',
  );
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

  factory AnalyticsData.fromJson(Map<String, dynamic> json) {
    final rawChart = json['chartPoints'] as List? ?? [];
    final rawActivities = json['recentActivities'] as List? ?? [];

    return AnalyticsData(
      totalBalance: (json['totalBalance'] as num?)?.toDouble() ?? 0.0,
      balanceChangePercent: (json['balanceChangePercent'] as num?)?.toDouble() ?? 0.0,
      comparisonPeriodLabel: json['comparisonPeriodLabel']?.toString() ?? '',
      totalDeposits: (json['totalDeposits'] as num?)?.toDouble() ?? 0.0,
      depositsChangePercent: (json['depositsChangePercent'] as num?)?.toDouble() ?? 0.0,
      totalWithdrawals: (json['totalWithdrawals'] as num?)?.toDouble() ?? 0.0,
      withdrawalsChangePercent: (json['withdrawalsChangePercent'] as num?)?.toDouble() ?? 0.0,
      giftCardsBought: (json['giftCardsBought'] as num?)?.toDouble() ?? 0.0,
      boughtChangePercent: (json['boughtChangePercent'] as num?)?.toDouble() ?? 0.0,
      giftCardsSold: (json['giftCardsSold'] as num?)?.toDouble() ?? 0.0,
      soldChangePercent: (json['soldChangePercent'] as num?)?.toDouble() ?? 0.0,
      chartPoints: rawChart
          .whereType<Map<String, dynamic>>()
          .map((e) => ChartDataPoint.fromJson(e))
          .toList(),
      recentActivities: rawActivities
          .whereType<Map<String, dynamic>>()
          .map((e) => RecentActivityItem.fromJson(e))
          .toList(),
    );
  }
}