import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boxicons/boxicons.dart';
import 'package:noble_cards/theme/app_colors.dart';
import 'package:noble_cards/theme/app_radius.dart';
import 'package:noble_cards/theme/app_spacing.dart';
import 'package:noble_cards/theme/app_animation.dart';

class VerificationNotice extends StatelessWidget {
  final bool accepted;
  final ValueChanged<bool> onChanged;

  const VerificationNotice({
    super.key,
    required this.accepted,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subTextColor = isDark ? AppColors.darkSubText : AppColors.lightSubText;

    // Fintech card styling for light & dark modes
    final cardBg = isDark
        ? (accepted
            ? const Color(0xFF132A27) // Subtle dark emerald tint
            : AppColors.darkCard)
        : (accepted
            ? const Color(0xFFF0FDF4) // Soft mint green
            : Colors.white);

    final borderColor = accepted
        ? AppColors.primary.withValues(alpha: 0.8)
        : (isDark
            ? AppColors.darkBorder
            : AppColors.lightBorder);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onChanged(!accepted);
        },
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: AnimatedContainer(
          duration: AppAnimation.fast,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: borderColor,
              width: accepted ? 1.6 : 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: accepted
                    ? AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.12)
                    : Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                blurRadius: accepted ? 16 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shield Security Badge
              AnimatedContainer(
                duration: AppAnimation.normal,
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accepted
                      ? AppColors.primary.withValues(alpha: 0.16)
                      : (isDark
                          ? AppColors.darkBorder.withValues(alpha: 0.5)
                          : const Color(0xFFF1F5F9)),
                  border: Border.all(
                    color: accepted
                        ? AppColors.primary.withValues(alpha: 0.4)
                        : Colors.transparent,
                    width: 1.2,
                  ),
                ),
                child: Icon(
                  accepted ? Boxicons.bx_check_shield : Boxicons.bx_shield_quarter,
                  color: accepted
                      ? AppColors.primary
                      : (isDark ? AppColors.darkSubText : AppColors.lightSubText),
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              // Notice Agreement Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Verification Notice',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: accepted ? AppColors.primary : textColor,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: (accepted ? AppColors.primary : AppColors.accent)
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            accepted ? 'ACCEPTED' : 'REQUIRED',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: accepted ? AppColors.primary : AppColors.accent,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'I understand that every submitted gift card will be verified by NobleCards before approval.',
                      style: TextStyle(
                        color: textColor.withValues(alpha: 0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Processing takes ~2–5 minutes. Settlement is credited directly to your wallet.',
                      style: TextStyle(
                        color: subTextColor,
                        fontSize: 11,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),

              // Animated Checkbox Ring
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: AnimatedContainer(
                  duration: AppAnimation.fast,
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accepted ? AppColors.primary : Colors.transparent,
                    border: Border.all(
                      color: accepted
                          ? AppColors.primary
                          : (isDark
                              ? AppColors.darkBorder
                              : const Color(0xFFCBD5E1)),
                      width: 2,
                    ),
                    boxShadow: accepted
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: accepted
                      ? const Center(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

