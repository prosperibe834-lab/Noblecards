import 'package:flutter/material.dart';
import 'package:noble_cards/theme/app_colors.dart';
import 'package:noble_cards/theme/app_radius.dart';
import 'package:noble_cards/theme/app_spacing.dart';
import 'amount_input.dart';
import 'card_code_input.dart';

class DigitalCardSection extends StatelessWidget {
  final bool isPhysical;

  const DigitalCardSection({super.key, required this.isPhysical});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        AmountInput(),
        SizedBox(height: AppSpacing.md),
        CardCodeInput(),
      ],
    );
  }
}
