import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';

class PasswordInputField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool isObscured;
  final VoidCallback onToggleVisibility;
  final ValueChanged<String> onChanged;

  const PasswordInputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.isObscured,
    required this.onToggleVisibility,
    required this.onChanged,
  });

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDark ? AppColors.darkInput : AppColors.lightInput;
    final Color borderColor = _isFocused 
        ? AppColors.primary 
        : (isDark ? AppColors.darkBorder : AppColors.lightBorder);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: _isFocused ? 1.5 : 1.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Leading Icon
          Icon(
            Boxicons.bx_lock_alt,
            color: _isFocused ? AppColors.primary : AppColors.primaryDark.withOpacity(0.7),
            size: 24,
          ),
          const SizedBox(width: 16),
          
          // Two-Line Input
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                SizedBox(
                  height: 24, // Fixed height to prevent shifting
                  child: TextFormField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    obscureText: widget.isObscured,
                    onChanged: widget.onChanged,
                    style: Theme.of(context).textTheme.bodyLarge,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Trailing Visibility Toggle
          IconButton(
            icon: Icon(
              widget.isObscured ? Boxicons.bx_show : Boxicons.bx_hide,
              color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
              size: 24,
            ),
            onPressed: widget.onToggleVisibility,
            splashRadius: 24,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}