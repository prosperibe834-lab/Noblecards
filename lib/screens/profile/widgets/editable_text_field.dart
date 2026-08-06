import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';

class EditableTextField extends StatefulWidget {
  final String label;
  final String value;
  final IconData leadingIcon;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool isDropdown;
  final bool isMultiline;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const EditableTextField({
    super.key,
    required this.label,
    required this.value,
    required this.leadingIcon,
    this.onChanged,
    this.onTap,
    this.isDropdown = false,
    this.isMultiline = false,
    this.keyboardType,
    this.validator,
  });

  @override
  State<EditableTextField> createState() => _EditableTextFieldState();
}

class _EditableTextFieldState extends State<EditableTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant EditableTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: _controller,
        readOnly: widget.isDropdown,
        onTap: widget.onTap,
        onChanged: widget.onChanged,
        maxLines: widget.isMultiline ? 2 : 1,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : Colors.black87,
        ),
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(
            widget.leadingIcon,
            color: AppColors.success,
            size: 20,
          ),
          suffixIcon: widget.isDropdown
              ? Icon(
                  Boxicons.bx_chevron_down,
                  color: isDark ? Colors.white54 : Colors.black54,
                  size: 20,
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          filled: true,
          fillColor: isDark ? AppColors.darkCard : AppColors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? Colors.white10 : Colors.grey.shade300,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.success,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.error,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.error,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}