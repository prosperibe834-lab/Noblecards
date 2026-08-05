import 'package:flutter/material.dart';

enum TransactionType { buy, sell }

enum OrderStatus { completed, pending, processing, cancelled, failed }

class OrderModel {
  final String referenceId;
  final String orderId;
  final TransactionType transactionType;
  final OrderStatus status;
  final String giftCardName;
  final String brandLogo;
  final IconData? brandIcon;
  final double amount;
  final String currency;
  final String region;
  final String date;
  final int quantity;
  final String paymentMethod;

  const OrderModel({
    required this.referenceId,
    required this.orderId,
    required this.transactionType,
    required this.status,
    required this.giftCardName,
    required this.brandLogo,
    this.brandIcon,
    required this.amount,
    this.currency = '\$',
    required this.region,
    required this.date,
    this.quantity = 1,
    required this.paymentMethod,
  });

  static List<OrderModel> get sampleOrders => [
        const OrderModel(
          referenceId: 'NC-2026-54231',
          orderId: 'NC-2026-78391',
          transactionType: TransactionType.buy,
          status: OrderStatus.completed,
          giftCardName: 'Amazon Gift Card',
          brandLogo: 'amazon',
          amount: 100.00,
          region: 'United States 🇺🇸',
          date: '29 Jul 2026, 10:42 AM',
          paymentMethod: 'USD Wallet',
        ),
        const OrderModel(
          referenceId: 'NC-2026-54232',
          orderId: 'NC-2026-78390',
          transactionType: TransactionType.sell,
          status: OrderStatus.pending,
          giftCardName: 'Apple Gift Card',
          brandLogo: 'apple',
          amount: 85.00,
          region: 'United States 🇺🇸',
          date: '29 Jul 2026, 09:15 AM',
          paymentMethod: 'NGN Wallet',
        ),
        const OrderModel(
          referenceId: 'NC-2026-54233',
          orderId: 'NC-2026-78389',
          transactionType: TransactionType.buy,
          status: OrderStatus.completed,
          giftCardName: 'Steam Gift Card',
          brandLogo: 'steam',
          amount: 50.00,
          region: 'United States 🇺🇸',
          date: '28 Jul 2026, 08:45 PM',
          paymentMethod: 'USD Wallet',
        ),
        const OrderModel(
          referenceId: 'NC-2026-54234',
          orderId: 'NC-2026-78388',
          transactionType: TransactionType.sell,
          status: OrderStatus.pending,
          giftCardName: 'Netflix Gift Card',
          brandLogo: 'netflix',
          amount: 30.00,
          region: 'United States 🇺🇸',
          date: '28 Jul 2026, 06:30 PM',
          paymentMethod: 'NGN Wallet',
        ),
        const OrderModel(
          referenceId: 'NC-2026-54235',
          orderId: 'NC-2026-78387',
          transactionType: TransactionType.buy,
          status: OrderStatus.cancelled,
          giftCardName: 'Google Play Gift Card',
          brandLogo: 'google_play',
          amount: 25.00,
          region: 'United States 🇺🇸',
          date: '28 Jul 2026, 03:20 PM',
          paymentMethod: 'USD Wallet',
        ),
      ];
}