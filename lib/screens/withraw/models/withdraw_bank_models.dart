class WithdrawalBank {
  final String id;
  final String name;
  final String code;
  final String? logoUrl;

  WithdrawalBank({
    required this.id,
    required this.name,
    required this.code,
    this.logoUrl,
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