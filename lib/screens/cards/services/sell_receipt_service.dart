import '../models/sell_receipt_model.dart';

class SellReceiptService {
  Future<SellReceiptModel> fetchReceipt(String transactionId) async {
    // Simulating network delay
    await Future.delayed(const Duration(seconds: 1));
    
    return SellReceiptModel(
      referenceId: 'NC-2026-92831',
      giftCardName: 'Amazon Gift Card',
      region: 'United States',
      cardsSubmitted: 3,
      totalFaceValue: 150.00,
      sellRate: 93.20,
      estimatedReceive: 139.80,
      status: VerificationStatus.pending,
      submittedOn: '29 Jul 2026, 10:42 AM',
    );
  }
}