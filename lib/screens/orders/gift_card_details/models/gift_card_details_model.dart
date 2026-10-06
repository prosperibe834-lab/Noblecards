class GiftCardDetailsModel {
  final String orderId;
  final String brandName;
  final String cardType;
  final String country;
  final String format; // e.g., "Digital"
  final double denomination;
  final double amountPaid;
  final String currency;
  final String status;
  final String code;
  final String? pin;
  final List<String> importantInformation;

  GiftCardDetailsModel({
    required this.orderId,
    required this.brandName,
    required this.cardType,
    required this.country,
    required this.format,
    required this.denomination,
    required this.amountPaid,
    required this.currency,
    required this.status,
    required this.code,
    this.pin,
    required this.importantInformation,
  });
}