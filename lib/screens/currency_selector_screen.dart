import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class CurrencySelectorScreen extends StatefulWidget {
  const CurrencySelectorScreen({super.key});

  @override
  State<CurrencySelectorScreen> createState() => _CurrencySelectorScreenState();
}

class _CurrencySelectorScreenState extends State<CurrencySelectorScreen> {
  final String _query = "";
  final List<Map<String, String>> _allCurrencies = [
    {"code": "NGN", "name": "Nigerian Naira", "flag": "🇳🇬"},
    {"code": "GBP", "name": "British Pound", "flag": "🇬🇧"},
    {"code": "GHS", "name": "Ghanaian Cedi", "flag": "🇬🇭"},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filtered = _allCurrencies.where((item) {
      final q = _query.toLowerCase();
      return item["code"]!.toLowerCase().contains(q) ||
             item["name"]!.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Deposit Currency", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Boxicons.bx_search),
                hintText: "Search currency or country...",
                filled: true,
                fillColor: isDark ? Colors.white10 : Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) => setState(() {}),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final curr = filtered[index];
                return ListTile(
                  leading: Text(curr["flag"]!, style: const TextStyle(fontSize: 26)),
                  title: Text(curr["code"]!, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
                  subtitle: Text(curr["name"]!, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12)),
                  trailing: const Icon(Boxicons.bx_chevron_right),
                  onTap: () => Navigator.pop(context, curr),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}