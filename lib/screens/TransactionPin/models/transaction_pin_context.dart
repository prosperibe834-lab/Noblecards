import 'package:flutter/foundation.dart';

@immutable
class TransactionPinContext {
  final String title;
  final String subtitle;
  final String? amount;
  final String? currency;
  final String? recipient;
  final String? transactionType;

  const TransactionPinContext({
    this.title = 'Confirm Transaction PIN',
    this.subtitle = 'Enter your 4-digit transaction PIN\nto proceed with this action.',
    this.amount,
    this.currency,
    this.recipient,
    this.transactionType,
  });

  factory TransactionPinContext.withdrawal({
    String? amount,
    String? currency,
    String? destination,
  }) {
    final amountText = (amount != null && currency != null)
        ? ' of $currency $amount'
        : (amount != null ? ' of $amount' : '');
    final destText = destination != null ? ' to $destination' : '';

    return TransactionPinContext(
      title: 'Confirm Transaction PIN',
      subtitle: 'Enter your 4-digit transaction PIN\nto proceed with this withdrawal$amountText$destText.',
      amount: amount,
      currency: currency,
      recipient: destination,
      transactionType: 'withdrawal',
    );
  }

  factory TransactionPinContext.transfer({
    required String recipientName,
    String? amount,
    String? currency,
  }) {
    final amountText = (amount != null && currency != null)
        ? ' of $currency $amount'
        : '';

    return TransactionPinContext(
      title: 'Confirm Transaction PIN',
      subtitle: 'Enter your 4-digit transaction PIN\nto send$amountText to $recipientName.',
      amount: amount,
      currency: currency,
      recipient: recipientName,
      transactionType: 'transfer',
    );
  }

  factory TransactionPinContext.giftCard({
    required String cardName,
    String? amount,
    String? currency,
  }) {
    return TransactionPinContext(
      title: 'Confirm Transaction PIN',
      subtitle: 'Enter your 4-digit transaction PIN\nto finalize purchase for $cardName.',
      amount: amount,
      currency: currency,
      transactionType: 'giftcard',
    );
  }
}