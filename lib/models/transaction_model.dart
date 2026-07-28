import 'package:flutter/material.dart';

enum TransactionStatus {
  successful,
  pending,
  processing,
  failed,
  cancelled,
  refunded,
  expired,
  reversed,
  underReview,
}

enum TransactionCategory {
  all,
  deposits,
  withdrawals,
  giftCardPurchases,
  giftCardSales,
  refunds,
  rewards,
  bonuses,
  transfers,
  exchange,
  fees,
  adjustments,
  cashback,
}

class TimelineStepModel {
  final String title;
  final String description;
  final DateTime timestamp;
  final bool isCompleted;

  const TimelineStepModel({
    required this.title,
    required this.description,
    required this.timestamp,
    required this.isCompleted,
  });
}

class TransactionModel {
  final String id;
  final String receiptNumber;
  final String referenceNumber;
  final String walletId;
  final String title;
  final TransactionCategory category;
  final String? giftCardName;
  final String? giftCardRegion;
  final String? giftCardCategory;
  final double amount;
  final String currency;
  final double amountSent;
  final String currencySent;
  final double amountReceived;
  final String currencyReceived;
  final String exchangeRate;
  final TransactionStatus status;
  final DateTime date;
  final double fees;
  final double processingFee;
  final double networkFee;
  final double previousBalance;
  final double currentBalance;
  final String? bankName;
  final String? accountNumber;
  final String? accountName;
  final String sender;
  final String receiver;
  final String country;
  final String device;
  final String processingTime;
  final String completedBy;

  const TransactionModel({
    required this.id,
    required this.receiptNumber,
    required this.referenceNumber,
    required this.walletId,
    required this.title,
    required this.category,
    this.giftCardName,
    this.giftCardRegion,
    this.giftCardCategory,
    required this.amount,
    required this.currency,
    required this.amountSent,
    required this.currencySent,
    required this.amountReceived,
    required this.currencyReceived,
    required this.exchangeRate,
    required this.status,
    required this.date,
    required this.fees,
    required this.processingFee,
    required this.networkFee,
    required this.previousBalance,
    required this.currentBalance,
    this.bankName,
    this.accountNumber,
    this.accountName,
    required this.sender,
    required this.receiver,
    required this.country,
    required this.device,
    required this.processingTime,
    required this.completedBy,
  });

  List<TimelineStepModel> get timelineSteps {
    return [
      TimelineStepModel(
        title: 'Transaction Initiated',
        description: 'Payment request received on NobleCards system',
        timestamp: date,
        isCompleted: true,
      ),
      TimelineStepModel(
        title: 'Payment Processing',
        description: 'Verified with banking/crypto provider gateway',
        timestamp: date.add(const Duration(seconds: 45)),
        isCompleted: status != TransactionStatus.failed && status != TransactionStatus.cancelled,
      ),
      TimelineStepModel(
        title: 'Security Verification',
        description: 'Fraud & AML automated check cleared',
        timestamp: date.add(const Duration(minutes: 2)),
        isCompleted: status == TransactionStatus.successful || status == TransactionStatus.refunded,
      ),
      TimelineStepModel(
        title: 'Wallet Settlement',
        description: 'Funds disbursed to destination wallet balance',
        timestamp: date.add(const Duration(minutes: 3)),
        isCompleted: status == TransactionStatus.successful,
      ),
    ];
  }
}