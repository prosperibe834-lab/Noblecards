import '../models/submission_model.dart';

class SubmissionService {
  // Simulates an API call to get the submission receipt details
  Future<SubmissionModel> fetchSubmissionDetails(String transactionId) async {
    await Future.delayed(const Duration(seconds: 2)); // Mock network delay
    
    // Mock response matching the design exactly
    return SubmissionModel(
      referenceId: 'NC-2026-92831',
      cardsSubmitted: 10,
      totalFaceValue: 850.00,
      sellRate: 93.20,
      estimatedReceive: 792.20,
      verificationTime: '5 - 30 Minutes',
      submittedOn: '29 Jul 2026, 10:42 AM',
      paymentMethod: 'USD Wallet',
    );
  }
}