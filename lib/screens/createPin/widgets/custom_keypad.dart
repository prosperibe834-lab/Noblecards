import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_shadow.dart';
import '../../../theme/app_spacing.dart';
import '../providers/create_pin_provider.dart';

class CustomKeypad extends StatelessWidget {
  const CustomKeypad({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRow(context, [
            _KeypadKey('1', ''), _KeypadKey('2', 'ABC'), _KeypadKey('3', 'DEF')
          ]),
          const SizedBox(height: AppSpacing.sm),
          _buildRow(context, [
            _KeypadKey('4', 'GHI'), _KeypadKey('5', 'JKL'), _KeypadKey('6', 'MNO')
          ]),
          const SizedBox(height: AppSpacing.sm),
          _buildRow(context, [
            _KeypadKey('7', 'PQRS'), _KeypadKey('8', 'TUV'), _KeypadKey('9', 'WXYZ')
          ]),
          const SizedBox(height: AppSpacing.sm),
          _buildRow(context, [
            _EmptyKey(), _KeypadKey('0', ''), _BackspaceKey()
          ]),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, List<Widget> children) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children.map((child) => Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: child,
        ),
      )).toList(),
    );
  }
}

class _KeypadKey extends StatelessWidget {
  final String number;
  final String letters;

  const _KeypadKey(this.number, this.letters);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return InkWell(
      onTap: () => context.read<CreatePinProvider>().addDigit(number),
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkInput : AppColors.lightInput,
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: isDarkMode ? [] : AppShadow.light,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              number,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 24,
                height: letters.isEmpty ? 1.5 : 1.1,
              ),
            ),
            if (letters.isNotEmpty)
              Text(
                letters,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: isDarkMode ? AppColors.darkSubText : AppColors.lightSubText,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BackspaceKey extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return InkWell(
      onTap: () => context.read<CreatePinProvider>().removeDigit(),
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Icon(
          Boxicons.bx_message_square_x,
          size: 28,
          color: isDarkMode ? AppColors.darkText : AppColors.lightText,
        ),
      ),
    );
  }
}

class _EmptyKey extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const SizedBox(height: 56);
}