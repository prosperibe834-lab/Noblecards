import '../models/purchased_gift_card.dart';

class BuyReceiptService {
  Future<PurchasedGiftCard> fetchPurchaseDetails(String transactionId) async {
    await Future.delayed(const Duration(seconds: 1)); // Network simulation

    return PurchasedGiftCard(
      referenceId: 'NC-2026-54231',
      brandName: 'Amazon Gift Card',
      region: 'United States',
      cardType: 'Digital Code',
      quantity: 1,
      faceValue: 100.00,
      amountPaid: 98.50,
      paymentMethod: 'USD Wallet',
      purchaseDate: '29 Jul 2026, 10:42 AM',
      status: PurchaseStatus.completed,
      cardCode: 'AQ4X-8V9P-Z7LQ-11M2',
      pin: '8492',
    );
  }
}