import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';

class PinNumericKeypad extends StatelessWidget {
  final ValueChanged<String> onKeyPress;
  final VoidCallback onDelete;
  final bool isDisabled;

  const PinNumericKeypad({
    super.key,
    required this.onKeyPress,
    required this.onDelete,
    this.isDisabled = false,
  });

  static const List<Map<String, String>> _keys = [
    {'number': '1', 'letters': ''},
    {'number': '2', 'letters': 'ABC'},
    {'number': '3', 'letters': 'DEF'},
    {'number': '4', 'letters': 'GHI'},
    {'number': '5', 'letters': 'JKL'},
    {'number': '6', 'letters': 'MNO'},
    {'number': '7', 'letters': 'PQRS'},
    {'number': '8', 'letters': 'TUV'},
    {'number': '9', 'letters': 'WXYZ'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Rows 1-3
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 9,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.85,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final keyData = _keys[index];
            return _KeypadButton(
              number: keyData['number']!,
              letters: keyData['letters']!,
              isDark: isDark,
              isDisabled: isDisabled,
              onTap: () {
                HapticFeedback.lightImpact();
                onKeyPress(keyData['number']!);
              },
            );
          },
        ),
        const SizedBox(height: 10),

        // Bottom Row: Empty Spacer | 0 | Delete
        Row(
          children: [
            const Expanded(child: SizedBox()),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 52,
                child: _KeypadButton(
                  number: '0',
                  letters: '',
                  isDark: isDark,
                  isDisabled: isDisabled,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onKeyPress('0');
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 52,
                child: Material(
                  color: isDark ? AppColors.darkInput : Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    onTap: isDisabled
                        ? null
                        : () {
                            HapticFeedback.mediumImpact();
                            onDelete();
                          },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.backspace_outlined,
                          size: 20,
                          color: isDark
                              ? AppColors.darkText
                              : AppColors.lightText,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _KeypadButton extends StatelessWidget {
  final String number;
  final String letters;
  final bool isDark;
  final bool isDisabled;
  final VoidCallback onTap;

  const _KeypadButton({
    required this.number,
    required this.letters,
    required this.isDark,
    required this.isDisabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDark ? AppColors.darkInput : Colors.white,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: isDisabled ? null : onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                number,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                  height: 1.1,
                ),
              ),
              if (letters.isNotEmpty) ...[
                const SizedBox(height: 1),
                Text(
                  letters,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}