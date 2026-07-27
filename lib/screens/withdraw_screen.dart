import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';

import '../theme/app_colors.dart';

import '../theme/app_spacing.dart';

class WithdrawScreen extends StatelessWidget {
  const WithdrawScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: const CustomAppBar(title: 'Withdraw Funds'),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Amount to Withdraw (\$)',
                filled: true,
                fillColor: isDark ? AppColors.darkCard : AppColors.lightCard,
              ),
            ),
            const Spacer(),
            CustomButton(
              text: 'Withdraw Now',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
