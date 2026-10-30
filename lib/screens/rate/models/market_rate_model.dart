import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

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

  factory MarketRateModel.fromJson(Map<String, dynamic> json) {
    return MarketRateModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? json['fullName']?.toString() ?? 'Gift Card',
      icon: _iconFromKey(json['iconKey']?.toString() ?? json['name']?.toString() ?? ''),
      country: json['country']?.toString() ?? 'USA',
      flag: json['flag']?.toString() ?? '🇺🇸',
      buyRate: (json['buyRate'] is num) ? (json['buyRate'] as num).toDouble() : 0.0,
      sellRate: (json['sellRate'] is num) ? (json['sellRate'] as num).toDouble() : 0.0,
      change24h: (json['change24h'] is num) ? (json['change24h'] as num).toDouble() : 0.0,
      category: json['category']?.toString() ?? 'Best Sellers',
      volume: (json['volume'] is num) ? (json['volume'] as num).toDouble() : 1.0,
    );
  }

  static IconData _iconFromKey(String key) {
    final lower = key.toLowerCase();
    if (lower.contains('amazon')) return Boxicons.bxl_amazon;
    if (lower.contains('apple') || lower.contains('itunes')) return Boxicons.bxl_apple;
    if (lower.contains('steam')) return Boxicons.bxl_steam;
    if (lower.contains('google') || lower.contains('play')) return Boxicons.bxl_play_store;
    if (lower.contains('playstation') || lower.contains('psn') || lower.contains('sony')) return Boxicons.bx_game;
    if (lower.contains('xbox') || lower.contains('microsoft')) return Boxicons.bxl_windows;
    if (lower.contains('ebay')) return Boxicons.bxl_ebay;
    if (lower.contains('razer')) return Boxicons.bx_game;
    if (lower.contains('nike')) return Boxicons.bx_run;
    if (lower.contains('starbucks')) return Boxicons.bx_coffee;
    if (lower.contains('walmart')) return Boxicons.bx_store;
    if (lower.contains('netflix')) return Boxicons.bx_movie_play;
    if (lower.contains('spotify')) return Boxicons.bxl_spotify;
    if (lower.contains('uber')) return Boxicons.bx_car;
    if (lower.contains('mtn')) return Boxicons.bx_mobile_alt;
    return Boxicons.bx_credit_card_front;
  }
}