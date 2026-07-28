import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class AnalyticsCountryList extends StatelessWidget {
  const AnalyticsCountryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final countries = [
      {'country': 'United States', 'code': '🇺🇸', 'vol': '\$84,200', 'txns': '210'},
      {'country': 'United Kingdom', 'code': '🇬🇧', 'vol': '\$28,400', 'txns': '85'},
      {'country': 'Canada', 'code': '🇨🇦', 'vol': '\$14,900', 'txns': '42'},
      {'country': 'Nigeria', 'code': '🇳🇬', 'vol': '\$12,200', 'txns': '75'},
    ];

    return Column(
      children: countries.map((c) {
        return ListTile(
          leading: Text(c['code']!, style: const TextStyle(fontSize: 24)),
          title: Text(c['country']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          subtitle: Text('${c['txns']} Transactions', style: const TextStyle(fontSize: 11, color: Colors.grey)),
          trailing: Text(c['vol']!, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
        );
      }).toList(),
    );
  }
}