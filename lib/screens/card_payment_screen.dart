import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boxicons/boxicons.dart';

enum CardType { visa, mastercard, verve, amex, unknown }

class CardPaymentScreen extends StatefulWidget {
  final double amount;
  final String currency;
  final VoidCallback? onPaymentSuccess;

  const CardPaymentScreen({
    super.key,
    this.amount = 49.99,
    this.currency = '\$',
    this.onPaymentSuccess,
  });

  @override
  State<CardPaymentScreen> createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends State<CardPaymentScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();

  CardType _cardType = CardType.unknown;
  bool _saveCard = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _cardNumberController.addListener(_onCardNumberChanged);
  }

  @override
  void dispose() {
    _cardNumberController.removeListener(_onCardNumberChanged);
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardHolderController.dispose();
    super.dispose();
  }

  void _onCardNumberChanged() {
    final cleanNumber = _cardNumberController.text.replaceAll(' ', '');
    setState(() {
      _cardType = _detectCardType(cleanNumber);
    });
  }

  CardType _detectCardType(String number) {
    if (number.startsWith(RegExp(r'^4'))) {
      return CardType.visa;
    } else if (number.startsWith(RegExp(r'^(5[1-5]|222[1-9]|22[3-9]|2[3-6]|27[0-1]|2720)'))) {
      return CardType.mastercard;
    } else if (number.startsWith(RegExp(r'^(506|507|650|639)'))) {
      return CardType.verve;
    } else if (number.startsWith(RegExp(r'^3[47]'))) {
      return CardType.amex;
    }
    return CardType.unknown;
  }

  bool _validateLuhn(String number) {
    if (number.isEmpty) return false;
    int sum = 0;
    bool isSecond = false;
    for (int i = number.length - 1; i >= 0; i--) {
      int d = int.parse(number[i]);
      if (isSecond) d = d * 2;
      sum += d ~/ 10;
      sum += d % 10;
      isSecond = !isSecond;
    }
    return (sum % 10 == 0);
  }

  void _processPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    // Simulate initial gateway authorization handshake
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;
    setState(() => _isProcessing = false);

    // Trigger 3D Secure Challenge
    _show3DSecureModal(context);
  }

  void _show3DSecureModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ThreeDSecureModal(
        amount: widget.amount,
        currency: widget.currency,
        cardNumberLast4: _cardNumberController.text.replaceAll(' ', '').runes.length >= 4
            ? _cardNumberController.text.replaceAll(' ', '').substring(
                _cardNumberController.text.replaceAll(' ', '').length - 4,
              )
            : '0000',
        onVerified: () {
          Navigator.pop(context); // Close modal
          _showSuccessSnackbar();
          if (widget.onPaymentSuccess != null) {
            widget.onPaymentSuccess!();
          }
        },
      ),
    );
  }

  void _showSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: const Row(
          children: [
            Icon(Boxicons.bx_check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text(
              'Payment authorized successfully!',
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Card Payment', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Boxicons.bx_arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card Visual Preview
              _buildCreditCardPreview(),
              const SizedBox(height: 28),

              // Form Inputs
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card Holder Name
                    _buildSectionLabel('Cardholder Name'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _cardHolderController,
                      textCapitalization: TextCapitalization.words,
                      decoration: _inputDecoration(
                        hintText: 'John Doe',
                        prefixIcon: Boxicons.bx_user,
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Enter cardholder name';
                        }
                        return null;
                      },
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 20),

                    // Card Number
                    _buildSectionLabel('Card Number'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _cardNumberController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CardNumberInputFormatter(),
                      ],
                      decoration: _inputDecoration(
                        hintText: '0000 0000 0000 0000',
                        prefixIcon: Boxicons.bx_credit_card,
                        suffixIcon: _buildCardBrandIcon(),
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Enter card number';
                        }
                        final clean = val.replaceAll(' ', '');
                        if (clean.length < 13 || clean.length > 19) {
                          return 'Invalid card length';
                        }
                        if (!_validateLuhn(clean)) {
                          return 'Invalid card number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Expiry & CVV Row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionLabel('Expiry Date'),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _expiryController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  ExpiryDateInputFormatter(),
                                ],
                                decoration: _inputDecoration(
                                  hintText: 'MM/YY',
                                  prefixIcon: Boxicons.bx_calendar,
                                ),
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return 'Enter expiry';
                                  }
                                  if (val.length < 5) return 'Use MM/YY format';
                                  final parts = val.split('/');
                                  final month = int.tryParse(parts[0]) ?? 0;
                                  if (month < 1 || month > 12) {
                                    return 'Invalid month';
                                  }
                                  return null;
                                },
                                onChanged: (_) => setState(() {}),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionLabel('CVV / CVC'),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _cvvController,
                                keyboardType: TextInputType.number,
                                obscureText: true,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(4),
                                ],
                                decoration: _inputDecoration(
                                  hintText: '123',
                                  prefixIcon: Boxicons.bx_lock_alt,
                                ),
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return 'Enter CVV';
                                  }
                                  if (val.length < 3) return 'Invalid CVV';
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Save Card Switch
                    Row(
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: _saveCard,
                            activeColor: theme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onChanged: (val) {
                              setState(() => _saveCard = val ?? false);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Save card for future payments',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Pay Button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 2,
                        ),
                        onPressed: _isProcessing ? null : _processPayment,
                        child: _isProcessing
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Boxicons.bx_shield_quarter, color: Colors.white),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Pay ${widget.currency}${widget.amount.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(prefixIcon, color: Colors.grey.shade600, size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Theme.of(context).cardColor,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }

  Widget _buildCreditCardPreview() {
    final holderName = _cardHolderController.text.isEmpty
        ? 'YOUR NAME'
        : _cardHolderController.text.toUpperCase();
    final cardNumber = _cardNumberController.text.isEmpty
        ? '•••• •••• •••• ••••'
        : _cardNumberController.text;
    final expiry = _expiryController.text.isEmpty ? 'MM/YY' : _expiryController.text;

    return Container(
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF1E1E2C), Color(0xFF2D2B55)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Row: Chip and Brand
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 42,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700).withOpacity(0.85),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Container(
                    width: 32,
                    height: 20,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26, width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              _getBrandBadgeText(),
            ],
          ),

          // Middle: Card Number
          Text(
            cardNumber,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              letterSpacing: 2.2,
              fontWeight: FontWeight.w600,
              fontFamily: 'Courier',
            ),
          ),

          // Bottom Row: Holder and Expiry
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CARD HOLDER',
                    style: TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 1),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    holderName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'EXPIRES',
                    style: TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 1),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    expiry,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardBrandIcon() {
    switch (_cardType) {
      case CardType.visa:
        return const Padding(
          padding: EdgeInsets.all(12),
          child: Text('VISA', style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1A1F71))),
        );
      case CardType.mastercard:
        return const Padding(
          padding: EdgeInsets.all(12),
          child: Text('MC', style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFFEB001B))),
        );
      case CardType.verve:
        return const Padding(
          padding: EdgeInsets.all(12),
          child: Text('VERVE', style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF00B140))),
        );
      case CardType.amex:
        return const Padding(
          padding: EdgeInsets.all(12),
          child: Text('AMEX', style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF007BC1))),
        );
      default:
        return const Icon(Boxicons.bx_credit_card, color: Colors.grey);
    }
  }

  Widget _getBrandBadgeText() {
    String label = 'CARD';
    Color color = Colors.white70;

    if (_cardType == CardType.visa) {
      label = 'VISA';
      color = const Color(0xFF42A5F5);
    } else if (_cardType == CardType.mastercard) {
      label = 'MASTERCARD';
      color = const Color(0xFFFF7043);
    } else if (_cardType == CardType.verve) {
      label = 'VERVE';
      color = const Color(0xFF66BB6A);
    } else if (_cardType == CardType.amex) {
      label = 'AMEX';
      color = const Color(0xFF29B6F6);
    }

    return Text(
      label,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: 16,
        letterSpacing: 1.2,
      ),
    );
  }
}

