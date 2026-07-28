import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../theme/app_theme.dart';
import '../theme/app_radius.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'animated_counter.dart';

class WalletBalanceCard extends StatefulWidget {
  final double balance;
  final VoidCallback onDeposit;
  final VoidCallback onWithdraw;
  final String? accountNumber;
  final VoidCallback? onCopyAccount;

  const WalletBalanceCard({
    super.key,
    required this.balance,
    required this.onDeposit,
    required this.onWithdraw,
    this.accountNumber,
    this.onCopyAccount,
  });

  @override
  State<WalletBalanceCard> createState() => _WalletBalanceCardState();
}

class _WalletBalanceCardState extends State<WalletBalanceCard> {
  bool _hideBalance = false;

  @override
  Widget build(BuildContext context) {
    // Custom fintech accent colors
    const chipGold = Color(0xFFFFD700);
    const glowOverlay = Color(
      0xFF7B2CBF,
    ); // Vibrant indigo-purple gradient glow

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: -2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Stack(
          children: [
            // 1. Premium Multi-stop Gradient Background
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryDark,
                      AppColors.primary,
                      glowOverlay,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),

            // 2. Decorative Glassmorphic Background Shapes
            Positioned(
              top: -40,
              right: -30,
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              left: -20,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),

            // 3. Card Inner Content
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header Row: Wallet Title & Contactless + Toggle Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                            ),
                            child: const Icon(
                              Boxicons.bx_wallet,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          const Text(
                            'Main Balance',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),

                      // Contactless Signal + Hide/Show Eye Button
                      Row(
                        children: [
                          Transform.rotate(
                            angle: 1.5708, // Rotated for NFC style
                            child: Icon(
                              Boxicons.bx_wifi,
                              color: Colors.white.withOpacity(0.4),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _hideBalance = !_hideBalance;
                              });
                            },
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _hideBalance
                                    ? Boxicons.bx_hide
                                    : Boxicons.bx_show,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // EMV Smart Chip & Optional Account Copy Pill
                  Row(
                    children: [
                      // Gold EMV Chip UI
                      Container(
                        width: 36,
                        height: 26,
                        decoration: BoxDecoration(
                          color: chipGold.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.amber.shade200,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Boxicons.bx_chip,
                            size: 20,
                            color: Colors.brown.shade900,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),

                      // Account Number Tag (If provided)
                      if (widget.accountNumber != null)
                        InkWell(
                          onTap: widget.onCopyAccount,
                          borderRadius: BorderRadius.circular(AppRadius.xs),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.xs + 2,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(AppRadius.xs),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.15),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.accountNumber!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Boxicons.bx_copy,
                                  color: Colors.white70,
                                  size: 12,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Balance Display (Star icons when hidden)
                  _hideBalance
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Row(
                            children: List.generate(
                              5,
                              (index) => const Padding(
                                padding: EdgeInsets.only(right: 6.0),
                                child: Icon(
                                  Boxicons.bxs_star,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        )
                      : AnimatedCounter(
                          value: widget.balance,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),

                  const SizedBox(height: AppSpacing.lg),

                  // Action Buttons (Add Money & Transfer)
                  Row(
                    children: [
                      // Add Money Button
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: ElevatedButton.icon(
                            onPressed: widget.onDeposit,
                            icon: const Icon(Boxicons.bx_plus, size: 20),
                            label: const Text(
                              'Deposit',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primaryDark,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.md,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: AppSpacing.sm),

                      // Transfer / Withdraw Button
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: OutlinedButton.icon(
                            onPressed: widget.onWithdraw,
                            icon: const Icon(
                              Boxicons.bx_transfer_alt,
                              size: 18,
                            ),
                            label: const Text(
                              'Withdraw',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.white.withOpacity(0.12),
                              side: BorderSide(
                                color: Colors.white.withOpacity(0.3),
                                width: 1.2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.md,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

