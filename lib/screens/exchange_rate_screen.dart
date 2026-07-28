import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class CurrencyRate {
  final String code;
  final String name;
  final String flag;
  final String symbol;
  final double rateToUsd; // Base benchmark rate in USD
  final double change24h; // Percentage change (+ or -)
  final double high24h;
  final double low24h;

  CurrencyRate({
    required this.code,
    required this.name,
    required this.flag,
    required this.symbol,
    required this.rateToUsd,
    required this.change24h,
    required this.high24h,
    required this.low24h,
  });
}

class ExchangeRateScreen extends StatefulWidget {
  const ExchangeRateScreen({super.key});

  @override
  State<ExchangeRateScreen> createState() => _ExchangeRateScreenState();
}

class _ExchangeRateScreenState extends State<ExchangeRateScreen> {
  final TextEditingController _fromAmountController = TextEditingController(text: '100');
  final TextEditingController _toAmountController = TextEditingController();

  // Currencies Dataset
  final List<CurrencyRate> _currencies = [
    CurrencyRate(code: 'USD', name: 'US Dollar', flag: '🇺🇸', symbol: '\$', rateToUsd: 1.0, change24h: 0.00, high24h: 1.00, low24h: 1.00),
    CurrencyRate(code: 'NGN', name: 'Nigerian Naira', flag: '🇳🇬', symbol: '₦', rateToUsd: 1550.0, change24h: +1.45, high24h: 1565.0, low24h: 1535.0),
    CurrencyRate(code: 'GBP', name: 'British Pound', flag: '🇬🇧', symbol: '£', rateToUsd: 0.78, change24h: -0.32, high24h: 0.79, low24h: 0.77),
    CurrencyRate(code: 'EUR', name: 'Euro', flag: '🇪🇺', symbol: '€', rateToUsd: 0.92, change24h: +0.18, high24h: 0.93, low24h: 0.91),
    CurrencyRate(code: 'CAD', name: 'Canadian Dollar', flag: '🇨🇦', symbol: 'CA\$', rateToUsd: 1.36, change24h: +0.05, high24h: 1.37, low24h: 1.35),
    CurrencyRate(code: 'GHS', name: 'Ghanaian Cedi', flag: '🇬🇭', symbol: 'GH₵', rateToUsd: 15.20, change24h: -0.85, high24h: 15.40, low24h: 15.10),
    CurrencyRate(code: 'KES', name: 'Kenyan Shilling', flag: '🇰🇪', symbol: 'KSh', rateToUsd: 129.50, change24h: +0.22, high24h: 130.10, low24h: 128.90),
    CurrencyRate(code: 'AED', name: 'UAE Dirham', flag: '🇦🇪', symbol: 'AED', rateToUsd: 3.67, change24h: 0.00, high24h: 3.67, low24h: 3.67),
  ];

  late CurrencyRate _fromCurrency;
  late CurrencyRate _toCurrency;

  @override
  void initState() {
    super.initState();
    _fromCurrency = _currencies.firstWhere((c) => c.code == 'USD');
    _toCurrency = _currencies.firstWhere((c) => c.code == 'NGN');
    _calculateConversion();
  }

  @override
  void dispose() {
    _fromAmountController.dispose();
    _toAmountController.dispose();
    super.dispose();
  }

  void _calculateConversion() {
    final double input = double.tryParse(_fromAmountController.text) ?? 0.0;
    if (input <= 0) {
      _toAmountController.text = '0.00';
      return;
    }

    // Convert from source to USD, then USD to target
    final double inUsd = input / _fromCurrency.rateToUsd;
    final double result = inUsd * _toCurrency.rateToUsd;

    _toAmountController.text = result >= 1000
        ? result.toStringAsFixed(2)
        : result.toStringAsFixed(4);
  }

