import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';

class ForgotPasswordEmailField extends StatefulWidget {
  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  const ForgotPasswordEmailField({
    super.key,
    required this.controller,
    this.errorText,
    this.onChanged,
    this.enabled = true,
  });

  @override
  State<ForgotPasswordEmailField> createState() => _ForgotPasswordEmailFieldState();
}

class _ForgotPasswordEmailFieldState extends State<ForgotPasswordEmailField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    final Color bgColor = isDark ? AppColors.darkInput : AppColors.lightInput;
    final Color iconBgColor = AppColors.primary.withOpacity(isDark ? 0.15 : 0.08);

    BorderSide borderSide;
    if (hasError) {
      borderSide = const BorderSide(color: AppColors.error, width: 1.5);
    } else if (_focusNode.hasFocus) {
      borderSide = const BorderSide(color: AppColors.primary, width: 1.5);
    } else {
      borderSide = BorderSide(
        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        width: 1.0,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderSide.color,
              width: borderSide.width,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          child: Row(
            children: [
              // Envelope Icon Container Box
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Boxicons.bx_envelope,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),

              // Email TextField Input
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  onChanged: widget.onChanged,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? AppColors.darkSubText.withOpacity(0.6)
                              : AppColors.lightSubText.withOpacity(0.6),
                        ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Error Feedback Display
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 6),
            child: Row(
              children: [
                const Icon(Boxicons.bx_error_circle, color: AppColors.error, size: 14),
                const SizedBox(width: 4),
                Text(
                  widget.errorText!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.error,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}