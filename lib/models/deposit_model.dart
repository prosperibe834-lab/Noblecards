String _safeString(dynamic value, {String fallback = ''}) {
  if (value == null) return fallback;
  if (value is String) return value;
  return value.toString();
}

num _safeNum(dynamic value, {num fallback = 0}) {
  if (value == null) return fallback;
  if (value is num) return value;
  if (value is String) {
    final cleaned = value.replaceAll(',', '').trim();
    return num.tryParse(cleaned) ?? fallback;
  }
  final parsed = num.tryParse(value.toString().replaceAll(',', '').trim());
  return parsed ?? fallback;
}

class Deposit {
  final String id;
  final String status;
  final String provider;
  final String currency;
  final String amount;
  final String fee;
  final String netAmount;
  final String? paymentMethod;
  final String? paymentLink;
  final String? authorizationUrl;
  final BankTransferDetails? bankTransfer;
  final String? providerReference;
  final String? providerTransactionId;
  final String walletId;
  final DepositTransaction? transaction;

  Deposit({
    required this.id,
    required this.status,
    required this.provider,
    required this.currency,
    required this.amount,
    required this.fee,
    required this.netAmount,
    this.paymentMethod,
    this.paymentLink,
    this.authorizationUrl,
    this.bankTransfer,
    this.providerReference,
    this.providerTransactionId,
    required this.walletId,
    this.transaction,
  });

  factory Deposit.fromJson(Map<String, dynamic> json) {
    final bankTransferJson = json['bankTransfer'];
    final transactionJson = json['transaction'];

    return Deposit(
      id: _safeString(json['id']),
      status: _safeString(json['status'], fallback: 'PENDING'),
      provider: _safeString(json['provider'], fallback: 'FLUTTERWAVE'),
      currency: _safeString(json['currency']),
      amount: _safeString(json['amount'], fallback: '0.00'),
      fee: _safeString(json['fee'], fallback: '0.00'),
      netAmount: _safeString(json['netAmount'], fallback: '0.00'),
      paymentMethod: json['paymentMethod'] == null ? null : _safeString(json['paymentMethod']),
      paymentLink: json['paymentLink'] == null ? null : _safeString(json['paymentLink']),
      authorizationUrl: (json['authorizationUrl'] ?? json['authorization_url']) == null
          ? null
          : _safeString(json['authorizationUrl'] ?? json['authorization_url']),
      bankTransfer: bankTransferJson != null && bankTransferJson is Map<String, dynamic>
          ? BankTransferDetails.fromJson(bankTransferJson)
          : bankTransferJson is Map
              ? BankTransferDetails.fromJson(Map<String, dynamic>.from(bankTransferJson))
              : null,
      providerReference: json['providerReference'] == null ? null : _safeString(json['providerReference']),
      providerTransactionId: json['providerTransactionId'] == null ? null : _safeString(json['providerTransactionId']),
      walletId: _safeString(json['walletId']),
      transaction: transactionJson != null && transactionJson is Map<String, dynamic>
          ? DepositTransaction.fromJson(transactionJson)
          : transactionJson is Map
              ? DepositTransaction.fromJson(Map<String, dynamic>.from(transactionJson))
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status,
        'provider': provider,
        'currency': currency,
        'amount': amount,
        'fee': fee,
        'netAmount': netAmount,
        'paymentMethod': paymentMethod,
        'paymentLink': paymentLink,
        'authorizationUrl': authorizationUrl,
        'authorization_url': authorizationUrl,
        'bankTransfer': bankTransfer?.toJson(),
        'providerReference': providerReference,
        'providerTransactionId': providerTransactionId,
        'walletId': walletId,
        'transaction': transaction?.toJson(),
      };
}

class BankTransferDetails {
  final String bankName;
  final String accountNumber;
  final String accountName;
  final num amount;
  final String currency;
  final String? expiresAt;

  BankTransferDetails({
    required this.bankName,
    required this.accountNumber,
    required this.accountName,
    required this.amount,
    required this.currency,
    this.expiresAt,
  });

  factory BankTransferDetails.fromJson(Map<String, dynamic> json) {
    final rawAccountName = _safeString(json['accountName']).trim();

    return BankTransferDetails(
      bankName: _safeString(json['bankName']),
      accountNumber: _safeString(json['accountNumber']),
      accountName: rawAccountName.isEmpty ? 'Account name unavailable' : rawAccountName,
      amount: _safeNum(json['amount']),
      currency: _safeString(json['currency']),
      expiresAt: json['expiresAt'] == null ? null : _safeString(json['expiresAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'bankName': bankName,
        'accountNumber': accountNumber,
        'accountName': accountName,
        'amount': amount,
        'currency': currency,
        'expiresAt': expiresAt,
      };
}

class DepositTransaction {
  final String id;
  final String status;
  final String reference;

  DepositTransaction({
    required this.id,
    required this.status,
    required this.reference,
  });

  factory DepositTransaction.fromJson(Map<String, dynamic> json) {
    return DepositTransaction(
      id: _safeString(json['id']),
      status: _safeString(json['status'], fallback: 'PENDING'),
      reference: _safeString(json['reference']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status,
        'reference': reference,
      };
}
