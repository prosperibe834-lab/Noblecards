import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../widgets/glass_card.dart';
import '../widgets/deposit_step_indicator.dart';
import 'bank_transfer_screen.dart';

class PaymentMethodScreen extends StatelessWidget {
  final double depositAmount;
  final String currencyCode;
  final double convertedUsd;

  const PaymentMethodScreen({
    super.key,
    required this.depositAmount,
    required this.currencyCode,
    required this.convertedUsd,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final methods = [
      {
        "id": "bank",
        "title": "Local Bank Transfer",
        "desc": "Flutterwave Virtual Account. Instant verification.",
        "icon": Boxicons.bx_building_house,
        "tag": "FREE & INSTANT",
      },
      {
        "id": "card",
        "title": "Debit or Credit Card",
        "desc": "Visa, MasterCard, Verve, Amex",
        "icon": Boxicons.bx_credit_card,
        "tag": "1.5% FEE",
      },
      {
        "id": "apple",
        "title": "Apple Pay / Google Pay",
        "desc": "Fast checkout via mobile wallet",
        "icon": Boxicons.bx_mobile_alt,
        "tag": "POPULAR",
      },
      {
        "id": "wise",
        "title": "Wise / Wire Transfer",
        "desc": "International bank wire transfer",
        "icon": Boxicons.bx_globe,
        "tag": "1-2 DAYS",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Method", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DepositStepIndicator(currentStep: 2),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: methods.length,
                itemBuilder: (context, index) {
                  final item = methods[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: GlassCard(
                      onTap: () {
                        if (item["id"] == "bank") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BankTransferScreen(
                                amount: depositAmount,
                                currency: currencyCode,
                                convertedUsd: convertedUsd,
                              ),
                            ),
                          );
                        }
                      },
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              item["icon"] as IconData,
                              color: Theme.of(context).primaryColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      item["title"] as String,
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        item["tag"] as String,
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item["desc"] as String,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 11,
                                    color: isDark ? Colors.white60 : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Boxicons.bx_chevron_right, size: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}