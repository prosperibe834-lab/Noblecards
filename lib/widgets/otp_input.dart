import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onCompleted;

  const OtpInput({
    super.key,
    required this.controller,
    required this.onCompleted,
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
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: 6,
            autofocus: true,
            onChanged: (val) {
              if (val.length == 6) onCompleted(val);
            },
            decoration: const InputDecoration(counterText: ""),
          ),
        ),
        AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            final text = controller.text;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                final isFilled = text.length > index;
                final isFocused = text.length == index;
                
                return Container(
                  width: 50,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1A1F26) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isFocused
                          ? const Color(0xFF00C853)
                          : isFilled
                              ? (isDark ? Colors.white38 : Colors.black26)
                              : (isDark ? Colors.white10 : Colors.black12),
                      width: isFocused || isFilled ? 1.5 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      isFilled ? text[index] : '',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ],
    );
  }
}