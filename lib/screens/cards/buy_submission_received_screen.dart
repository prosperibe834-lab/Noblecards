import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boxicons/boxicons.dart';
import '../../theme/app_colors.dart'; // Adjust path to your theme
import '../../theme/app_radius.dart'; // Adjust path to your theme
import './widgets/buy_submission_info_card.dart';
import './widgets/buy_submission_status_card.dart';
import './widgets/buy_submission_action_buttons.dart';
import 'buy_gift_card_details_screen.dart';
import 'buy_receipt_screen.dart';
import 'models/purchased_gift_card.dart';

class BuySubmissionReceivedScreen extends StatefulWidget {
  const BuySubmissionReceivedScreen({super.key});

  @override
  State<BuySubmissionReceivedScreen> createState() => _BuySubmissionReceivedScreenState();
}

class _BuySubmissionReceivedScreenState extends State<BuySubmissionReceivedScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.4, 1.0, curve: Curves.easeIn)),
    );

    _animationController.forward();
    HapticFeedback.mediumImpact();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Boxicons.bx_arrow_back, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Submission Received',
          style: TextStyle(
            fontSize: 16, 
            fontWeight: FontWeight.w600, 
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              
              // Enhanced Animated Success Widget
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.success,
                            blurRadius: 20,
                            spreadRadius: -5,
                            offset: Offset(0, 8),
                          )
                        ],
                      ),
                      child: const Icon(Boxicons.bx_check, color: Colors.white, size: 48),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              Text(
                'Purchase Successful!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
              
              const SizedBox(height: 12),
              
              Text(
                'Your gift card has been successfully purchased.\nYou can now securely view your gift card details or download your receipt.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Status Chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.success.withValues(alpha: 0.1) : AppColors.success.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Boxicons.bx_time_five, color: AppColors.success, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Status: Completed',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.success : AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Details Card (GlassCard reusable pattern)
              const BuySubmissionInfoCard(),
              
              const SizedBox(height: 24),
              
              // Notice Card
              const BuySubmissionStatusCard(),
              
              const SizedBox(height: 32),
              
              // Action Buttons
              BuySubmissionActionButtons(
                onViewGiftCard: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GiftCardDetailsScreen(
                        card: PurchasedGiftCard(
                          referenceId: 'NC-2026-54231',
                          brandName: 'Amazon',
                          region: 'United States',
                          cardType: 'Digital',
                          quantity: 1,
                          faceValue: 100,
                          amountPaid: 95,
                          paymentMethod: 'Wallet',
                          purchaseDate: 'Today',
                          status: PurchaseStatus.completed,
                          cardCode: 'AMZ-2026-0001',
                          pin: '1234',
                          barcodeUrl: null,
                        ),
                      ),
                    ),
                  );
                },
                onViewReceipt: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BuyReceiptScreen(transactionId: 'NC-2026-54231')),
                  );
                },
                onDone: () {
                  HapticFeedback.mediumImpact();
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}