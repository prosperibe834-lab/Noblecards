class GiftCardDetailsModel {
  final String orderId;
  final String? orderReference;
  final String brandName;
  final String cardType;
  final String? brandLogoUrl;
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
    this.orderReference,
    required this.brandName,
    required this.cardType,
    this.brandLogoUrl,
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

  String get copyAllDetailsText =>
      _formatDetails('NobleCards - Gift Card Details');

  String get downloadText => _formatDetails('NobleCards Gift Card Receipt');

  String _formatDetails(String title) {
    final fields = <String>[
      title,
      if (brandName.trim().isNotEmpty && brandName != 'Gift Card')
        'Brand: ${brandName.trim()}',
      if (cardType.trim().isNotEmpty && cardType != 'Digital Gift Card')
        'Product: ${cardType.trim()}',
      if (denomination > 0) 'Amount: ${denomination.toStringAsFixed(2)}',
      if (currency.trim().isNotEmpty) 'Currency: ${currency.trim()}',
      if (country.trim().isNotEmpty && country != 'Unknown')
        'Country: ${country.trim()}',
      if (status.trim().isNotEmpty) 'Status: ${status.trim()}',
      if (orderReference?.trim().isNotEmpty ?? false)
        'Order Reference: ${orderReference!.trim()}',
      if (code.trim().isNotEmpty) 'Gift Card Code: ${code.trim()}',
      if (pin?.trim().isNotEmpty ?? false) 'Gift Card PIN: ${pin!.trim()}',
    ];
    return fields.join('\n');
  }
}
