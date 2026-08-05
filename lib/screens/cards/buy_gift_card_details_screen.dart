import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boxicons/boxicons.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import './models/purchased_gift_card.dart';

class GiftCardDetailsScreen extends StatefulWidget {
  final PurchasedGiftCard card;

  const GiftCardDetailsScreen({super.key, required this.card});

  @override
  State<GiftCardDetailsScreen> createState() => _GiftCardDetailsScreenState();
}

class _GiftCardDetailsScreenState extends State<GiftCardDetailsScreen> {
  bool _isCodeVisible = false;
  bool _isPinVisible = false;

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label copied to clipboard!'), behavior: SnackBarBehavior.floating),
    );
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
          'Card Details',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Boxicons.bx_share_alt, color: isDark ? Colors.white : Colors.black),
            onPressed: () {
              // Implement Share Plus logic
            },
          ),
          IconButton(
            icon: Icon(Boxicons.bx_heart, color: isDark ? Colors.white : Colors.black),
            onPressed: () {
              // Implement Favorite logic
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Preview Card Design
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                gradient: const LinearGradient(
                  colors: [Colors.black87, Colors.black],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 15, offset: const Offset(0, 8)),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 20,
                    left: 20,
                    child: Row(
                      children: [
                        const Icon(Boxicons.bxl_amazon, color: Colors.orange, size: 32),
                        const SizedBox(width: 8),
                        Text(
                          widget.card.brandName,
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Text(
                      '\$${widget.card.faceValue.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: Row(
                      children: [
                        const Text('🇺🇸', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Text(widget.card.region, style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Card Code Section
            _buildSecureField(
              context,
              label: 'Gift Card Code',
              value: widget.card.cardCode,
              isVisible: _isCodeVisible,
              onToggleVisibility: () => setState(() => _isCodeVisible = !_isCodeVisible),
              onCopy: () => _copyToClipboard(widget.card.cardCode, 'Code'),
            ),
            
            const SizedBox(height: 20),

            // Pin Section (If applicable)
            if (widget.card.pin != null) ...[
              _buildSecureField(
                context,
                label: 'Card PIN',
                value: widget.card.pin!,
                isVisible: _isPinVisible,
                onToggleVisibility: () => setState(() => _isPinVisible = !_isPinVisible),
                onCopy: () => _copyToClipboard(widget.card.pin!, 'PIN'),
              ),
              const SizedBox(height: 32),
            ],

            // Security Notice
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Boxicons.bx_error_circle, color: Colors.amber, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Never share your card code or PIN with anyone. NobleCards will never ask for these details.',
                      style: TextStyle(fontSize: 12, color: Colors.amber, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecureField(
    BuildContext context, {
    required String label,
    required String value,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
    required VoidCallback onCopy,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkSubText : AppColors.lightSubText, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  isVisible ? value : '•' * value.length,
                  style: TextStyle(
                    fontSize: isVisible ? 16 : 24,
                    letterSpacing: isVisible ? 2.0 : 4.0,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(isVisible ? Boxicons.bx_hide : Boxicons.bx_show, color: isDark ? Colors.white54 : Colors.black54),
                onPressed: onToggleVisibility,
              ),
              Container(width: 1, height: 24, color: isDark ? Colors.white24 : Colors.black12, margin: const EdgeInsets.symmetric(horizontal: 8)),
              IconButton(
                icon: const Icon(Boxicons.bx_copy, color: AppColors.success),
                onPressed: onCopy,
              ),
            ],
          ),
        ),
      ],
    );
  }
}