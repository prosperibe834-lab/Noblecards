import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';

class MarketRatesHeader extends StatelessWidget {
  const MarketRatesHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back Button
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              shape: BoxShape.circle,
              border: isDark ? Border.all(color: AppColors.darkBorder) : null,
              boxShadow: isDark ? [] : [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))
              ],
            ),
            child: Icon(Boxicons.bx_chevron_left, color: Theme.of(context).textTheme.bodyLarge!.color),
          ),
        ),
        
        // Title & Live Indicator
        Column(
          children: [
            Text('Market Rates', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
            const SizedBox(height: 2),
            Row(
              children: [
                Text('Live rates for gift cards • ', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12)),
                const Text('Live', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
                const SizedBox(width: 4),
                Container(
                  width: 6, height: 6,
                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                )
              ],
            )
          ],
        ),

        // Notification Button
        GestureDetector(
          onTap: () {
            // Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen()));
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  shape: BoxShape.circle,
                  border: isDark ? Border.all(color: AppColors.darkBorder) : null,
                  boxShadow: isDark ? [] : [
                    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))
                  ],
                ),
                child: Icon(Boxicons.bx_bell, color: Theme.of(context).textTheme.bodyLarge!.color),
              ),
              Positioned(
                top: -2, right: -2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}