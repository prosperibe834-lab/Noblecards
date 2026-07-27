import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../theme/app_theme.dart';
import '../theme/app_radius.dart';


import '../theme/app_colors.dart';

import '../theme/app_spacing.dart';

class PinInputWidget extends StatefulWidget {
  final Function(String pin) onCompleted;
  final VoidCallback? onForgotPin;

  const PinInputWidget({
    super.key,
    required this.onCompleted,
    this.onForgotPin,
  });

  @override
  State<PinInputWidget> createState() => _PinInputWidgetState();
}

class _PinInputWidgetState extends State<PinInputWidget> {
  String _pin = '';

  void _onKeyPress(String val) {
    if (_pin.length < 4) {
      setState(() {
        _pin += val;
      });
      if (_pin.length == 4) {
        widget.onCompleted(_pin);
      }
    }
  }

  void _onDelete() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            final isFilled = index < _pin.length;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isFilled
                    ? AppColors.primary
                    : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
            );
          }),
        ),
        const SizedBox(height: AppSpacing.xl),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.5,
          ),
          itemCount: 12,
          itemBuilder: (context, index) {
            if (index == 9) {
              return IconButton(
                icon: const Icon(Boxicons.bx_fingerprint, size: 28),
                onPressed: widget.onForgotPin,
              );
            }
            if (index == 10) {
              return _buildKey('0', isDark);
            }
            if (index == 11) {
              return IconButton(
                icon: const Icon(Boxicons.bx_left_arrow_alt, size: 24),
                onPressed: _onDelete,
              );
            }
            return _buildKey('${index + 1}', isDark);
          },
        ),
      ],
    );
  }

  Widget _buildKey(String val, bool isDark) {
    return InkWell(
      onTap: () => _onKeyPress(val),
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: Center(
        child: Text(
          val,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
      ),
    );
  }
}
