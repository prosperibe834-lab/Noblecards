class WithdrawalBank {
  final String id;
  final String name;
  final String code;
  final String? logoUrl;
  final bool hasBranches;

  WithdrawalBank({
    required this.id,
    required this.name,
    required this.code,
    this.logoUrl,
    this.hasBranches = false,
  });
}

class WithdrawalBranch {
  final String id;
  final String name;
  final String code;

  const WithdrawalBranch({
    required this.id,
    required this.name,
    required this.code,
  });
}

class WithdrawalDestination {
  final String countryCode;
  final String countryName;
  final String currency;
  final String flag;

  WithdrawalDestination({
    required this.countryCode,
    required this.countryName,
    required this.currency,
    required this.flag,
  });
}

class SavedBeneficiary {
  final String id;
  final String countryCode;
  final String currency;
  final String paymentMethod;
  final String institutionName;
  final String? institutionCode;
  final String accountHolderName;
  final String maskedAccount;
  final bool isVerified;
  final DateTime? createdAt;

  const SavedBeneficiary({
    required this.id,
    required this.countryCode,
    required this.currency,
    required this.paymentMethod,
    required this.institutionName,
    this.institutionCode,
    required this.accountHolderName,
    required this.maskedAccount,
    this.isVerified = true,
    this.createdAt,
  });

  factory SavedBeneficiary.fromJson(Map<String, dynamic> json) {
    final institution =
        json['institution'] is Map ? json['institution'] as Map : null;
    final institutionName = json['institutionName']?.toString() ??
        institution?['name']?.toString() ??
        'Bank Transfer';
    final institutionCode = json['providerBankCode']?.toString() ??
        institution?['code']?.toString();
    final maskedAccount = json['maskedAccount']?.toString() ??
        (json['accountLast4'] != null
            ? '•••• ${json['accountLast4']}'
            : '••••');
    final accountHolderName = json['accountHolderName']?.toString() ?? '';

    return SavedBeneficiary(
      id: json['id']?.toString() ?? '',
      countryCode: (json['countryCode'] ?? json['country_code'] ?? '')
          .toString()
          .toUpperCase(),
      currency: json['currency']?.toString() ??
          json['currencyCode']?.toString() ??
          '',
      paymentMethod: json['method']?.toString() ??
          json['paymentMethod']?.toString() ??
          'BANK_TRANSFER',
      institutionName: institutionName,
      institutionCode: institutionCode,
      accountHolderName: accountHolderName,
      maskedAccount: maskedAccount,
      isVerified: json['verificationStatus']?.toString().toUpperCase() ==
              'VERIFIED' ||
          json['verified'] == true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}
