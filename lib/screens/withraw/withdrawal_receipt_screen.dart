import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'package:screenshot/screenshot.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_shadow.dart';
import 'models/withdrawal_transaction_model.dart';
import 'services/withdrawal_receipt_service.dart';
import 'widgets/withdraw_receipt_confetti.dart';
import 'widgets/withdraw_receipt_amount_card.dart';
import 'widgets/withdraw_receipt_details.dart';

class WithdrawalReceiptScreen extends StatefulWidget {
  final WithdrawalTransactionModel transaction;

  const WithdrawalReceiptScreen({Key? key, required this.transaction})
    : super(key: key);

  @override
  State<WithdrawalReceiptScreen> createState() =>
      _WithdrawalReceiptScreenState();
}

class _WithdrawalReceiptScreenState extends State<WithdrawalReceiptScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isProcessingDocument = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
        );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onDone() {
    Navigator.of(
      context,
    ).popUntil((route) => route.settings.name == '/deposit' || route.isFirst);
  }

  Future<void> _handleShare() async {
    if (_isProcessingDocument) return;
    setState(() => _isProcessingDocument = true);
    try {
      final image = await _screenshotController.capture(
        delay: const Duration(milliseconds: 10),
      );
      if (image == null) throw Exception('Receipt capture returned no image.');
      await WithdrawalReceiptService.shareReceiptImage(
        image,
        widget.transaction,
      );
    } catch (e) {
      _showSnackBar('Unable to share receipt.', isError: true);
    } finally {
      setState(() => _isProcessingDocument = false);
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
      await WithdrawalReceiptService.downloadReceiptPdf(
        image,
        widget.transaction,
      );
      _showSnackBar('Receipt downloaded successfully!');
    } catch (e) {
      _showSnackBar('Unable to download receipt.', isError: true);
    } finally {
      setState(() => _isProcessingDocument = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
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
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
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
                            // The section to be captured for PDF/Sharing
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
            onPressed: _onDone, // Uses existing navigation architecture
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
              'Withdrawal Receipt',
              style: Theme.of(
                context,
              ).textTheme.headlineLarge?.copyWith(fontSize: 24),
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
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
                    'Completed',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Amount Details
            WithdrawReceiptAmountCard(transaction: widget.transaction),

            const SizedBox(height: AppSpacing.lg),

            // Details List
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
              child: WithdrawReceiptDetails(transaction: widget.transaction),
            ),
          ],
        ),
      ],
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Boxicons.bx_upload,
                      color: AppColors.primary,
                      size: 20,
                    ),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
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
