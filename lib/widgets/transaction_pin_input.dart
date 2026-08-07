import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransactionPinInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasError;
  final Function(String)? onChanged;

  const TransactionPinInput({
    super.key,
    required this.controller,
    required this.focusNode,
    this.hasError = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        Opacity(
          opacity: 0.0,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: 4,
            onChanged: onChanged,
            decoration: const InputDecoration(counterText: ""),
          ),
        ),
        GestureDetector(
          onTap: () => focusNode.requestFocus(),
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              final text = controller.text;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (index) {
                  final isFilled = text.length > index;
                  final isFocused = text.length == index && focusNode.hasFocus;
                  
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1A1F26) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: hasError
                            ? Colors.red
                            : isFocused
                                ? const Color(0xFF00C853)
                                : isFilled
                                    ? (isDark ? Colors.white38 : Colors.black26)
                                    : (isDark ? Colors.white10 : Colors.black12),
                        width: isFocused || isFilled ? 1.5 : 1,
                      ),
                      boxShadow: isFocused
                          ? [
                              BoxShadow(
                                color: const Color(0xFF00C853).withOpacity(0.1),
                                blurRadius: 8,
                                spreadRadius: 2,
                              )
                            ]
                          : [],
                    ),
                    child: Center(
                      child: AnimatedScale(
                        scale: isFilled ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 150),
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white : const Color(0xFF0D1630),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ],
    );
  }
}