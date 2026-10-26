import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boxicons/boxicons.dart';
import 'package:noble_cards/theme/app_colors.dart';
import 'package:noble_cards/theme/app_radius.dart';
import 'package:noble_cards/theme/app_spacing.dart';
import 'package:noble_cards/theme/app_animation.dart';

class SubmitSellButton extends StatefulWidget {
  final bool enabled;
  final VoidCallback onTap;
  final bool isLoading;

  const SubmitSellButton({
    super.key,
    required this.enabled,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  State<SubmitSellButton> createState() => _SubmitSellButtonState();
}

class _SubmitSellButtonState extends State<SubmitSellButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    if (!widget.enabled || widget.isLoading) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _isPressed = true);
    });
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.enabled || widget.isLoading) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _isPressed = false);
    });
  }

  void _handleTapCancel() {
    if (!widget.enabled || widget.isLoading) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _isPressed = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final disabledBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final disabledBorder = isDark ? AppColors.darkBorder : const Color(0xFFCBD5E1);
    final disabledText = isDark ? AppColors.darkSubText.withValues(alpha: 0.5) : const Color(0xFF94A3B8);

    return AnimatedScale(
      scale: _isPressed ? 0.97 : 1.0,
      duration: AppAnimation.fast,
      curve: Curves.easeInOut,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.enabled && !widget.isLoading
            ? () {
                HapticFeedback.mediumImpact();
                widget.onTap();
              }
            : null,
        child: AnimatedContainer(
          duration: AppAnimation.normal,
          width: double.infinity,
          height: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            gradient: widget.enabled
                ? const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: widget.enabled ? null : disabledBg,
            border: widget.enabled
                ? Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.2)
                : Border.all(color: disabledBorder, width: 1),
            boxShadow: widget.enabled
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: isDark ? 0.4 : 0.3),
                      blurRadius: 22,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: widget.isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!widget.enabled) ...[
                        Icon(
                          Boxicons.bx_lock_alt,
                          color: disabledText,
                          size: 18,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      Text(
                        'Submit Cards for Verification',
                        style: TextStyle(
                          color: widget.enabled ? Colors.white : disabledText,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                      if (widget.enabled) ...[
                        const SizedBox(width: AppSpacing.sm),
                        const Icon(
                          Boxicons.bx_right_arrow_alt,
                          color: Colors.white,
                          size: 22,
                        ),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

