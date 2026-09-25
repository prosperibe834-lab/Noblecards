import 'package:flutter/material.dart';

enum TransactionType { deposit, withdrawal }
enum TransactionStatus { completed, pending, processing, failed, cancelled }

class TransactionHistoryModel {
  final String id;
  final TransactionType type;
  final String method;
  final DateTime date;
  final double amount;
  final TransactionStatus status;
  final String currency;

  TransactionHistoryModel({
    required this.id,
    required this.type,
    required this.method,
    required this.date,
    required this.amount,
    required this.status,
    this.currency = 'USD',
  });
}