  void _swapCurrencies() {
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
      _calculateConversion();
    });
  }

  double get _currentEffectiveRate {
    return (1.0 / _fromCurrency.rateToUsd) * _toCurrency.rateToUsd;
  }

  void _showCurrencyPicker({required bool isFrom}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isFrom ? 'Select Source Currency' : 'Select Target Currency',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: _currencies.length,
                  itemBuilder: (context, index) {
                    final curr = _currencies[index];
                    return ListTile(
                      leading: Text(curr.flag, style: const TextStyle(fontSize: 24)),
                      title: Text('${curr.code} - ${curr.name}'),
                      trailing: Text(curr.symbol, style: const TextStyle(fontWeight: FontWeight.bold)),
                      onTap: () {
                        setState(() {
                          if (isFrom) {
                            _fromCurrency = curr;
                          } else {
                            _toCurrency = curr;
                          }
                          _calculateConversion();
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Exchange Rates',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Boxicons.bx_arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Boxicons.bx_refresh),
            onPressed: () {
              _calculateConversion();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Rates updated in real-time'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Converter Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // From Input
                    _buildCurrencyInputRow(
                      label: 'You Convert',
                      controller: _fromAmountController,
                      selectedCurrency: _fromCurrency,
                      onCurrencyTap: () => _showCurrencyPicker(isFrom: true),
                      onChanged: (val) => _calculateConversion(),
                      isReadOnly: false,
                    ),

                    const SizedBox(height: 12),

                    // Swap Divider Button
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Divider(color: Colors.grey.shade200, thickness: 1.5),
                        InkWell(
                          onTap: _swapCurrencies,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: theme.primaryColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: theme.primaryColor.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Boxicons.bx_transfer_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // To Input
                    _buildCurrencyInputRow(
                      label: 'You Receive',
                      controller: _toAmountController,
                      selectedCurrency: _toCurrency,
                      onCurrencyTap: () => _showCurrencyPicker(isFrom: false),
                      isReadOnly: true,
                    ),

                    const SizedBox(height: 16),

                    // Live Benchmark Rate Banner
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Boxicons.bx_info_circle, size: 16, color: Colors.grey),
                              SizedBox(width: 6),
                              Text(
                                'Indicative Rate',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          Text(
                            '1 ${_fromCurrency.code} = ${_currentEffectiveRate >= 1000 ? _currentEffectiveRate.toStringAsFixed(2) : _currentEffectiveRate.toStringAsFixed(4)} ${_toCurrency.code}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Rate Trend Overview Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (_toCurrency.change24h >= 0 ? Colors.green : Colors.red).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _toCurrency.change24h >= 0
                            ? Boxicons.bx_trending_up
                            : Boxicons.bx_trending_down,
                        color: _toCurrency.change24h >= 0 ? Colors.green : Colors.red,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_toCurrency.code} 24h Trend',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'High: ${_toCurrency.high24h} | Low: ${_toCurrency.low24h}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: (_toCurrency.change24h >= 0 ? Colors.green : Colors.red).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_toCurrency.change24h >= 0 ? '+' : ''}${_toCurrency.change24h}%',
                        style: TextStyle(
                          color: _toCurrency.change24h >= 0 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Live Market Rates Table Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'LIVE MARKET RATES',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 1.1,
                    ),
                  ),
                  Text(
                    'Base: ${_fromCurrency.code}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Rates Matrix List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _currencies.length,
                itemBuilder: (context, index) {
                  final currency = _currencies[index];
                  if (currency.code == _fromCurrency.code) return const SizedBox.shrink();

                  final double convertedRate = (1.0 / _fromCurrency.rateToUsd) * currency.rateToUsd;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Text(currency.flag, style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currency.code,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Text(
                                currency.name,
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${currency.symbol}${convertedRate >= 1000 ? convertedRate.toStringAsFixed(2) : convertedRate.toStringAsFixed(4)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${currency.change24h >= 0 ? '+' : ''}${currency.change24h}%',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: currency.change24h >= 0 ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyInputRow({
    required String label,
    required TextEditingController controller,
    required CurrencyRate selectedCurrency,
    required VoidCallback onCurrencyTap,
    ValueChanged<String>? onChanged,
    bool isReadOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                readOnly: isReadOnly,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: onChanged,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
              ),
            ),
            InkWell(
              onTap: onCurrencyTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Text(selectedCurrency.flag, style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 6),
                    Text(
                      selectedCurrency.code,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Boxicons.bx_chevron_down, size: 18, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}