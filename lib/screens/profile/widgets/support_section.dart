import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class SupportSection extends StatelessWidget {
  const SupportSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Need help?", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
        const SizedBox(height: 8),
        Text("Our support team is here for you.", style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? AppColors.primary.withOpacity(0.15) : AppColors.successLight.withOpacity(0.15),
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            icon: const Icon(Boxicons.bx_message_rounded_dots, size: 20),
            label: const Text("Contact Support", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
          ),
        ),
      ],
    );
  }
}