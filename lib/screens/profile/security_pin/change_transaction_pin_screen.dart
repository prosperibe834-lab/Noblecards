import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:boxicons/boxicons.dart';
import '../../../widgets/transaction_pin_input.dart';
import '../../../widgets/pin_strength_indicator.dart';
import '../../../widgets/primary_gradient_button.dart';
import '../../../widgets/secondary_outline_button.dart';
import 'forgot_transaction_pin_screen.dart';
import 'transaction_pin_success_dialog.dart';

class ChangeTransactionPinScreen extends StatefulWidget {
  const ChangeTransactionPinScreen({super.key});

  @override
  State<ChangeTransactionPinScreen> createState() => _ChangeTransactionPinScreenState();
}

class _ChangeTransactionPinScreenState extends State<ChangeTransactionPinScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _currentPinCtrl = TextEditingController();
  final TextEditingController _newPinCtrl = TextEditingController();
  final TextEditingController _confirmPinCtrl = TextEditingController();

  final FocusNode _currentPinFocus = FocusNode();
  final FocusNode _newPinFocus = FocusNode();
  final FocusNode _confirmPinFocus = FocusNode();

  late AnimationController _shakeController;
  bool _hasError = false;
  int _activeStep = 1;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _currentPinFocus.requestFocus();
  }

  @override
  void dispose() {
    _currentPinCtrl.dispose();
    _newPinCtrl.dispose();
    _confirmPinCtrl.dispose();
    _currentPinFocus.dispose();
    _newPinFocus.dispose();
    _confirmPinFocus.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _onCurrentPinChanged(String val) {
    if (val.length == 4) {
      setState(() => _activeStep = 2);
      _newPinFocus.requestFocus();
    } else {
      setState(() => _activeStep = 1);
    }
  }

  void _onNewPinChanged(String val) {
    if (val.length == 4) {
      setState(() => _activeStep = 3);
      _confirmPinFocus.requestFocus();
    } else {
      setState(() => _activeStep = 2);
    }
  }

  void _onConfirmPinChanged(String val) {
    setState(() => _hasError = false);
  }

  void _validateAndUpdate() {
    if (_currentPinCtrl.text.length != 4) {
      _currentPinFocus.requestFocus();
      return;
    }
    if (_newPinCtrl.text.length != 4) {
      _newPinFocus.requestFocus();
      return;
    }
    if (_newPinCtrl.text != _confirmPinCtrl.text) {
      setState(() => _hasError = true);
      _shakeController.forward(from: 0.0);
      _confirmPinCtrl.clear();
      _confirmPinFocus.requestFocus();
      return;
    }
    
    // Simulate Network API Call
    TransactionPinSuccessDialog.show(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1419) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Boxicons.bx_chevron_left, color: isDark ? Colors.white : Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Change Transaction PIN",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSecurityCard(isDark),
            const SizedBox(height: 32),
            _buildStepIndicator(isDark),
            const SizedBox(height: 32),
            
            // SECTION 1
            _buildSectionHeader("1. Verify Current PIN", "Enter your current 4-digit transaction PIN.", isDark),
            const SizedBox(height: 16),
            TransactionPinInput(
              controller: _currentPinCtrl,
              focusNode: _currentPinFocus,
              onChanged: _onCurrentPinChanged,
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ForgotTransactionPinScreen()),
                  );
                },
                child: const Text(
                  "Forgot PIN?",
                  style: TextStyle(color: Color(0xFF00C853), fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // SECTION 2
            _buildSectionHeader("2. Enter New PIN", "Choose a new 4-digit transaction PIN.", isDark),
            const SizedBox(height: 16),
            TransactionPinInput(
              controller: _newPinCtrl,
              focusNode: _newPinFocus,
              onChanged: _onNewPinChanged,
            ),
            const SizedBox(height: 16),
            AnimatedBuilder(
              animation: _newPinCtrl,
              builder: (context, _) => PinStrengthIndicator(pin: _newPinCtrl.text),
            ),
            const SizedBox(height: 32),

            // SECTION 3
            _buildSectionHeader("3. Confirm New PIN", "Re-enter your new 4-digit PIN.", isDark),
            const SizedBox(height: 16),
            AnimatedBuilder(
              animation: _shakeController,
              builder: (context, child) {
                final dx = math.sin(_shakeController.value * math.pi * 4) * 8;
                return Transform.translate(
                  offset: Offset(dx, 0),
                  child: TransactionPinInput(
                    controller: _confirmPinCtrl,
                    focusNode: _confirmPinFocus,
                    hasError: _hasError,
                    onChanged: _onConfirmPinChanged,
                  ),
                );
              },
            ),
            const SizedBox(height: 32),

            _buildPinTipsCard(isDark),
            const SizedBox(height: 40),

            PrimaryGradientButton(
              text: "Update PIN",
              icon: Boxicons.bx_lock_alt,
              onPressed: _validateAndUpdate,
            ),
            const SizedBox(height: 16),
            SecondaryOutlineButton(
              text: "Cancel",
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Boxicons.bx_shield_quarter, size: 16, color: isDark ? Colors.white54 : Colors.black54),
                const SizedBox(width: 8),
                Text(
                  "Your PIN is encrypted and secure",
                  style: TextStyle(color: isDark ? Colors.white54 : Colors.black54, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: isDark 
              ? [const Color(0xFF14231A), const Color(0xFF1A1F24)] 
              : [const Color(0xFFF4FBF7), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Keep your account secure",
                  style: TextStyle(color: Color(0xFF00C853), fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  "Your transaction PIN is used to confirm payments, withdrawals and sensitive actions.",
                  style: TextStyle(color: isDark ? Colors.white70 : Colors.black87, fontSize: 12, height: 1.5),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF00C853).withOpacity(0.1),
                    boxShadow: [
                      BoxShadow(color: const Color(0xFF00C853).withOpacity(0.2), blurRadius: 20, spreadRadius: 5)
                    ]
                  ),
                ),
                const Icon(Boxicons.bx_shield_quarter, color: Color(0xFF00C853), size: 50),
                const Positioned(
                  child: Icon(Boxicons.bx_lock_alt, color: Colors.white, size: 20),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStepIndicator(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepNode(1, "Verify", isDark, _activeStep >= 1),
        _buildStepLine(isDark, _activeStep >= 2),
        _buildStepNode(2, "New PIN", isDark, _activeStep >= 2),
        _buildStepLine(isDark, _activeStep >= 3),
        _buildStepNode(3, "Confirm", isDark, _activeStep >= 3),
      ],
    );
  }

  Widget _buildStepNode(int step, String label, bool isDark, bool isActive) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF00C853) : (isDark ? Colors.white10 : Colors.black12),
            shape: BoxShape.circle,
            boxShadow: isActive ? [BoxShadow(color: const Color(0xFF00C853).withOpacity(0.3), blurRadius: 8)] : [],
          ),
          child: Center(
            child: Text(
              step.toString(),
              style: TextStyle(
                color: isActive ? Colors.white : (isDark ? Colors.white54 : Colors.black54),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? (isDark ? Colors.white : Colors.black) : (isDark ? Colors.white54 : Colors.black54),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        )
      ],
    );
  }

  Widget _buildStepLine(bool isDark, bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 40,
      height: 2,
      margin: const EdgeInsets.only(bottom: 24, left: 8, right: 8),
      color: isActive ? const Color(0xFF00C853) : (isDark ? Colors.white10 : Colors.black12),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildPinTipsCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF12221A) : const Color(0xFFF2FAF5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF00C853),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Boxicons.bx_lock_alt, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 12),
              const Text("PIN Tips", style: TextStyle(color: Color(0xFF00C853), fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          _buildTipRow("Use 4 unique numbers", isDark),
          _buildTipRow("Avoid using the same number", isDark),
          _buildTipRow("Don't use easy combinations", isDark),
          _buildTipRow("Keep your PIN private", isDark),
        ],
      ),
    );
  }

  Widget _buildTipRow(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          const Icon(Boxicons.bx_check, color: Color(0xFF00C853), size: 18),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(color: isDark ? Colors.white70 : Colors.black87, fontSize: 13)),
        ],
      ),
    );
  }
}