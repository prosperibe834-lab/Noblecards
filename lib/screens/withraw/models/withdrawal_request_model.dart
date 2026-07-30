import 'package:flutter/material.dart';

enum WithdrawalType { bank, crypto, paypal }

class WithdrawalMethod {
  final String id;
  final String name;
  final String subtitle;
  final IconData icon;
  final WithdrawalType type;

  const WithdrawalMethod({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.type,
  });
}

class WithdrawalRequestModel {
  final double amount;
  final String currency;
  final WithdrawalMethod method;
  final String destinationAccount;
  final String accountName;
  final double fee;
  final double netAmount;
  final String referenceNumber;

  WithdrawalRequestModel({
    required this.amount,
    required this.currency,
    required this.method,
    required this.destinationAccount,
    required this.accountName,
    required this.fee,
    required this.netAmount,
    required this.referenceNumber,
  });
}