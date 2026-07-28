import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class CurrencyModel {
  final String code;
  final String name;
  final String symbol;
  final String flag;
  final double rateToUsd;
  bool isFavorite;

  CurrencyModel({
    required this.code,
    required this.name,
    required this.symbol,
    required this.flag,
    required this.rateToUsd,
    this.isFavorite = false,
  });
}

class FavouriteCurrenciesScreen extends StatefulWidget {
  final Function(List<String>)? onFavoritesUpdated;

  const FavouriteCurrenciesScreen({
    super.key,
    this.onFavoritesUpdated,
  });

  @override
  State<FavouriteCurrenciesScreen> createState() => _FavouriteCurrenciesScreenState();
}

class _FavouriteCurrenciesScreenState extends State<FavouriteCurrenciesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Initial Currencies Dataset
  final List<CurrencyModel> _allCurrencies = [
    CurrencyModel(code: 'USD', name: 'United States Dollar', symbol: '\$', flag: '🇺🇸', rateToUsd: 1.0, isFavorite: true),
    CurrencyModel(code: 'NGN', name: 'Nigerian Naira', symbol: '₦', flag: '🇳🇬', rateToUsd: 1550.0, isFavorite: true),
    CurrencyModel(code: 'GBP', name: 'British Pound Sterling', symbol: '£', flag: '🇬🇧', rateToUsd: 0.78, isFavorite: true),
    CurrencyModel(code: 'EUR', name: 'Euro', symbol: '€', flag: '🇪🇺', rateToUsd: 0.92, isFavorite: true),
    CurrencyModel(code: 'CAD', name: 'Canadian Dollar', symbol: 'CA\$', flag: '🇨🇦', rateToUsd: 1.36, isFavorite: false),
    CurrencyModel(code: 'AUD', name: 'Australian Dollar', symbol: 'A\$', flag: '🇦🇺', rateToUsd: 1.51, isFavorite: false),
    CurrencyModel(code: 'GHS', name: 'Ghanaian Cedi', symbol: 'GH₵', flag: '🇬🇭', rateToUsd: 15.2, isFavorite: false),
    CurrencyModel(code: 'KES', name: 'Kenyan Shilling', symbol: 'KSh', flag: '🇰🇪', rateToUsd: 129.5, isFavorite: false),
    CurrencyModel(code: 'ZAR', name: 'South African Rand', symbol: 'R', flag: '🇿🇦', rateToUsd: 18.2, isFavorite: false),
    CurrencyModel(code: 'JPY', name: 'Japanese Yen', symbol: '¥', flag: '🇯🇵', rateToUsd: 156.4, isFavorite: false),
    CurrencyModel(code: 'CNY', name: 'Chinese Yuan', symbol: '¥', flag: '🇨🇳', rateToUsd: 7.25, isFavorite: false),
    CurrencyModel(code: 'INR', name: 'Indian Rupee', symbol: '₹', flag: '🇮🇳', rateToUsd: 83.5, isFavorite: false),
    CurrencyModel(code: 'AED', name: 'UAE Dirham', symbol: 'AED', flag: '🇦🇪', rateToUsd: 3.67, isFavorite: false),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CurrencyModel> get _favoriteCurrencies =>
      _allCurrencies.where((c) => c.isFavorite).toList();

  List<CurrencyModel> get _filteredCurrencies {
    if (_searchQuery.isEmpty) return _allCurrencies;
    return _allCurrencies.where((c) {
      return c.code.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void _toggleFavorite(CurrencyModel currency) {
    setState(() {
      currency.isFavorite = !currency.isFavorite;
    });

    if (widget.onFavoritesUpdated != null) {
      widget.onFavoritesUpdated!(_favoriteCurrencies.map((e) => e.code).toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Favourite Currencies',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Boxicons.bx_arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => _searchQuery = val.trim()),
                decoration: InputDecoration(
                  hintText: 'Search currency by code or name...',
                  prefixIcon: const Icon(Boxicons.bx_search, color: Colors.grey),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Boxicons.bx_x, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: theme.cardColor,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: theme.primaryColor, width: 1.8),
                  ),
                ),
              ),
            ),

            // Pinned Favourited Section
            if (_favoriteCurrencies.isNotEmpty && _searchQuery.isEmpty) ...[
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'QUICK ACCESS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 1.1,
                      ),
                    ),
                    Text(
                      '${_favoriteCurrencies.length} selected',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: theme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 52,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: _favoriteCurrencies.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final item = _favoriteCurrencies[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: theme.primaryColor.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(item.flag, style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 8),
                          Text(
                            item.code,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () => _toggleFavorite(item),
                            child: Icon(
                              Boxicons.bx_x_circle,
                              size: 18,
                              color: theme.primaryColor.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],

            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                _searchQuery.isEmpty ? 'ALL SUPPORTED CURRENCIES' : 'SEARCH RESULTS',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1.1,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Currencies List
            Expanded(
              child: _filteredCurrencies.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Boxicons.bx_search_alt, size: 48, color: Colors.grey),
                          const SizedBox(height: 12),
                          Text(
                            'No currency found for "$_searchQuery"',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: _filteredCurrencies.length,
                      itemBuilder: (context, index) {
                        final currency = _filteredCurrencies[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            leading: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  currency.flag,
                                  style: const TextStyle(fontSize: 22),
                                ),
                              ),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  currency.code,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '(${currency.symbol})',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              currency.name,
                              style: const TextStyle(fontSize: 13, color: Colors.black54),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                currency.isFavorite
                                    ? Boxicons.bxs_star
                                    : Boxicons.bx_star,
                                color: currency.isFavorite
                                    ? const Color(0xFFFFB800)
                                    : Colors.grey.shade400,
                                size: 24,
                              ),
                              onPressed: () => _toggleFavorite(currency),
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