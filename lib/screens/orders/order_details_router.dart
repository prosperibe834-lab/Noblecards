import 'package:flutter/material.dart';
import 'models/order_model.dart';
import '../cards/sell_receipt_screen.dart';
import 'gift_card_details/gift_card_details_screen.dart';

class OrderDetailsRouter {
  static void navigateToReceipt(BuildContext context, OrderModel order) {
    if (order.transactionType == TransactionType.buy) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => GiftCardDetailsScreen(
            giftCardData: null,
            purchaseId: order.orderId,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SellReceiptScreen(transactionId: order.orderId),
        ),
      );
    }
  }
}
