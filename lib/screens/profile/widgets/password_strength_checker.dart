import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';

class PasswordStrengthChecker extends StatelessWidget {
  final String password;

  const PasswordStrengthChecker({Key? key, required this.password}) : super(key: key);

  bool get _hasMinLength => password.length >= 8;
  bool get _hasNumber => password.contains(RegExp(r'[0-9]'));
  bool get _hasUppercase => password.contains(RegExp(r'[A-Z]'));
  bool get _hasSpecial => password.contains(RegExp(r'[!@#\$&*~%,.?;:\-_+]'));

  int get _strengthScore {
    if (password.isEmpty) return 0;
    int score = 0;
    if (_hasMinLength) score++;
    if (_hasNumber) score++;
    if (_hasUppercase) score++;
    if (_hasSpecial) score++;
    return score;
  }

  String get _strengthLabel {
    switch (_strengthScore) {
      case 0: return 'None';
      case 1: return 'Weak';
      case 2: return 'Fair';
      case 3: return 'Good';
      case 4: return 'Strong';
      default: return 'None';
    }
  }

  Color _getStrengthColor(int score, bool isDark) {
    if (score == 0) return isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    if (score <= 1) return Colors.redAccent;
    if (score == 2) return Colors.orangeAccent;
    if (score == 3) return const Color(0xFF34D399); // Lighter green
    return const Color(0xFF10B981); // Strong primary green
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final activeGreen = const Color(0xFF10B981);
    
    final int score = _strengthScore;
    final Color currentColor = _getStrengthColor(score, isDark);
    
    // 5 segments calculation based on the 4 criteria
    int activeSegments = score == 4 ? 5 : score;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Strength Label
        Row(
          children: [
            Text(
              'Password strength: ',
              style: TextStyle(
                color: primaryTextColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              _strengthLabel,
              style: TextStyle(
                color: currentColor,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Strength Bars
        Row(
          children: List.generate(5, (index) {
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 4,
                margin: EdgeInsets.only(right: index == 4 ? 0 : 4),
                decoration: BoxDecoration(
                  color: index < activeSegments
                      ? currentColor
                      : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),

        // Checklist requirements (2x2 Grid)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  _RequirementItem(
                    label: 'At least 8 characters',
                    isMet: _hasMinLength,
                    activeColor: activeGreen,
                    inactiveColor: secondaryTextColor,
                  ),
                  const SizedBox(height: 10),
                  _RequirementItem(
                    label: 'One uppercase letter',
                    isMet: _hasUppercase,
                    activeColor: activeGreen,
                    inactiveColor: secondaryTextColor,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  _RequirementItem(
                    label: 'One number',
                    isMet: _hasNumber,
                    activeColor: activeGreen,
                    inactiveColor: secondaryTextColor,
                  ),
                  const SizedBox(height: 10),
                  _RequirementItem(
                    label: 'One special character',
                    isMet: _hasSpecial,
                    activeColor: activeGreen,
                    inactiveColor: secondaryTextColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RequirementItem extends StatelessWidget {
  final String label;
  final bool isMet;
  final Color activeColor;
  final Color inactiveColor;

  const _RequirementItem({
    required this.label,
    required this.isMet,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            isMet ? Boxicons.bxs_check_circle : Boxicons.bx_check_circle,
            key: ValueKey<bool>(isMet),
            color: isMet ? activeColor : inactiveColor.withOpacity(0.5),
            size: 16,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: isMet ? activeColor : inactiveColor,
              fontSize: 12,
              fontWeight: isMet ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}