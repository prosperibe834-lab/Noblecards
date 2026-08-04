enum VerificationStatus { pending, approved, rejected, needsReview, completed }

class SellReceiptModel {
  final String referenceId;
  final String giftCardName;
  final String region;
  final int cardsSubmitted;
  final double totalFaceValue;
  final double sellRate;
  final double estimatedReceive;
  final VerificationStatus status;
  final String submittedOn;

  SellReceiptModel({
    required this.referenceId,
    required this.giftCardName,
    required this.region,
    required this.cardsSubmitted,
    required this.totalFaceValue,
    required this.sellRate,
    required this.estimatedReceive,
    required this.status,
    required this.submittedOn,
  });
}