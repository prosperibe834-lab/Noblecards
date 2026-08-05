import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';

class OrderEmptyWidget extends StatelessWidget {
  final VoidCallback onGoToMarketplace;

  const OrderEmptyWidget({super.key, required this.onGoToMarketplace});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Boxicons.bx_receipt,
              size: 56,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No Orders Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your gift card purchases and sales will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onGoToMarketplace,
            icon: const Icon(Boxicons.bx_store_alt, size: 18),
            label: const Text('Go To Marketplace'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}