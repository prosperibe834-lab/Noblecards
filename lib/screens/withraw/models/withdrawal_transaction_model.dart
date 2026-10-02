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
  final String? failureReason;

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
    this.failureReason,
  });

  factory WithdrawalTransactionModel.fromBackendJson(Map<String, dynamic> json) {
    final sourceCurrency = _requiredString(json, 'sourceCurrency');
    final destinationCurrency = _requiredString(json, 'destinationCurrency');
    final countryCode = (json['countryCode'] ?? '').toString().toUpperCase();
    final beneficiary = json['beneficiary'] is Map
        ? Map<String, dynamic>.from(json['beneficiary'] as Map)
        : const <String, dynamic>{};
    final amountReceived = _requiredAmount(json, 'amountReceived');

    return WithdrawalTransactionModel(
      amount: _requiredAmount(json, 'sourceAmount'),
      sourceAmount: _requiredAmount(json, 'sourceAmount'),
      sourceCurrency: sourceCurrency,
      destinationAmount: _requiredAmount(json, 'destinationAmount'),
      destinationCurrency: destinationCurrency,
      amountToSend: _requiredAmount(json, 'sourceAmount'),
      exchangeRate: _requiredAmount(json, 'exchangeRate'),
      convertedAmount: _requiredAmount(json, 'destinationAmount'),
      fee: _requiredAmount(json, 'fee'),
      amountToReceive: amountReceived,
      currency: sourceCurrency,
      method: _formatMethod(_requiredString(json, 'paymentMethod')),
      destinationCountry: _requiredString(json, 'country'),
      countryFlag: _countryFlag(countryCode),
      destinationBank: (beneficiary['institutionName'] ?? '').toString(),
      destinationAccountMasked: beneficiary['accountLast4'] == null
          ? ''
          : '******${beneficiary['accountLast4']}',
      referenceId: _requiredString(json, 'reference'),
      timestamp: _requiredDate(json, 'createdAt'),
      status: _requiredString(json, 'status'),
      failureReason: _optionalString(json['failureReason']),
    );
  }

  static String _requiredString(Map<String, dynamic> json, String key) {
    final value = json[key]?.toString().trim();
    if (value == null || value.isEmpty) {
      throw FormatException('Withdrawal details are missing $key.');
    }
    return value;
  }

  static double _requiredAmount(Map<String, dynamic> json, String key) {
    final value = json[key];
    final parsed = value is num
        ? value.toDouble()
        : double.tryParse(value?.toString() ?? '');
    if (parsed == null || !parsed.isFinite) {
      throw FormatException('Withdrawal details have an invalid $key.');
    }
    return parsed;
  }

  static DateTime _requiredDate(Map<String, dynamic> json, String key) {
    final value = DateTime.tryParse(json[key]?.toString() ?? '');
    if (value == null) {
      throw FormatException('Withdrawal details have an invalid $key.');
    }
    return value;
  }

  static String? _optionalString(Object? value) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? null : text;
  }

  static String _formatMethod(String method) => method
      .split('_')
      .map((part) => part.isEmpty ? part : '${part[0]}${part.substring(1).toLowerCase()}')
      .join(' ');

  static String _countryFlag(String code) {
    if (code.length != 2) return '';
    final points = code.codeUnits.map((unit) => 0x1F1E6 + unit - 0x41);
    return String.fromCharCodes(points);
  }
}
