import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_radius.dart';
import 'models/withdrawal_transaction_model.dart';
import 'widgets/withdraw_success_animation.dart';
import 'widgets/withdraw_summary_card.dart';
import 'widgets/withdraw_notification_card.dart';
import 'withdrawal_receipt_screen.dart';

class WithdrawSuccessScreen extends StatefulWidget {
  final WithdrawalTransactionModel? transaction;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const WithdrawSuccessScreen({
    Key? key,
    this.transaction,
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.onRetry,
  }) : super(key: key);

  @override
  State<WithdrawSuccessScreen> createState() => _WithdrawSuccessScreenState();
}

class _WithdrawSuccessScreenState extends State<WithdrawSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    if (!widget.isLoading && !widget.hasError) {
      _fadeController.forward();
    }
  }

  @override
  void didUpdateWidget(WithdrawSuccessScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isLoading && !widget.hasError && oldWidget.isLoading) {
      _fadeController.forward();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  String get _normalizedStatus =>
      widget.transaction?.status.trim().toLowerCase() ?? '';

  bool get _isSuccessful => const {
    'successful',
    'success',
    'completed',
    'succeeded',
    'paid',
    'settled',
  }.contains(_normalizedStatus);

  bool get _isPendingLike => const {
    'processing',
    'pending',
    'new',
    'under_review',
  }.contains(_normalizedStatus);

  bool get _isFailed => _normalizedStatus == 'failed';

  bool get _canViewReceipt =>
      _isSuccessful &&
      !widget.hasError &&
      !widget.isLoading &&
      widget.transaction != null;

  String get _statusTitle {
    if (_isSuccessful) return 'Withdrawal Successful!';
    if (_normalizedStatus == 'under_review') return 'Withdrawal Under Review';
    if (_isPendingLike || _normalizedStatus == 'processing')
      return 'Withdrawal Pending';
    if (_isFailed) return 'Withdrawal Failed';
    return 'Withdrawal Pending';
  }

  String get _statusDescription {
    if (_isSuccessful) {
      return 'Your withdrawal has been successfully completed.';
    }
    if (_normalizedStatus == 'under_review') {
      return 'Your withdrawal is being reviewed. Your funds remain protected while we confirm the provider result.';
    }
    if (_normalizedStatus == 'pending' || _normalizedStatus == 'new') {
      return 'Your withdrawal is being processed. Your funds remain protected while we confirm the provider result.';
    }
    return 'Your withdrawal request has been received and is being processed. Your funds remain protected while we confirm the provider result.';
  }

  String get _notificationMessage {
    if (_isSuccessful) {
      return 'Your funds have been successfully credited to your destination.';
    }
    if (_normalizedStatus == 'under_review') {
      return 'Your withdrawal is under review. Your funds remain protected while we confirm the provider result.';
    }
    if (_isPendingLike) {
      return 'Your withdrawal request has been received and is being processed.';
    }
    if (widget.errorMessage != null && widget.errorMessage!.isNotEmpty) {
      return widget.errorMessage!;
    }
    return 'Your withdrawal request has been received and is being processed.';
  }

  void _onDone() {
    // Safely pops back to DepositScreen if it exists in the stack.
    // If it doesn't, you can replace this with a named route pushReplacement.
    Navigator.of(context).popUntil((route) {
      return route.settings.name == '/deposit' || route.isFirst;
    });
  }

  void _onViewReceipt() {
    final transaction = widget.transaction;

    if (transaction == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Receipt details are unavailable.')),
        );
      }
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WithdrawalReceiptScreen(transaction: transaction),
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
      body: SafeArea(child: _buildBody(isDark)),
    );
  }

  Widget _buildBody(bool isDark) {
    if (widget.hasError) {
      return _buildErrorState(isDark);
    }

    if (widget.isLoading || widget.transaction == null) {
      return _buildShimmerState(isDark);
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.xl),
            const WithdrawSuccessAnimation(),
            const SizedBox(height: AppSpacing.lg),
            _buildHeader(isDark),
            const SizedBox(height: AppSpacing.xl),
            WithdrawSummaryCard(transaction: widget.transaction!),
            const SizedBox(height: AppSpacing.md),
            WithdrawNotificationCard(message: _notificationMessage),
            const SizedBox(height: AppSpacing.xl),
            _buildActions(isDark),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Boxicons.bx_hive,
              color: AppColors.primary,
              size: 28,
            ), // NobleCards logo placeholder
            const SizedBox(width: AppSpacing.sm),
            Text(
              'NobleCards',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          _statusTitle,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.headlineLarge?.copyWith(fontSize: 26),
        ),
        const SizedBox(height: AppSpacing.s),
        Text(
          _statusDescription,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildActions(bool isDark) {
    return Column(
      children: [
        // View Receipt Button
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.success],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(AppRadius.full),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: widget.transaction == null ? null : _onViewReceipt,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Boxicons.bx_receipt, color: Colors.white, size: 20),
                const SizedBox(width: AppSpacing.sm),
                const Text(
                  'View Receipt',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Boxicons.bx_chevron_right,
                  color: Colors.white,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        // Done Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: _onDone,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Boxicons.bx_check_circle,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Done',
                  style: TextStyle(
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerState(bool isDark) {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.4, end: 1.0),
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: AppColors.primary),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Finalizing details...',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkSubText
                        : AppColors.lightSubText,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Boxicons.bx_error_circle, color: AppColors.error, size: 64),
          const SizedBox(height: AppSpacing.md),
          Text(
            widget.errorMessage ?? 'Unable to load details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          ElevatedButton(
            onPressed: widget.onRetry,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text(
              'Try Again',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
