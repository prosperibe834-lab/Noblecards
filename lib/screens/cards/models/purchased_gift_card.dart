enum PurchaseStatus { completed, pending, failed }

class PurchasedGiftCard {
  final String referenceId;
  final String brandName;
  final String region;
  final String cardType;
  final int quantity;
  final double faceValue;
  final double amountPaid;
  final String paymentMethod;
  final String currencyCode;
  final String paymentCurrencyCode;
  final String countryFlag;
  final String purchaseDate;
  final PurchaseStatus status;
  final String? providerMessage;

  // Card Details for the View Screen
  final String cardCode;
  final String? pin;
  final String? barcodeUrl;

  PurchasedGiftCard({
    required this.referenceId,
    required this.brandName,
    required this.region,
    required this.cardType,
    required this.quantity,
    required this.faceValue,
    required this.amountPaid,
    required this.paymentMethod,
    this.currencyCode = 'USD',
    this.paymentCurrencyCode = 'USD',
    this.countryFlag = '🌍',
    required this.purchaseDate,
    required this.status,
    this.providerMessage,
    required this.cardCode,
    this.pin,
    this.barcodeUrl,
  });
}
