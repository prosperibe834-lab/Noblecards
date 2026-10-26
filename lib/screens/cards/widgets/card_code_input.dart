import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boxicons/boxicons.dart';
import 'package:noble_cards/theme/app_colors.dart';
import 'package:noble_cards/theme/app_radius.dart';
import 'package:noble_cards/theme/app_spacing.dart';

class CardCodeInput extends StatefulWidget {
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final String? brandSlug;
  final String? label;
  final String? helperText;

  const CardCodeInput({
    super.key,
    this.initialValue,
    this.onChanged,
    this.brandSlug,
    this.label,
    this.helperText,
  });

  @override
  State<CardCodeInput> createState() => _CardCodeInputState();
}

class _CardCodeInputState extends State<CardCodeInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void didUpdateWidget(covariant CardCodeInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != null && widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _hintForBrand(String? slug) {
    final lower = (slug ?? '').toLowerCase();
    if (lower.contains('apple')) return 'e.g. X-GIFT-USA-1234';
    if (lower.contains('amazon')) return 'e.g. AQ-GIFT-USA-1234';
    if (lower.contains('xbox')) return 'e.g. XBOX-GIFT-USA-TEST-123456';
    if (lower.contains('steam')) return 'e.g. STEAM-GIFT-1234';
    if (lower.contains('playstation') || lower.contains('psn')) return 'e.g. PLAY-USA-1234';
    return 'Enter redemption code';
  }

  Future<void> _pasteFromClipboard() async {
    HapticFeedback.mediumImpact();
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null && data!.text!.trim().isNotEmpty) {
      final text = data.text!.trim();
      _controller.text = text;
      widget.onChanged?.call(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkInput : AppColors.lightInput;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subTextColor = isDark ? AppColors.darkSubText : AppColors.lightSubText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.label ?? 'Card Code',
              style: TextStyle(
                color: textColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (widget.helperText != null)
              Text(
                widget.helperText!,
                style: TextStyle(
                  color: subTextColor,
                  fontSize: 11,
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              const Icon(
                Boxicons.bx_barcode,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: TextFormField(
                  controller: _controller,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    hintText: _hintForBrand(widget.brandSlug),
                    hintStyle: TextStyle(
                      color: isDark
                          ? AppColors.darkSubText.withValues(alpha: 0.5)
                          : AppColors.lightSubText.withValues(alpha: 0.5),
                      fontSize: 13,
                      letterSpacing: 0.2,
                    ),
                  ),
                  onChanged: widget.onChanged,
                ),
              ),
              if (_controller.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _controller.clear();
                    widget.onChanged?.call('');
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 14,
                        color: subTextColor,
                      ),
                    ),
                  ),
                ),
              InkWell(
                onTap: _pasteFromClipboard,
                borderRadius: BorderRadius.circular(AppRadius.full),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Boxicons.bx_paste, size: 14, color: AppColors.primary),
                      SizedBox(width: 4),
                      Text(
                        'Paste',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