// Custom Masking Formatters
class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll(' ', '');
    if (text.length > 16) text = text.substring(0, 16);

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      final nonSpacesLength = i + 1;
      if (nonSpacesLength % 4 == 0 && nonSpacesLength != text.length) {
        buffer.write(' ');
      }
    }

    final string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll('/', '');
    if (text.length > 4) text = text.substring(0, 4);

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i == 2) buffer.write('/');
      buffer.write(text[i]);
    }

    final string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

// 3D Secure Authentication Modal Sheet
class _ThreeDSecureModal extends StatefulWidget {
  final double amount;
  final String currency;
  final String cardNumberLast4;
  final VoidCallback onVerified;

  const _ThreeDSecureModal({
    required this.amount,
    required this.currency,
    required this.cardNumberLast4,
    required this.onVerified,
  });

  @override
  State<_ThreeDSecureModal> createState() => _ThreeDSecureModalState();
}

class _ThreeDSecureModalState extends State<_ThreeDSecureModal> {
  final TextEditingController _otpController = TextEditingController();
  bool _isAuthenticating = false;
  int _timerSeconds = 45;
  Timer? _timer;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timerSeconds = 45;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds == 0) {
        timer.cancel();
      } else {
        setState(() => _timerSeconds--);
      }
    });
  }

  void _verifyOtp() async {
    if (_otpController.text.length < 6) {
      setState(() => _errorMessage = 'Please enter complete 6-digit OTP');
      return;
    }

    setState(() {
      _isAuthenticating = true;
      _errorMessage = null;
    });

    // Simulate bank verification delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    if (_otpController.text == '123456' || _otpController.text.length == 6) {
      widget.onVerified();
    } else {
      setState(() {
        _isAuthenticating = false;
        _errorMessage = 'Invalid verification code. Try again.';
      });
    }
  }
