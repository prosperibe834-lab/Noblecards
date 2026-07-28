import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class DepositStepIndicator extends StatelessWidget {
  final int currentStep; // 1: Amount & Currency, 2: Payment Method, 3: Confirmation
  final int totalSteps;

  const DepositStepIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 3,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final steps = [
      {"num": 1, "label": "Amount", "icon": Boxicons.bx_wallet},
      {"num": 2, "label": "Method", "icon": Boxicons.bx_credit_card},
      {"num": 3, "label": "Confirm", "icon": Boxicons.bx_check_shield},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: List.generate(steps.length, (index) {
          final stepNum = steps[index]["num"] as int;
          final isDone = stepNum < currentStep;
          final isCurrent = stepNum == currentStep;

          return Expanded(
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone || isCurrent
                        ? primaryColor
                        : (isDark ? Colors.white10 : Colors.grey.shade200),
                    boxShadow: isCurrent
                        ? [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            )
                          ]
                        : [],
                  ),
                  child: Center(
                    child: isDone
                        ? const Icon(Boxicons.bx_check, color: Colors.white, size: 18)
                        : Text(
                            "$stepNum",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: isCurrent
                                  ? Colors.white
                                  : (isDark ? Colors.white38 : Colors.black45),
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  steps[index]["label"] as String,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    color: isCurrent
                        ? primaryColor
                        : (isDark ? Colors.white54 : Colors.black54),
                  ),
                ),
                if (index < steps.length - 1)
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      height: 2,
                      color: isDone
                          ? primaryColor
                          : (isDark ? Colors.white10 : Colors.grey.shade200),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}