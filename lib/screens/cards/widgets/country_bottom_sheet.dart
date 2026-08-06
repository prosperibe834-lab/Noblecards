import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';

import '../providers/country_provider.dart';

class CountryBottomSheet extends StatefulWidget {
  const CountryBottomSheet({super.key});

  @override
  State<CountryBottomSheet> createState() => _CountryBottomSheetState();
}

class _CountryBottomSheetState extends State<CountryBottomSheet> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final countryProvider = context.watch<CountryProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filtered = countryProvider.countries.where((c) {
      return c.name.toLowerCase().contains(_search.toLowerCase());
    }).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Select Country',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            onChanged: (v) => setState(() => _search = v),
            decoration: InputDecoration(
              hintText: 'Search country...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: isDark ? AppColors.darkCard : AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.full),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final country = filtered[index];
                return ListTile(
                  leading: Text(country.flag, style: const TextStyle(fontSize: 20)),
                  title: Text(
                    country.name,
                    style: TextStyle(color: isDark ? AppColors.darkText : AppColors.lightText),
                  ),
                  onTap: () {
                      countryProvider.selectCountry(country);
                      Navigator.pop(context, country);
                    },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}