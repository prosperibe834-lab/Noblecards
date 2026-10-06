import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boxicons/boxicons.dart';
import 'package:share_plus/share_plus.dart'; // Standard sharing plugin for frontend download shim

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_animation.dart';
import '../services/gift_card_details_service.dart';
import 'models/gift_card_details_model.dart';
import 'widgets/gift_card_components.dart';
import 'widgets/gift_card_skeleton.dart';

class GiftCardDetailsScreen extends StatefulWidget {
  final String? purchaseId;
  final GiftCardDetailsModel? giftCardData;

  const GiftCardDetailsScreen({
    Key? key,
    this.purchaseId,
    this.giftCardData,
  }) : super(key: key);

  @override
  State<GiftCardDetailsScreen> createState() => _GiftCardDetailsScreenState();
}

class _GiftCardDetailsScreenState extends State<GiftCardDetailsScreen> {
  bool _isLoading = true;
  bool _isCodeVisible = false;
  bool _isPinVisible = false;
  String? _errorMessage;
  GiftCardDetailsModel? _details;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    if (widget.purchaseId == null) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Purchase ID is missing.';
      });
      return;
    }

    try {
      final details = await GiftCardDetailsService().fetchPurchaseDetails(
        widget.purchaseId!,
      );
      if (!mounted) return;
      setState(() {
        _details = details;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Unable to load gift card details. Please try again.';
      });
    }
  }

  void _copyToClipboard(String text, String successMessage) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Boxicons.bx_check_circle, color: Colors.white),
            const SizedBox(width: AppSpacing.sm),
            Text(successMessage, style: const TextStyle(fontFamily: 'Inter')),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
      ),
    );
  }

  void _downloadOrShareReceipt() {
    if (_details == null) return;
    final card = _details!;
    
    final receiptText = '''
NobleCards Gift Card Receipt
--------------------------
Brand: ${card.brandName}
Type: ${card.cardType}
Value: \$${card.denomination.toStringAsFixed(2)}
Amount Paid: \$${card.amountPaid.toStringAsFixed(2)} ${card.currency}
Status: ${card.status}

Gift Card Code: ${card.code}
${card.pin != null ? 'PIN: ${card.pin}\n' : ''}
Order ID: ${card.orderId}
    ''';
    
    // Frontend-only shim: Triggers native share sheet acting as 'Download/Save'
    Share.share(receiptText, subject: 'NobleCards - ${card.brandName} Gift Card');
  }

  void _copyAllDetails() {
    if (_details == null) return;
    final card = _details!;
    final details = 'Brand: ${card.brandName}\nValue: \$${card.denomination.toStringAsFixed(2)}\nCode: ${card.code}${card.pin != null ? '\nPIN: ${card.pin}' : ''}';
    _copyToClipboard(details, 'All details copied successfully!');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Boxicons.bx_error_circle, size: 48, color: AppColors.error),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Unable to load gift card details',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ElevatedButton(
                    onPressed: _loadDetails,
                    child: const Text('Try again'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: AppAnimation.normal,
          child: _isLoading
              ? const GiftCardSkeleton()
              : _details == null
                  ? const SizedBox.shrink()
                  : Column(
                  children: [
                    _buildHeader(isDark, theme, _details!.status),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                        physics: const BouncingScrollPhysics(),
                        children: [
                          const SizedBox(height: AppSpacing.s),
                          _buildTitleSection(theme),
                          const SizedBox(height: AppSpacing.l),
                          GiftCardHero(data: _details!, isDark: isDark),
                          const SizedBox(height: AppSpacing.l),
                          GiftCardSummary(data: _details!, theme: theme),
                          const SizedBox(height: AppSpacing.l),
                          if (_details!.code.isNotEmpty) ...[
                            GiftCardCodeSection(
                              title: 'Gift Card Code',
                              subtitle: 'Use this code at checkout to redeem your gift card.',
                              code: _details!.code,
                              isVisible: _isCodeVisible,
                              onToggleVisibility: () => setState(() => _isCodeVisible = !_isCodeVisible),
                              onCopy: () => _copyToClipboard(_details!.code, 'Code copied to clipboard!'),
                              theme: theme,
                              showReadyBadge: true,
                            ),
                          ],
                          if (_details!.pin != null) ...[
                            const SizedBox(height: AppSpacing.m),
                            GiftCardCodeSection(
                              title: 'PIN (if required)',
                              subtitle: 'Some gift cards may require a PIN.',
                              code: _details!.pin!,
                              isVisible: _isPinVisible,
                              onToggleVisibility: () => setState(() => _isPinVisible = !_isPinVisible),
                              onCopy: () => _copyToClipboard(_details!.pin!, 'PIN copied to clipboard!'),
                              theme: theme,
                              showReadyBadge: false,
                            ),
                          ],
                          const SizedBox(height: AppSpacing.m),
                          GiftCardDownloadSection(
                            onDownload: _downloadOrShareReceipt,
                            theme: theme,
                          ),
                          const SizedBox(height: AppSpacing.m),
                          GiftCardInfoSection(data: _details!, theme: theme, isDark: isDark),
                          const SizedBox(height: AppSpacing.xl),
                        ],
                      ),
                    ),
                    _buildBottomButton(),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, ThemeData theme, String status) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.cardColor,
                border: Border.all(color: theme.dividerColor),
              ),
              child: Icon(Boxicons.bx_arrow_back, color: theme.textTheme.bodyLarge?.color, size: 20),
            ),
          ),
          Image.asset(
            isDark ? 'lib/assets/logos/MainDarkLogo.png.png' : 'lib/assets/logos/MainLightLogo.png.png',
            height: 28,
            errorBuilder: (context, error, stackTrace) => const Icon(Boxicons.bx_credit_card_front, size: 28),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: Border.all(color: AppColors.success.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Boxicons.bx_check_circle, color: AppColors.success, size: 14),
                const SizedBox(width: AppSpacing.xs),
                Text(status, style: const TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Gift Card Details', style: theme.textTheme.titleLarge),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Here are your gift card details. Keep this information safe and never share it with anyone.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.brightness == Brightness.light ? AppColors.secondary : AppColors.darkSubText,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: _copyAllDetails,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Boxicons.bx_copy, size: 20),
                SizedBox(width: AppSpacing.sm),
                Text('Copy All Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}