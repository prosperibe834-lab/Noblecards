class LiveMarketModel {
  final String id;
  final String cardName;
  final String logoUrl;
  final String countryFlag;
  final String actionType; // 'sold' or 'bought'
  final String timeAgo;

  const LiveMarketModel({
    required this.id,
    required this.cardName,
    required this.logoUrl,
    required this.countryFlag,
    required this.actionType,
    required this.timeAgo,
  });
}