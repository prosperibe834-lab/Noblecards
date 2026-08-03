class BuyOrderModel {
  final double amount;
  final int quantity;
  final double rate;
  final String currency;

  BuyOrderModel({
    required this.amount,
    required this.quantity,
    required this.rate,
    this.currency = 'USD',
  });

  double get total => amount * quantity * (rate / 100);
}
