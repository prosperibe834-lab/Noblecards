import 'package:flutter/material.dart';

class CurrencyOption {
  final String code;
  final String name;
  final String flag;
  final double rateToUsd; // e.g. 1 USD = X Currency

  const CurrencyOption({
    required this.code,
    required this.name,
    required this.flag,
    required this.rateToUsd,
  });
}

class WithdrawalMethodModel {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final String estimatedTime;
  final String? badge;
  final List<String> supportedCurrencies;

  const WithdrawalMethodModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.estimatedTime,
    this.badge,
    required this.supportedCurrencies,
  });
}

class SavedAccountModel {
  final String id;
  final String title;
  final String details;
  final String methodId;
  final bool isDefault;
  final bool isVerified;

  SavedAccountModel({
    required this.id,
    required this.title,
    required this.details,
    required this.methodId,
    this.isDefault = false,
    this.isVerified = true,
  });
}

class WithdrawalTransaction {
  final String id;
  final String reference;
  final double amountUsd;
  final double receivedAmount;
  final String currency;
  final double exchangeRate;
  final double feeUsd;
  final String methodTitle;
  final String recipientDetails;
  final String date;
  final String time;
  final String status; // Completed, Pending, Processing, Failed, Cancelled

  WithdrawalTransaction({
    required this.id,
    required this.reference,
    required this.amountUsd,
    required this.receivedAmount,
    required this.currency,
    required this.exchangeRate,
    required this.feeUsd,
    required this.methodTitle,
    required this.recipientDetails,
    required this.date,
    required this.time,
    required this.status,
  });
}