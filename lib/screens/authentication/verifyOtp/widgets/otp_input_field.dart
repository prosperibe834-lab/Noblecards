import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../theme/app_colors.dart';

class OtpInputField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onCompleted;

  const OtpInputField({
    super.key,
    required this.onChanged,
    required this.onCompleted,
  });

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  final int _length = 6;
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(_length, (index) => FocusNode());
    _controllers = List.generate(_length, (index) => TextEditingController());

    for (int i = 0; i < _length; i++) {
      _focusNodes[i].addListener(() {
        setState(() {}); // Trigger rebuild for border color changes
      });
    }
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.length > 1) {
      // Handle paste
      _handlePaste(value);
      return;
    }

    _notifyChange();

    if (value.isNotEmpty && index < _length - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isNotEmpty && index == _length - 1) {
      _focusNodes[index].unfocus();
      widget.onCompleted();
    }
  }

  void _handlePaste(String pastedText) {
    final digits = pastedText.replaceAll(RegExp(r'[^0-9]'), '').split('');
    for (int i = 0; i < _length; i++) {
      if (i < digits.length) {
        _controllers[i].text = digits[i];
      } else {
        _controllers[i].text = '';
      }
    }
    _notifyChange();
    if (digits.length >= _length) {
      _focusNodes.last.unfocus();
      widget.onCompleted();
    } else {
      _focusNodes[digits.length].requestFocus();
    }
  }

  void _onKeyEvent(RawKeyEvent event, int index) {
    if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controllers[index].text.isEmpty && index > 0) {
        _focusNodes[index - 1].requestFocus();
        _controllers[index - 1].text = '';
        _notifyChange();
      }
    }
  }

  void _notifyChange() {
    String currentOtp = _controllers.map((c) => c.text).join();
    widget.onChanged(currentOtp);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_length, (index) {
        final bool isFocused = _focusNodes[index].hasFocus;
        
        final Color bgColor = isDark ? AppColors.darkInput : AppColors.lightInput;
        final Color defaultBorderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
        final Color activeBorderColor = AppColors.primary;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: MediaQuery.of(context).size.width * 0.12,
          height: MediaQuery.of(context).size.width * 0.14,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isFocused ? activeBorderColor : defaultBorderColor,
              width: isFocused ? 2.0 : 1.0,
            ),
          ),
          child: Center(
            child: RawKeyboardListener(
              focusNode: FocusNode(),
              onKey: (event) => _onKeyEvent(event, index),
              child: TextFormField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  counterText: "",
                ),
                onChanged: (value) => _onChanged(value, index),
              ),
            ),
          ),
        );
      }),
    );
  }
}