import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';
import '../providers/payment_provider.dart';

class AppleGooglePayScreen extends StatefulWidget {
  final double amount;
  final String currency;

  // --- Dummy Payment Configurations for Demo / UI Testing ---
  static const String _dummyGooglePayConfig = '''{
    "provider": "google_pay",
    "data": {
      "environment": "TEST",
      "apiVersion": 2,
      "apiVersionMinor": 0,
      "allowedPaymentMethods": [
        {
          "type": "CARD",
          "tokenizationSpecification": {
            "type": "PAYMENT_GATEWAY",
            "parameters": {
              "gateway": "example",
              "gatewayMerchantId": "exampleGatewayMerchantId"
            }
          },
          "parameters": {
            "allowedCardNetworks": ["VISA", "MASTERCARD"],
            "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"]
          }
        }
      ],
      "merchantInfo": {
        "merchantId": "01234567890123456789",
        "merchantName": "NobleCards Wallet"
      }
    }
  }''';

  static const String _dummyApplePayConfig = '''{
    "provider": "apple_pay",
    "data": {
      "merchantIdentifier": "merchant.com.noblecards.app",
      "displayName": "NobleCards Wallet",
      "merchantCapabilities": ["3DS", "debit", "credit"],
      "supportedNetworks": ["visa", "masterCard", "amex"],
      "countryCode": "US",
      "currencyCode": "USD"
    }
  }''';

  const AppleGooglePayScreen({
    super.key,
    required this.amount,
    required this.currency,
  });

  @override
  State<AppleGooglePayScreen> createState() => _AppleGooglePayScreenState();
}

