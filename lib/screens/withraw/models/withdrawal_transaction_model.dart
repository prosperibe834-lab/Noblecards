class WithdrawalTransactionModel {
  final double amount;
  final double sourceAmount;
  final String sourceCurrency;
  final double destinationAmount;
  final String destinationCurrency;
  final double? amountToSend;
  final double? exchangeRate;
  final double? convertedAmount;
  final double? fee;
  final double? amountToReceive;
  final String currency;
  final String method; // e.g., 'Bank Transfer', 'Mobile Money'
  final String destinationCountry;
  final String countryFlag;
  final String destinationBank;
  final String destinationAccountMasked; // e.g., '1234'
  final String referenceId;
  final DateTime timestamp;
  final String status;

  WithdrawalTransactionModel({
    required this.amount,
    required this.sourceAmount,
    required this.sourceCurrency,
    required this.destinationAmount,
    required this.destinationCurrency,
    this.amountToSend,
    this.exchangeRate,
    this.convertedAmount,
    this.fee,
    this.amountToReceive,
    required this.currency,
    required this.method,
    required this.destinationCountry,
    required this.countryFlag,
    required this.destinationBank,
    required this.destinationAccountMasked,
    required this.referenceId,
    required this.timestamp,
    required this.status,
  });
}
