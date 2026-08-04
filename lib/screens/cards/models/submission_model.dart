class SubmissionModel {
  final String referenceId;
  final int cardsSubmitted;
  final double totalFaceValue;
  final double sellRate;
  final double estimatedReceive;
  final String verificationTime;
  final String submittedOn;
  final String paymentMethod;

  SubmissionModel({
    required this.referenceId,
    required this.cardsSubmitted,
    required this.totalFaceValue,
    required this.sellRate,
    required this.estimatedReceive,
    required this.verificationTime,
    required this.submittedOn,
    required this.paymentMethod,
  });
}