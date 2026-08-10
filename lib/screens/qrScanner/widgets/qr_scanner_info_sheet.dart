import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';

class QrScannerInfoSheet extends StatelessWidget {
  const QrScannerInfoSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkCard : AppColors.white;
    final textColor = isDark ? AppColors.darkText : AppColors.textPrimary;
    final subTextColor = isDark ? AppColors.darkSubText : AppColors.textSecondary;
    final iconBgColor = isDark ? const Color(0xFF192025) : const Color(0xFFF3FBF7);
    final highlightBgColor = isDark ? const Color(0xFF102E18) : const Color(0xFFEFF9F1);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.82,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.l),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'How QR Scanning Works',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF111827) : const Color(0xFFF3F4F6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Boxicons.bx_x,
                        size: 20,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Scan a QR code to quickly identify and access supported NobleCards information.',
                style: TextStyle(
                  color: subTextColor,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: AppSpacing.l),
              _buildFeatureItem(
                icon: Boxicons.bx_qr_scan,
                label: 'Scan a QR Code',
                description:
                    'Point your camera at a supported QR code. Keep the code inside the scanning frame for the best result.',
                iconBgColor: iconBgColor,
                textColor: textColor,
                subTextColor: subTextColor,
              ),
              const SizedBox(height: AppSpacing.md),
              _buildFeatureItem(
                icon: Boxicons.bx_credit_card,
                label: 'Identify Your Card',
                description:
                    'When NobleCards recognizes a supported card QR code, we\'ll identify the card and show you the relevant card information.',
                iconBgColor: iconBgColor,
                textColor: textColor,
                subTextColor: subTextColor,
              ),
              const SizedBox(height: AppSpacing.md),
              _buildFeatureItem(
                icon: Boxicons.bx_credit_card_front,
                label: 'Open Card Details',
                description:
                    'After a successful scan, you can open the identified card and continue with the available action.',
                iconBgColor: iconBgColor,
                textColor: textColor,
                subTextColor: subTextColor,
              ),
              const SizedBox(height: AppSpacing.md),
              _buildFeatureItem(
                icon: Boxicons.bx_shield_quarter,
                label: 'Your Privacy & Security',
                description:
                    'Only supported QR codes are processed. Never scan QR codes you don\'t trust.',
                iconBgColor: iconBgColor,
                textColor: textColor,
                subTextColor: subTextColor,
              ),
              const SizedBox(height: AppSpacing.l),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: highlightBgColor,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: isDark ? Colors.white10 : const Color(0xFFE5F4EA),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scan Safely',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Only scan QR codes from trusted sources. NobleCards will never ask you to scan an unknown QR code to receive a reward or payment.',
                      style: TextStyle(
                        color: subTextColor,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String label,
    required String description,
    required Color iconBgColor,
    required Color textColor,
    required Color subTextColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: const Color(0xFF10B981), size: 24),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                description,
                style: TextStyle(
                  color: subTextColor,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
