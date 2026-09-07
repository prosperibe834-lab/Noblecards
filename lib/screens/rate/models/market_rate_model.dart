import 'package:flutter/material.dart';

class MarketRateModel {
  final String id;
  final String name;
  final IconData icon;
  final String country;
  final String flag;
  final double buyRate;
  final double sellRate;
  final double change24h;
  final String category;
  final double volume;

  MarketRateModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.country,
    required this.flag,
    required this.buyRate,
    required this.sellRate,
    required this.change24h,
    required this.category,
    required this.volume,
  });

  bool get isPositive => change24h >= 0;
}