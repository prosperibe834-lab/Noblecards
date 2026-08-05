import 'package:flutter/material.dart';
import 'models/order_model.dart';
import '../cards/buy_receipt_screen.dart';
import '../cards/sell_receipt_screen.dart';

class OrderDetailsRouter {
  static void navigateToReceipt(BuildContext context, OrderModel order) {
    if (order.transactionType == TransactionType.buy) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BuyReceiptScreen(transactionId: order.referenceId),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SellReceiptScreen(transactionId: order.referenceId),
        ),
      );
    }
  }
}