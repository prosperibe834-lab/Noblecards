// Location: lib/screens/bank_transfer_screen.dart
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boxicons/boxicons.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../models/deposit_model.dart';
import '../services/deposits_service.dart';
import '../theme/app_colors.dart';
import '../theme/theme_provider.dart';
import 'authentication/services/authentication_service.dart';
import 'deposit/deposit_screen.dart';
import 'deposit/widgets/deposit_progress_indicator.dart';
import 'deposit/widgets/bank_transfer_header_graphic.dart';
import 'deposit/widgets/bank_transfer_shimmer.dart';
import 'deposit/widgets/deposit_help_bottom_sheet.dart';

class BankTransferScreen extends StatefulWidget {
  final double amount;
  final String currency;
  final double convertedUsd;

  const BankTransferScreen({
    super.key,
    required this.amount,
    required this.currency,
    required this.convertedUsd,
  });

  @override
  State<BankTransferScreen> createState() => _BankTransferScreenState();
}

class _BankTransferScreenState extends State<BankTransferScreen>
    with SingleTickerProviderStateMixin {
  late DepositsService _depositsService;
  Deposit? _deposit;
  bool _isLoading = true;
  String? _errorMessage;
  String _authToken = '';

  // Timer Countdown state
  Timer? _countdownTimer;
  int _remainingSeconds = 896; // 14:56 initially
  int _totalSeconds = 900; // 15 mins total

  // Animated Copy feedback state
  bool _isCopied = false;

  // Entrance animation
  late AnimationController _entranceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutCubic,
    ));

    _initializeAndCreateDeposit();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _entranceController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        if (mounted) {
          setState(() {
            _remainingSeconds--;
          });
        }
      } else {
        timer.cancel();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Virtual account has expired. Please initiate a new deposit.'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    });
  }

  Future<void> _initializeAndCreateDeposit() async {
    try {
      final authService = AuthenticationService();
      _authToken = (await authService.getAccessToken()) ?? '';

      if (_authToken.isEmpty) {
        if (!mounted) return;
        setState(() {
          _errorMessage = 'Your login session has expired. Please log in again.';
          _isLoading = false;
        });
        return;
      }

      _depositsService = DepositsService(
        httpClient: http.Client(),
        getAuthToken: () => _authToken,
      );

      final deposit = await _depositsService.createDeposit(
        amount: widget.amount,
        currency: widget.currency,
        paymentMethod: 'BANK_TRANSFER',
        country: 'Nigeria',
        countryCode: 'NG',
        idempotencyKey: '${widget.currency}-${widget.amount}-${DateTime.now().millisecondsSinceEpoch}',
      );

      // Parse expiration from Flutterwave virtual account if provided
      if (deposit.bankTransfer?.expiresAt != null) {
        final expiry = DateTime.tryParse(deposit.bankTransfer!.expiresAt!);
        if (expiry != null) {
          final diff = expiry.difference(DateTime.now()).inSeconds;
          _remainingSeconds = diff > 0 ? diff : 896;
          _totalSeconds = _remainingSeconds;
        } else {
          _remainingSeconds = 896;
          _totalSeconds = 900;
        }
      } else {
        _remainingSeconds = 896;
        _totalSeconds = 900;
      }

      if (mounted) {
        setState(() {
          _deposit = deposit;
          _isLoading = false;
        });
        _entranceController.forward();
        _startTimer();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll('Exception:', '').trim();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.lightImpact();

    if (mounted) {
      setState(() => _isCopied = true);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Boxicons.bx_check_circle, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text(
                'Account number copied to clipboard',
                style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
        ),
      );

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _isCopied = false);
        }
      });
    }
  }

  void _onConfirmTransfer() {
    bool found = false;
    Navigator.of(context).popUntil((route) {
      if (route.settings.name == '/deposit') {
        found = true;
        return true;
      }
      return route.isFirst;
    });

    if (!found) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          settings: const RouteSettings(name: '/deposit'),
          builder: (_) => const DepositScreen(),
        ),
      );
    }
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
          icon: Icon(
            Boxicons.bx_arrow_back,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Pay via Bank Transfer',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 17,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Boxicons.bx_help_circle,
              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B),
              size: 22,
            ),
            onPressed: () => showDepositHelpBottomSheet(context),
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? BankTransferShimmer(isDark: isDark)
            : _errorMessage != null
                ? _buildErrorView(isDark)
                : _buildContent(isDark),
      ),
    );
  }

  Widget _buildErrorView(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Boxicons.bx_error_circle, size: 48, color: AppColors.error),
            ),
            const SizedBox(height: 18),
            Text(
              'Failed to Generate Virtual Account',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Unable to connect to Flutterwave.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              width: 160,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _errorMessage = null;
                  });
                  _initializeAndCreateDeposit();
                },
                icon: const Icon(Boxicons.bx_refresh, size: 18),
                label: const Text('Try Again', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(bool isDark) {
    final bankDetails = _deposit?.bankTransfer;
    final bankName = bankDetails?.bankName ?? 'Access Bank';
    final accountNumber = bankDetails?.accountNumber ?? '0077130155';
    final accountName = bankDetails?.accountName ?? 'NobleCards Technologies Ltd';
    final network = widget.currency == 'NGN' ? 'NGN (Nigerian Naira)' : '${widget.currency} Transfer';

    // Format remaining time: mm:ss
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    final timerString = '$minutes:$seconds';
    final timerProgress = (_remainingSeconds / _totalSeconds).clamp(0.0, 1.0);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            // 1. Step Indicator: (✓) Amount -> (✓) Method -> (3) Confirm (Active)
            const DepositProgressIndicator(currentStep: 3),
            const SizedBox(height: 12),

            // Scrollable Content Body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. Banner Card ("Pay via Bank Transfer" + 3D bank illustration)
                    _buildBannerCard(isDark),
                    const SizedBox(height: 22),

                    // 3. Section Title: "Transfer Details"
                    Text(
                      'Transfer Details',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 4. Transfer Details Card
                    _buildDetailsCard(
                      isDark: isDark,
                      bankName: bankName,
                      accountNumber: accountNumber,
                      accountName: accountName,
                      network: network,
                    ),
                    const SizedBox(height: 16),

                    // 5. Countdown Timer Card
                    _buildTimerCard(
                      isDark: isDark,
                      timerString: timerString,
                      progress: timerProgress,
                    ),
                    const SizedBox(height: 14),

                    // 6. Note / Warning Disclaimer Card
                    _buildNoteCard(isDark),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // 7. Bottom Fixed Action Button: "I Have Made The Transfer ->"
            _buildBottomButton(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF062A1F),
                  Color(0xFF031A13),
                ],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE8FDF5),
                  Color(0xFFD1FAE5),
                  Color(0xFFC6F6D5),
                ],
              ),
        border: isDark
            ? Border.all(
                color: const Color(0xFF10B981).withOpacity(0.4),
                width: 1.2,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(isDark ? 0.22 : 0.08),
            blurRadius: isDark ? 20 : 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left text info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pill: "[✓] Secure & Flexible"
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0E382B) : const Color(0xFFD1FAE5),
                    borderRadius: BorderRadius.circular(16),
                    border: isDark
                        ? Border.all(color: const Color(0xFF10B981).withOpacity(0.3))
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Boxicons.bx_check_shield,
                        size: 13,
                        color: isDark ? const Color(0xFF34D399) : const Color(0xFF065F46),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Secure & Flexible',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isDark ? const Color(0xFF34D399) : const Color(0xFF065F46),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Title: "Pay via\nBank Transfer"
                Text(
                  'Pay via\nBank Transfer',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),

                // Subtitle
                Text(
                  "Use your bank to make a secure transfer. It's fast, reliable and widely accepted.",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Right Graphic: 3D Bank with columns & checkmark shield
          BankTransferHeaderGraphic(isDark: isDark),
        ],
      ),
    );
  }

  Widget _buildDetailsCard({
    required bool isDark,
    required String bankName,
    required String accountNumber,
    required String accountName,
    required String network,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF13222E) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF263545) : const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                )
              ],
      ),
      child: Column(
        children: [
          // Header Row: Solid emerald circle with white Bank icon + Title + "• Active" pill
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Boxicons.bxs_bank,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bank Transfer',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'NobleCards Account',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),

              // "• Active" Pill Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0D3B2E) : const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Active',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isDark ? const Color(0xFF34D399) : const Color(0xFF065F46),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(
            height: 1,
            color: isDark ? const Color(0xFF263545) : const Color(0xFFF1F5F9),
          ),
          const SizedBox(height: 14),

          // Row 1: Bank Name
          _buildDetailRow(
            label: 'Bank Name',
            value: bankName,
            isDark: isDark,
          ),
          const SizedBox(height: 14),

          // Row 2: Account Number (with Copy icon)
          _buildDetailRow(
            label: 'Account Number',
            value: accountNumber,
            isDark: isDark,
            isCopyable: true,
            onCopy: () => _copyToClipboard(accountNumber),
          ),
          const SizedBox(height: 14),

          // Row 3: Account Name
          _buildDetailRow(
            label: 'Account Name',
            value: accountName,
            isDark: isDark,
          ),
          const SizedBox(height: 14),

          // Row 4: Network
          _buildDetailRow(
            label: 'Network',
            value: network,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    required bool isDark,
    bool isCopyable = false,
    VoidCallback? onCopy,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            if (isCopyable) ...[
              const SizedBox(width: 6),
              GestureDetector(
                onTap: onCopy,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    _isCopied ? Boxicons.bx_check : Boxicons.bx_copy,
                    key: ValueKey<bool>(_isCopied),
                    size: 16,
                    color: _isCopied
                        ? const Color(0xFF10B981)
                        : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B)),
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildTimerCard({
    required bool isDark,
    required String timerString,
    required double progress,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF072D21),
                  Color(0xFF021711),
                ],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF054E3B),
                  Color(0xFF032B20),
                ],
              ),
        border: isDark
            ? Border.all(
                color: const Color(0xFF10B981).withOpacity(0.4),
                width: 1.2,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(isDark ? 0.22 : 0.2),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Circular Clock Icon Badge
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Boxicons.bx_time_five,
              color: Color(0xFF34D399),
              size: 24,
            ),
          ),
          const SizedBox(width: 14),

          // Timer Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Complete your transfer within',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  timerString,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),

          // Dotted Progress Arc
          SizedBox(
            width: 48,
            height: 48,
            child: CustomPaint(
              painter: _TimerDottedArcPainter(
                progress: progress,
                color: const Color(0xFF34D399),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0A261E) : const Color(0xFFE8FDF5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? const Color(0xFF10B981).withOpacity(0.25)
              : const Color(0xFFD1FAE5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Boxicons.bx_info_circle,
              color: Color(0xFF10B981),
              size: 15,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Make sure to use the exact account details above. Transfers made after the timer expires may not be credited automatically.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF065F46),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.35 : 0.04),
            offset: const Offset(0, -4),
            blurRadius: 16,
          )
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: GestureDetector(
          onTap: _onConfirmTransfer,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF10B981),
                  Color(0xFF059669),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10B981).withOpacity(isDark ? 0.45 : 0.35),
                  blurRadius: isDark ? 20 : 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'I Have Made The Transfer',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TimerDottedArcPainter extends CustomPainter {
  final double progress;
  final Color color;

  _TimerDottedArcPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    const dotCount = 18;
    const sweepAngle = math.pi * 1.5;
    const startAngle = -math.pi * 0.75;

    for (int i = 0; i < dotCount; i++) {
      final t = i / (dotCount - 1);
      final angle = startAngle + sweepAngle * t;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      final isLit = t <= progress;
      final paint = Paint()
        ..color = isLit ? color : color.withOpacity(0.2)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), isLit ? 2.5 : 1.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TimerDottedArcPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}