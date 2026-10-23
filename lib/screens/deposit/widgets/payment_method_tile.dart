// Location: lib/deposit/widgets/payment_method_tile.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/theme_provider.dart';
import '../models/payment_method.dart';
import '../providers/payment_method_provider.dart';

class PaymentMethodTile extends StatelessWidget {
  final PaymentMethod method;

  const PaymentMethodTile({super.key, required this.method});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaymentMethodProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    
    final isSelected = provider.selectedMethod?.id == method.id;

    return GestureDetector(
      onTap: () => provider.selectMethod(method),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: isSelected && isDark ? [
            BoxShadow(color: AppColors.primary.withOpacity(0.15), blurRadius: 15, offset: const Offset(0, 4))
          ] : null,
          border: Border.all(
            color: isSelected ? AppColors.primary : theme.dividerColor,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: method.iconBackgroundColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(method.icon, color: method.iconBackgroundColor, size: 24),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        method.title,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isDark ? AppColors.darkText : AppColors.lightText,
                        ),
                      ),
                      if (method.isRecommended) ...[
                        const SizedBox(width: AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(AppRadius.xs),
                          ),
                          child: const Text(
                            'Recommended',
                            style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ]
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    method.subtitle,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
