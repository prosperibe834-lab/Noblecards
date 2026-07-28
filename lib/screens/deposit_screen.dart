import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../widgets/glass_card.dart';
import '../widgets/favorite_currency_chip.dart';
import '../widgets/deposit_step_indicator.dart';
import 'currency_selector_screen.dart';
import 'deposit_payment_screen.dart';

// Import your app routes file if applicable
// import '../routes/app_routes.dart';
class DepositScreen extends StatefulWidget {
  const DepositScreen({super.key});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  bool _isBalanceVisible = true;
  String _selectedCurrencyCode = "NGN";
  String _selectedFlag = "🇳🇬";
  double _exchangeRate = 1640.00; // 1 USD = 1640 NGN
  final TextEditingController _amountController = TextEditingController(
    text: "656000",
  );

  final List<Map<String, String>> _favorites = [
    {"code": "NGN", "flag": "🇳🇬"},
    {"code": "GBP", "flag": "🇬🇧"},
    {"code": "EUR", "flag": "🇪🇺"},
    {"code": "CAD", "flag": "🇨🇦"},
  ];

  double get _enteredAmount => double.tryParse(_amountController.text) ?? 0.0;
  double get _calculatedUsd =>
      _enteredAmount > 0 ? _enteredAmount / _exchangeRate : 0.0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Deposit Funds",
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Boxicons.bx_arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Boxicons.bx_help_circle),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DepositStepIndicator(currentStep: 1),
            const SizedBox(height: 12),

            // --- WALLET BALANCE CARD ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF1A2639), const Color(0xFF111823)]
                      : [primaryColor, primaryColor.withBlue(220)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "USD Wallet Balance",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isBalanceVisible
                              ? Boxicons.bx_show
                              : Boxicons.bx_hide,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => setState(
                          () => _isBalanceVisible = !_isBalanceVisible,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _isBalanceVisible ? "\$2,350.00" : "••••••••",
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- CURRENCY SELECTOR ROW ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      "Select Currency",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Boxicons.bx_cog,
                        size: 18,
                        color: Colors.grey,
                      ),
                      tooltip: "Manage Favourites",
                      onPressed: () {
                        // Make sure AppRoutes is imported or replace with route string
                        Navigator.pushNamed(context, '/favourite-currencies');
                      },
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () async {
                    final res = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CurrencySelectorScreen(),
                      ),
                    );
                    if (res != null) {
                      setState(() {
                        _selectedCurrencyCode = res["code"];
                        _selectedFlag = res["flag"];
                      });
                    }
                  },
                  icon: const Icon(Boxicons.bx_search, size: 16),
                  label: const Text(
                    "All Currencies",
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 13),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // --- FAVORITE CURRENCY CHIPS ---
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _favorites.map((item) {
                  final isSelected = item["code"] == _selectedCurrencyCode;
                  return FavoriteCurrencyChip(
                    code: item["code"]!,
                    flag: item["flag"]!,
                    isSelected: isSelected,
                    onTap: () => setState(() {
                      _selectedCurrencyCode = item["code"]!;
                      _selectedFlag = item["flag"]!;
                    }),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // --- DEPOSIT AMOUNT INPUT CARD ---
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "You Deposit ($_selectedCurrencyCode)",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(_selectedFlag, style: const TextStyle(fontSize: 28)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "0.00",
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),

                  // Conversion Details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Boxicons.bx_transfer_alt,
                            size: 16,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "1 USD = $_selectedCurrencyCode ${_exchangeRate.toStringAsFixed(0)}",
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "You Get: \$${_calculatedUsd.toStringAsFixed(2)} USD",
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Quick Access to Live Exchange Rates
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/exchange-rate');
                      },
                      icon: const Icon(Boxicons.bx_line_chart, size: 16),
                      label: const Text(
                        'View Live Exchange Rates',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // --- QUICK AMOUNT BUTTONS ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [50, 100, 200, 500, 1000].map((usd) {
                final localAmt = (usd * _exchangeRate).toInt();
                return InkWell(
                  onTap: () => setState(
                    () => _amountController.text = localAmt.toString(),
                  ),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white10 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "\$$usd",
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // --- PROCEED BUTTON ---
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                ),
                onPressed: _enteredAmount <= 0
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PaymentMethodScreen(
                              depositAmount: _enteredAmount,
                              currencyCode: _selectedCurrencyCode,
                              convertedUsd: _calculatedUsd,
                            ),
                          ),
                        );
                      },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Continue to Payment",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Boxicons.bx_right_arrow_alt, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
