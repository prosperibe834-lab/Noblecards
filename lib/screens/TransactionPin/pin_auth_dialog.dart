import 'package:flutter/material.dart';

import '../../theme/app_animation.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_shadow.dart';
import 'models/transaction_pin_context.dart';
import 'widgets/pin_biometric_row.dart';
import 'widgets/pin_input_boxes.dart';
import 'widgets/pin_numeric_keypad.dart';
import 'widgets/pin_security_visual.dart';

class PinInputWidget extends StatefulWidget {
  final TransactionPinContext contextData;
  final Future<bool> Function(String pin)? onValidatePin;
  final Future<bool> Function()? onAuthenticateBiometric;
  final ValueChanged<bool>? onSuccess;

  const PinInputWidget({
    super.key,
    this.contextData = const TransactionPinContext(),
    this.onValidatePin,
    this.onAuthenticateBiometric,
    this.onSuccess,
  });

  /// Static trigger method to show the Bottom Sheet from any screen
  static Future<bool?> show(
    BuildContext context, {
    TransactionPinContext contextData = const TransactionPinContext(),
    Future<bool> Function(String pin)? onValidatePin,
    Future<bool> Function()? onAuthenticateBiometric,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.65),
      builder: (modalContext) => PinInputWidget(
        contextData: contextData,
        onValidatePin: onValidatePin,
        onAuthenticateBiometric: onAuthenticateBiometric,
      ),
    );
  }

  @override
  State<PinInputWidget> createState() => _PinInputWidgetState();
}

typedef PinAuthDialog = PinInputWidget;

class _PinInputWidgetState extends State<PinInputWidget>
    with SingleTickerProviderStateMixin {
  String _enteredPin = '';
  bool _isLoading = false;
  bool _isError = false;
  String? _errorMessage;
  bool _isBiometricEnabled = true;

  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: AppAnimation.normal,
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _handleKeyPress(String value) {
    if (_isLoading || _enteredPin.length >= 4) return;

    setState(() {
      _isError = false;
      _errorMessage = null;
      _enteredPin += value;
    });

    if (_enteredPin.length == 4) {
      _processPinSubmission(_enteredPin);
    }
  }

  void _handleDelete() {
    if (_isLoading || _enteredPin.isEmpty) return;

    setState(() {
      _isError = false;
      _errorMessage = null;
      _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
    });
  }

  Future<void> _processPinSubmission(String pin) async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.onValidatePin == null) {
        _triggerErrorState('PIN verification is not configured.');
        return;
      }

      final bool success = await widget.onValidatePin!(pin);

      if (!mounted) return;

      if (success) {
        widget.onSuccess?.call(true);
        Navigator.of(context).pop(true);
      } else {
        _triggerErrorState('Incorrect PIN. Please try again.');
      }
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '').trim();
      _triggerErrorState(errorMessage.isNotEmpty ? errorMessage : 'Authentication failed. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleBiometricAuth() async {
    if (_isLoading || !_isBiometricEnabled) return;

    setState(() {
      _isLoading = true;
      _isError = false;
      _errorMessage = null;
    });

    try {
      if (widget.onAuthenticateBiometric == null) {
        _triggerErrorState('Biometric authentication is not configured.');
        return;
      }

      final bool success = await widget.onAuthenticateBiometric!();

      if (!mounted) return;

      if (success) {
        widget.onSuccess?.call(true);
        Navigator.of(context).pop(true);
      } else {
        _triggerErrorState('Biometric authentication failed.');
      }
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '').trim();
      _triggerErrorState(errorMessage.isNotEmpty ? errorMessage : 'Biometrics unavailable.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _triggerErrorState(String message) {
    setState(() {
      _isError = true;
      _errorMessage = message;
      _enteredPin = '';
    });
    _shakeController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mediaQuery = MediaQuery.of(context);

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: mediaQuery.padding.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppRadius.xl),
          topRight: Radius.circular(AppRadius.xl),
        ),
        boxShadow: isDark ? AppShadow.dark : AppShadow.light,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top Bar: Drag Handle & Close Button
            Stack(
              alignment: Alignment.center,
              children: [
                // Pill Handle
                Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                ),
                // Close 'X' Button
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    icon: Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: isDark
                          ? AppColors.darkSubText
                          : AppColors.lightSubText,
                    ),
                    splashRadius: 20,
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Security Shield Visual
            const PinSecurityVisual(),
            const SizedBox(height: 12),

            // Title
            Text(
              widget.contextData.title,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),

            // Dynamic Subtitle
            Text(
              widget.contextData.subtitle,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                height: 1.35,
                color: isDark ? AppColors.darkSubText : AppColors.lightSubText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // 4 PIN Boxes
            PinInputBoxes(
              pin: _enteredPin,
              isError: _isError,
              shakeAnimation: _shakeController,
            ),

            // Error / Loading indicator row
            SizedBox(
              height: 30,
              child: Center(
                child: _isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      )
                    : (_errorMessage != null
                        ? Text(
                            _errorMessage!,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: AppColors.error,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : const SizedBox.shrink()),
              ),
            ),

            // Biometric Option Row
            PinBiometricRow(
              isBiometricEnabled: _isBiometricEnabled,
              onToggleChanged: (val) {
                setState(() {
                  _isBiometricEnabled = val;
                });
              },
              onBiometricTap: _handleBiometricAuth,
            ),
            const SizedBox(height: 20),

            // Custom Keypad
            PinNumericKeypad(
              onKeyPress: _handleKeyPress,
              onDelete: _handleDelete,
              isDisabled: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}