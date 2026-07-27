import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../theme/app_theme.dart';
import '../theme/app_radius.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import 'deposit_success_screen.dart';

import '../theme/app_colors.dart';

import '../theme/app_spacing.dart';

class DepositPaymentScreen extends StatelessWidget {
  const DepositPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: const CustomAppBar(title: 'Virtual Account'),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Column(
                children: [
                  const Text('Flutterwave Bank Virtual Account'),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    '0123456789',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  const Text('NobleCards - John Doe'),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Boxicons.bx_copy, size: 16),
                        label: const Text('Copy Account'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            CustomButton(
              text: 'I Have Made Payment',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const DepositSuccessScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
