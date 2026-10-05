import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'package:screenshot/screenshot.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadow.dart';
import '../theme/app_spacing.dart';
import 'deposit_receipt_service.dart';
import 'deposit/widgets/deposit_receipt_amount_card.dart';
import 'deposit/widgets/deposit_receipt_details.dart';
import 'withraw/widgets/withdraw_receipt_confetti.dart';

class DepositReceiptScreen extends StatefulWidget {
  final double amount;
  final String currency;
  final double convertedUsd;
  final String? depositId;
  final String? transactionId;
  final String? transactionReference;
  final String? status;
  final double? fee;
  final String? paymentMethod;
  final String? provider;
  final String? providerReference;
  final String? providerTransactionId;
  final DateTime? transactionDate;

  const DepositReceiptScreen({
    super.key,
    required this.amount,
    required this.currency,
    required this.convertedUsd,
    this.depositId,
    this.transactionId,
    this.transactionReference,
    this.status,
    this.fee,
    this.paymentMethod,
    this.provider,
    this.providerReference,
    this.providerTransactionId,
    this.transactionDate,
  });

  @override
  State<DepositReceiptScreen> createState() => _DepositReceiptScreenState();
}

class _DepositReceiptScreenState extends State<DepositReceiptScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isProcessingDocument = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String? get _receiptIdentifier =>
      widget.transactionReference ?? widget.transactionId ?? widget.depositId;

  void _onDone() => Navigator.of(context).pop();

  Future<void> _handleShare() async {
    if (_isProcessingDocument) return;
    setState(() => _isProcessingDocument = true);
    try {
      final image = await _screenshotController.capture(
        delay: const Duration(milliseconds: 10),
      );
      if (image == null) throw Exception('Receipt capture returned no image.');
      await DepositReceiptService.shareReceiptImage(
        image,
        receiptIdentifier: _receiptIdentifier,
      );
    } catch (_) {
      _showSnackBar('Unable to share receipt.', isError: true);
    } finally {
      if (mounted) setState(() => _isProcessingDocument = false);
    }
  }

  Future<void> _handleDownload() async {
    if (_isProcessingDocument) return;
    setState(() => _isProcessingDocument = true);
    try {
      final image = await _screenshotController.capture(
        delay: const Duration(milliseconds: 10),
      );
      if (image == null) throw Exception('Receipt capture returned no image.');
      await DepositReceiptService.downloadReceiptPdf(
        image,
        receiptIdentifier: _receiptIdentifier,
      );
      _showSnackBar('Receipt downloaded successfully!');
    } catch (_) {
      _showSnackBar('Unable to download receipt.', isError: true);
    } finally {
      if (mounted) setState(() => _isProcessingDocument = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(isDark),
            Expanded(
              child: Stack(
                children: [
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          children: [
                            Screenshot(
                              controller: _screenshotController,
                              child: Container(
                                color: isDark
                                    ? AppColors.darkBackground
                                    : AppColors.lightBackground,
                                child: _buildReceiptContent(isDark),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            _buildActionButtons(isDark),
                            const SizedBox(height: AppSpacing.xl),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (_isProcessingDocument)
                    Container(
                      color: Colors.black.withOpacity(0.3),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
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

  Widget _buildAppBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.s,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Boxicons.bx_chevron_left,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
            onPressed: _onDone,
          ),
          Image.asset(
            isDark
                ? 'lib/assets/logos/MainDarkLogo.png.png'
                : 'lib/assets/logos/MainLightLogo.png.png',
            height: 28,
            errorBuilder: (context, error, stackTrace) => Text(
              'NobleCards',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
              borderRadius: BorderRadius.circular(AppRadius.xs),
            ),
            child: IconButton(
              icon: Icon(
                Boxicons.bx_download,
                size: 20,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
              onPressed: _handleDownload,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptContent(bool isDark) {
    return Stack(
      children: [
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: WithdrawReceiptConfetti(),
        ),
        Column(
          children: [
            const SizedBox(height: AppSpacing.md),
            Text(
              'Deposit Receipt',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 24,
                  ),
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildStatusBadge(),
            const SizedBox(height: AppSpacing.xl),
            DepositReceiptAmountCard(
              amount: widget.amount,
              currency: widget.currency,
              creditedUsd: widget.convertedUsd,
              status: widget.status,
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCard,
                borderRadius: BorderRadius.circular(AppRadius.md),
                boxShadow: isDark ? AppShadow.dark : AppShadow.light,
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : Colors.transparent,
                ),
              ),
              child: DepositReceiptDetails(
                depositId: widget.depositId,
                transactionId: widget.transactionId,
                reference: widget.transactionReference,
                status: widget.status,
                date: widget.transactionDate,
                paymentMethod: widget.paymentMethod,
                provider: widget.provider,
                currency: widget.currency,
                amount: widget.amount,
                fee: widget.fee,
                netAmountUsd: widget.convertedUsd,
                providerReference: widget.providerReference,
                providerTransactionId: widget.providerTransactionId,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    final status = widget.status?.trim();
    final label = status == null || status.isEmpty
        ? 'Status unavailable'
        : status
            .split('_')
            .map((part) => part.isEmpty
                ? part
                : '${part[0]}${part.substring(1).toLowerCase()}')
            .join(' ');
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Boxicons.bx_check_circle,
            color: AppColors.primary,
            size: 16,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isDark) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _handleShare,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
                  side: const BorderSide(color: AppColors.primary, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Boxicons.bx_upload, color: AppColors.primary, size: 20),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      'Share Receipt',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: ElevatedButton(
                onPressed: _handleDownload,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Boxicons.bx_download, color: Colors.white, size: 20),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      'Download Receipt',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _onDone,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
              side: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
            child: Text(
              'Done',
              style: TextStyle(
                color: isDark ? AppColors.darkText : AppColors.lightText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}