@override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.fromLTRB(24, 20, 24, bottomPadding + 24),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // 3DS Security Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Boxicons.bx_shield_quarter,
                    color: theme.primaryColor,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '3D Secure 2.0',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  Boxicons.bx_x,
                  color: isDark ? Colors.white54 : Colors.grey,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 12),

          // Payment details note
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Card ending in •••• ${widget.cardNumberLast4}',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white70 : const Color(0xFF475569),
                  ),
                ),
                Text(
                  '${widget.currency}${widget.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'An authentication code has been sent to your registered phone number / email.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white60 : Colors.black54,
            ),
          ),
          const SizedBox(height: 20),

          // OTP Input Field
          TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 6,
            style: TextStyle(
              fontSize: 22,
              letterSpacing: 8,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              counterText: '',
              hintText: '000000',
              hintStyle: TextStyle(
                fontSize: 22,
                letterSpacing: 8,
                color: isDark ? Colors.white24 : Colors.grey.shade300,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? Colors.white24 : Colors.grey.shade300,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: theme.primaryColor, width: 2),
              ),
            ),
          ),

          if (_errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.redAccent, fontSize: 13),
            ),
          ],

          const SizedBox(height: 16),

          // Resend Timer Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Boxicons.bx_mobile_alt,
                size: 16,
                color: isDark ? Colors.white54 : Colors.grey,
              ),
              const SizedBox(width: 4),
              _timerSeconds > 0
                  ? Text(
                      'Resend code in ${_timerSeconds}s',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white54 : Colors.grey,
                      ),
                    )
                  : GestureDetector(
                      onTap: _startTimer,
                      child: Text(
                        'Resend OTP',
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ],
          ),
          const SizedBox(height: 24),

          // Verify Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _isAuthenticating ? null : _verifyOtp,
              child: _isAuthenticating
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Authorize Payment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }


  //     ),
  //   );
  // }
}