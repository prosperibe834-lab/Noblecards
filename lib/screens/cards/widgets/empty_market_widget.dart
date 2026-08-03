import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class EmptyMarketWidget extends StatelessWidget {
  const EmptyMarketWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Column(
          children: [
            Icon(Icons.search_off_rounded, size: 56, color: AppColors.lightSubText),
            SizedBox(height: 12),
            Text(
              'No Cards Found',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'Try clearing your filters or search criteria.',
              style: TextStyle(fontSize: 12, color: AppColors.lightSubText),
            ),
          ],
        ),
      ),
    );
  }
}