class _AppleGooglePayScreenState extends State<AppleGooglePayScreen>
    with SingleTickerProviderStateMixin {
  // State variables
  bool _isInitializing = true;
  PaymentConfiguration? _paymentConfiguration;
  String? _paymentConfigError;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _pulseAnim;

  // Platform getters
  bool get _isIos => defaultTargetPlatform == TargetPlatform.iOS;
  bool get _isAndroid => defaultTargetPlatform == TargetPlatform.android;

  @override
  void initState() {
    super.initState();

    // 1. Load Dummy Payment Configuration for UI Demo
    try {
      final dummyJson =
          _isIos ? AppleGooglePayScreen._dummyApplePayConfig : AppleGooglePayScreen._dummyGooglePayConfig;
      _paymentConfiguration = PaymentConfiguration.fromJsonString(dummyJson);
    } catch (e) {
      _paymentConfigError = e.toString();
    }

    // 2. Setup Animations
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutCubic,
      ),
    );

    _pulseAnim = Tween<double>(begin: 0.35, end: 0.85).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeInOut,
      ),
    );

    // 3. Simulate quick network check / shimmer initialization
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _isInitializing = false);
        _animController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;

    final paymentItems = [
      PaymentItem(
        label: 'NobleCards Deposit',
        amount: widget.amount.toStringAsFixed(2),
        status: PaymentItemStatus.final_price,
      ),
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Boxicons.bx_arrow_back,
            color: isDark ? Colors.white : Colors.black87,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isIos ? Boxicons.bxl_apple : Boxicons.bxl_google,
              size: 20,
              color: isDark ? Colors.white : Colors.black87,
            ),
            const SizedBox(width: 8),
            Text(
              _isIos ? 'Apple Pay' : 'Google Pay',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          // Background Gradient Glow
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    primaryColor.withOpacity(isDark ? 0.25 : 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _isInitializing
                        ? _buildFintechShimmerSkeleton(theme, isDark, primaryColor)
                        : FadeTransition(
                            opacity: _fadeAnim,
                            child: SlideTransition(
                              position: _slideAnim,
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 16),
                                    
                                    // Main Gradient Transaction Summary Card
                                    _buildTransactionCard(
                                      theme,
                                      isDark,
                                      primaryColor,
                                      secondaryColor,
                                    ),

                                    const SizedBox(height: 20),

                                    // Security & Trust Banner
                                    _buildSecurityBadge(theme, isDark, primaryColor),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ),

                  // Bottom Action Area: Native Pay Button & States
                  Consumer<PaymentProvider>(
                    builder: (context, paymentProvider, child) {
                      if (paymentProvider.isLoading) {
                        return _buildProcessingButton(theme, primaryColor);
                      }

                      if (_paymentConfigError != null) {
                        return _buildErrorCard(theme, isDark);
                      }

                      if (_paymentConfiguration == null) {
                        return _buildLoadingButton(theme, primaryColor);
                      }

                      final paymentConfiguration = _paymentConfiguration!;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_isIos)
                              ApplePayButton(
                                paymentConfiguration: paymentConfiguration,
                                paymentItems: paymentItems,
                                style: isDark
                                    ? ApplePayButtonStyle.white
                                    : ApplePayButtonStyle.black,
                                type: ApplePayButtonType.buy,
                                margin: const EdgeInsets.only(bottom: 12.0),
                                onPaymentResult: (result) => _handlePaymentResult(
                                  context,
                                  paymentProvider,
                                  result,
                                ),
                                loadingIndicator: Center(
                                  child: CircularProgressIndicator(
                                    color: primaryColor,
                                  ),
                                ),
                              )
                            else if (_isAndroid)
                              GooglePayButton(
                                paymentConfiguration: paymentConfiguration,
                                paymentItems: paymentItems,
                                theme: isDark
                                    ? GooglePayButtonTheme.dark
                                    : GooglePayButtonTheme.light,
                                type: GooglePayButtonType.pay,
                                margin: const EdgeInsets.only(bottom: 12.0),
                                onPaymentResult: (result) => _handlePaymentResult(
                                  context,
                                  paymentProvider,
                                  result,
                                ),
                                loadingIndicator: Center(
                                  child: CircularProgressIndicator(
                                    color: primaryColor,
                                  ),
                                ),
                              )
                            else
                              _buildUnsupportedPlatformBanner(theme, isDark),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Payment Result Handler ---
  Future<void> _handlePaymentResult(
    BuildContext context,
    PaymentProvider paymentProvider,
    Map<String, dynamic> result,
  ) async {
    final success = await paymentProvider.processMobileWalletPayment(
      result,
      widget.amount,
    );

    if (mounted && success) {
      _showSuccessBottomSheet(context);
    }
  }

  // --- Main Transaction Gradient Card ---
  Widget _buildTransactionCard(
    ThemeData theme,
    bool isDark,
    Color primaryColor,
    Color secondaryColor,
  ) {
    final gradientColors = isDark
        ? [
            primaryColor.withOpacity(0.20),
            secondaryColor.withOpacity(0.12),
            theme.cardColor,
          ]
        : [
            primaryColor.withOpacity(0.10),
            theme.cardColor,
          ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.12)
              : primaryColor.withOpacity(0.15),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.35 : 0.06),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Icon Avatar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  primaryColor,
                  primaryColor.withOpacity(0.75),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              _isIos ? Boxicons.bxl_apple : Boxicons.bxl_google,
              size: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 18),
          
          Text(
            'Deposit Amount',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.65),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          
          // Amount Heading
          Text(
            '${widget.currency} ${widget.amount.toStringAsFixed(2)}',
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -1.0,
            ),
          ),
          
          const SizedBox(height: 20),
          
          Divider(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.08),
          ),
          
          const SizedBox(height: 14),

          // Detail Rows
          _buildDetailRow(
            theme,
            label: 'Payment Method',
            value: _isIos ? 'Apple Pay' : 'Google Pay',
            icon: _isIos ? Boxicons.bxl_apple : Boxicons.bxl_google,
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            theme,
            label: 'Merchant',
            value: 'NobleCards Wallet',
            icon: Boxicons.bx_wallet,
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            theme,
            label: 'Processing Fee',
            value: 'Free',
            valueColor: Colors.greenAccent.shade400,
            icon: Boxicons.bx_check_shield,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    ThemeData theme, {
    required String label,
    required String value,
    IconData? icon,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: valueColor ?? theme.textTheme.bodyMedium?.color,
          ),
        ),
      ],
    );
  }

  // --- Security Badge ---
  Widget _buildSecurityBadge(ThemeData theme, bool isDark, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.04)
            : primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : primaryColor.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Boxicons.bx_shield_quarter,
            color: primaryColor,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Encrypted & direct checkout via your native OS wallet authorization.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Shimmer Loading Skeleton ---
  Widget _buildFintechShimmerSkeleton(
    ThemeData theme,
    bool isDark,
    Color primaryColor,
  ) {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (context, child) {
        final opacity = _pulseAnim.value;
        final shimmerColor = isDark
            ? Colors.white.withOpacity(0.05 + opacity * 0.05)
            : Colors.black.withOpacity(0.03 + opacity * 0.04);

        return Column(
          children: [
            const SizedBox(height: 16),
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: shimmerColor,
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: shimmerColor,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ],
        );
      },
    );
  }

  // --- Action Buttons & States ---
  Widget _buildProcessingButton(ThemeData theme, Color primaryColor) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.5,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Processing Deposit...',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingButton(ThemeData theme, Color primaryColor) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            color: primaryColor,
            strokeWidth: 2.5,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Boxicons.bx_error_circle, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Unable to load payment configuration. Please try again.',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnsupportedPlatformBanner(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(Boxicons.bx_info_circle, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Native wallet payments are unavailable on this device or platform.',
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  // --- Fintech Deposit Success BottomSheet ---
  void _showSuccessBottomSheet(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 30,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.greenAccent.shade700.withOpacity(0.15),
              ),
              child: Icon(
                Boxicons.bx_check_circle,
                color: Colors.greenAccent.shade700,
                size: 56,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Deposit Successful!',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your wallet deposit of ${widget.currency} ${widget.amount.toStringAsFixed(2)} has been credited successfully.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.pop(ctx); // Close sheet
                Navigator.pop(context); // Return to home / wallet screen
              },
              child: const Text(
                'Back to Wallet',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}